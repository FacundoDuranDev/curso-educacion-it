# 🔥 TRIGGERS POSTGRESQL - GUÍA COMPLETA

> **🎯 Objetivo:** Dominar triggers para auditoría, validación automática y métricas en tiempo real

## 🚀 **¿QUÉ SON LOS TRIGGERS?**

### **📋 Definición:**
Los **triggers** son funciones especiales que se ejecutan automáticamente en respuesta a eventos específicos en la base de datos:

- 🔥 **BEFORE/AFTER** operaciones (INSERT, UPDATE, DELETE)
- ⚡ **Automáticos** - No requieren invocación manual
- 🎯 **Específicos por tabla** - Cada trigger se asocia a una tabla
- 💪 **Poderosos** - Pueden modificar datos, validar, auditar, etc.

### **🎯 Casos de Uso Principales:**
```
✅ AUDITORÍA: Registrar quién cambió qué y cuándo
✅ VALIDACIÓN: Reglas de negocio complejas
✅ MÉTRICAS: Calcular totales y estadísticas automáticamente
✅ SINCRONIZACIÓN: Mantener datos relacionados actualizados
✅ NOTIFICACIONES: Alertas automáticas por cambios
✅ LOGGING: Registro detallado de actividad
```

---

## 🏗️ **SISTEMA DE TRIGGERS IMPLEMENTADO**

### **📊 Arquitectura General:**
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   TABLA MAIN    │    │    TRIGGERS     │    │  TABLAS AUX     │
│   (clientes,    │───▶│   (auditoría,   │───▶│  (auditoria_    │
│   ventas, etc.) │    │   métricas)     │    │   metricas)     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### **🗄️ Tablas del Sistema:**

#### **1. Tabla de Auditoría General**
```sql
CREATE TABLE IF NOT EXISTS auditoria_general (
    id SERIAL PRIMARY KEY,
    tabla VARCHAR(100),                    -- Tabla donde ocurrió el cambio
    operacion VARCHAR(10),                 -- INSERT, UPDATE, DELETE
    id_registro INTEGER,                   -- ID del registro afectado
    fecha_operacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(50) DEFAULT CURRENT_USER,
    datos_anteriores JSONB,               -- Estado anterior (UPDATE/DELETE)
    datos_nuevos JSONB,                   -- Estado nuevo (INSERT/UPDATE)
    ip_cliente INET DEFAULT inet_client_addr()
);

-- Índices para consultas rápidas
CREATE INDEX IF NOT EXISTS idx_auditoria_tabla_fecha 
ON auditoria_general(tabla, fecha_operacion DESC);

CREATE INDEX IF NOT EXISTS idx_auditoria_usuario 
ON auditoria_general(usuario);
```

#### **2. Tabla de Métricas de Clientes**
```sql
CREATE TABLE IF NOT EXISTS metricas_clientes (
    id_cliente INTEGER PRIMARY KEY,
    total_ventas DECIMAL(15,2) DEFAULT 0,     -- Suma total de compras
    cantidad_ventas INTEGER DEFAULT 0,        -- Número de transacciones
    ticket_promedio DECIMAL(10,2) DEFAULT 0, -- Promedio por compra
    ultima_compra DATE,                       -- Fecha última compra
    primera_compra DATE,                      -- Fecha primera compra
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### **3. Tabla de Métricas de Productos**
```sql
CREATE TABLE IF NOT EXISTS metricas_productos (
    id_producto INTEGER PRIMARY KEY,
    total_vendido INTEGER DEFAULT 0,         -- Unidades vendidas
    ingresos_generados DECIMAL(15,2) DEFAULT 0,
    veces_vendido INTEGER DEFAULT 0,         -- Número de transacciones
    precio_promedio_venta DECIMAL(10,2) DEFAULT 0,
    ultima_venta DATE,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 🔧 **FUNCIÓN UNIVERSAL DE AUDITORÍA**

### **⚡ Función Genérica para Todas las Tablas:**

```sql
CREATE OR REPLACE FUNCTION auditoria_universal() 
RETURNS TRIGGER AS $$
BEGIN
    -- Manejar INSERT
    IF TG_OP = 'INSERT' THEN
        INSERT INTO auditoria_general (
            tabla, 
            operacion, 
            id_registro, 
            datos_nuevos
        ) VALUES (
            TG_TABLE_NAME,
            TG_OP,
            CASE TG_TABLE_NAME
                WHEN 'clientes' THEN NEW.id_cliente
                WHEN 'productos' THEN NEW.id_producto
                WHEN 'ventas' THEN NEW.id_venta
                WHEN 'empleados' THEN NEW.id_empleado
                WHEN 'sucursales' THEN NEW.id_sucursal
                WHEN 'proveedores' THEN NEW.id_proveedor
                WHEN 'gastos' THEN NEW.id_gasto
                WHEN 'compras' THEN NEW.id_compra
                ELSE NULL
            END,
            to_jsonb(NEW)
        );
        RETURN NEW;
    END IF;

    -- Manejar UPDATE
    IF TG_OP = 'UPDATE' THEN
        INSERT INTO auditoria_general (
            tabla, 
            operacion, 
            id_registro, 
            datos_anteriores, 
            datos_nuevos
        ) VALUES (
            TG_TABLE_NAME,
            TG_OP,
            CASE TG_TABLE_NAME
                WHEN 'clientes' THEN NEW.id_cliente
                WHEN 'productos' THEN NEW.id_producto
                WHEN 'ventas' THEN NEW.id_venta
                WHEN 'empleados' THEN NEW.id_empleado
                WHEN 'sucursales' THEN NEW.id_sucursal
                WHEN 'proveedores' THEN NEW.id_proveedor
                WHEN 'gastos' THEN NEW.id_gasto
                WHEN 'compras' THEN NEW.id_compra
                ELSE NULL
            END,
            to_jsonb(OLD),
            to_jsonb(NEW)
        );
        RETURN NEW;
    END IF;

    -- Manejar DELETE
    IF TG_OP = 'DELETE' THEN
        INSERT INTO auditoria_general (
            tabla, 
            operacion, 
            id_registro, 
            datos_anteriores
        ) VALUES (
            TG_TABLE_NAME,
            TG_OP,
            CASE TG_TABLE_NAME
                WHEN 'clientes' THEN OLD.id_cliente
                WHEN 'productos' THEN OLD.id_producto
                WHEN 'ventas' THEN OLD.id_venta
                WHEN 'empleados' THEN OLD.id_empleado
                WHEN 'sucursales' THEN OLD.id_sucursal
                WHEN 'proveedores' THEN OLD.id_proveedor
                WHEN 'gastos' THEN OLD.id_gasto
                WHEN 'compras' THEN OLD.id_compra
                ELSE NULL
            END,
            to_jsonb(OLD)
        );
        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
```

---

## 📊 **TRIGGERS DE MÉTRICAS AUTOMÁTICAS**

### **🎯 Métricas de Clientes en Tiempo Real:**

```sql
CREATE OR REPLACE FUNCTION actualizar_metricas_cliente() 
RETURNS TRIGGER AS $$
DECLARE
    cliente_id INTEGER;
    nuevo_total DECIMAL(15,2);
    nueva_cantidad INTEGER;
    nuevo_promedio DECIMAL(10,2);
    fecha_primera DATE;
    fecha_ultima DATE;
BEGIN
    -- Determinar ID del cliente según la operación
    IF TG_OP = 'DELETE' THEN
        cliente_id := OLD.id_cliente;
    ELSE
        cliente_id := NEW.id_cliente;
    END IF;

    -- Calcular métricas actualizadas
    SELECT 
        COALESCE(SUM(precio * cantidad), 0),
        COUNT(*),
        COALESCE(AVG(precio * cantidad), 0),
        MIN(fecha_venta),
        MAX(fecha_venta)
    INTO nuevo_total, nueva_cantidad, nuevo_promedio, fecha_primera, fecha_ultima
    FROM ventas 
    WHERE id_cliente = cliente_id;

    -- Insertar o actualizar métricas
    INSERT INTO metricas_clientes (
        id_cliente, 
        total_ventas, 
        cantidad_ventas, 
        ticket_promedio,
        primera_compra,
        ultima_compra,
        fecha_actualizacion
    ) VALUES (
        cliente_id, 
        nuevo_total, 
        nueva_cantidad, 
        nuevo_promedio,
        fecha_primera,
        fecha_ultima,
        CURRENT_TIMESTAMP
    )
    ON CONFLICT (id_cliente) DO UPDATE SET
        total_ventas = EXCLUDED.total_ventas,
        cantidad_ventas = EXCLUDED.cantidad_ventas,
        ticket_promedio = EXCLUDED.ticket_promedio,
        primera_compra = EXCLUDED.primera_compra,
        ultima_compra = EXCLUDED.ultima_compra,
        fecha_actualizacion = CURRENT_TIMESTAMP;

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;
```

### **📈 Métricas de Productos:**

```sql
CREATE OR REPLACE FUNCTION actualizar_metricas_producto() 
RETURNS TRIGGER AS $$
DECLARE
    producto_id INTEGER;
    nuevo_total_unidades INTEGER;
    nuevos_ingresos DECIMAL(15,2);
    nuevas_transacciones INTEGER;
    nuevo_precio_promedio DECIMAL(10,2);
    fecha_ultima_venta DATE;
BEGIN
    -- Determinar ID del producto
    IF TG_OP = 'DELETE' THEN
        producto_id := OLD.id_producto;
    ELSE
        producto_id := NEW.id_producto;
    END IF;

    -- Calcular métricas del producto
    SELECT 
        COALESCE(SUM(cantidad), 0),
        COALESCE(SUM(precio * cantidad), 0),
        COUNT(*),
        COALESCE(AVG(precio), 0),
        MAX(fecha_venta)
    INTO nuevo_total_unidades, nuevos_ingresos, nuevas_transacciones, 
         nuevo_precio_promedio, fecha_ultima_venta
    FROM ventas 
    WHERE id_producto = producto_id;

    -- Actualizar métricas
    INSERT INTO metricas_productos (
        id_producto, 
        total_vendido, 
        ingresos_generados, 
        veces_vendido,
        precio_promedio_venta,
        ultima_venta,
        fecha_actualizacion
    ) VALUES (
        producto_id, 
        nuevo_total_unidades, 
        nuevos_ingresos, 
        nuevas_transacciones,
        nuevo_precio_promedio,
        fecha_ultima_venta,
        CURRENT_TIMESTAMP
    )
    ON CONFLICT (id_producto) DO UPDATE SET
        total_vendido = EXCLUDED.total_vendido,
        ingresos_generados = EXCLUDED.ingresos_generados,
        veces_vendido = EXCLUDED.veces_vendido,
        precio_promedio_venta = EXCLUDED.precio_promedio_venta,
        ultima_venta = EXCLUDED.ultima_venta,
        fecha_actualizacion = CURRENT_TIMESTAMP;

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;
```

---

## 🛡️ **TRIGGERS DE VALIDACIÓN**

### **✅ Validación de Datos de Clientes:**

```sql
CREATE OR REPLACE FUNCTION validar_cliente() 
RETURNS TRIGGER AS $$
BEGIN
    -- Validar email
    IF NEW.email IS NOT NULL AND NEW.email !~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' THEN
        RAISE EXCEPTION 'Email inválido: %', NEW.email;
    END IF;

    -- Validar edad
    IF NEW.edad IS NOT NULL AND (NEW.edad < 18 OR NEW.edad > 120) THEN
        RAISE EXCEPTION 'Edad debe estar entre 18 y 120 años: %', NEW.edad;
    END IF;

    -- Validar teléfono (solo números, espacios y guiones)
    IF NEW.telefono IS NOT NULL AND NEW.telefono !~ '^[0-9\s\-\+\(\)]+$' THEN
        RAISE EXCEPTION 'Teléfono contiene caracteres inválidos: %', NEW.telefono;
    END IF;

    -- Normalizar nombre (capitalizar primera letra de cada palabra)
    IF NEW.nombre_completo IS NOT NULL THEN
        NEW.nombre_completo := initcap(trim(NEW.nombre_completo));
    END IF;

    -- Normalizar email (minúsculas)
    IF NEW.email IS NOT NULL THEN
        NEW.email := lower(trim(NEW.email));
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

### **💰 Validación de Ventas:**

```sql
CREATE OR REPLACE FUNCTION validar_venta() 
RETURNS TRIGGER AS $$
BEGIN
    -- Validar que el precio sea positivo
    IF NEW.precio <= 0 THEN
        RAISE EXCEPTION 'El precio debe ser mayor a 0: %', NEW.precio;
    END IF;

    -- Validar que la cantidad sea positiva
    IF NEW.cantidad <= 0 THEN
        RAISE EXCEPTION 'La cantidad debe ser mayor a 0: %', NEW.cantidad;
    END IF;

    -- Validar que la fecha no sea futura
    IF NEW.fecha_venta > CURRENT_DATE THEN
        RAISE EXCEPTION 'La fecha de venta no puede ser futura: %', NEW.fecha_venta;
    END IF;

    -- Validar que el cliente existe
    IF NOT EXISTS (SELECT 1 FROM clientes WHERE id_cliente = NEW.id_cliente) THEN
        RAISE EXCEPTION 'Cliente no existe: %', NEW.id_cliente;
    END IF;

    -- Validar que el producto existe
    IF NOT EXISTS (SELECT 1 FROM productos WHERE id_producto = NEW.id_producto) THEN
        RAISE EXCEPTION 'Producto no existe: %', NEW.id_producto;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

---

## 🔗 **CREACIÓN DE TODOS LOS TRIGGERS**

### **📋 Script Completo de Instalación:**

```sql
-- ===============================================
-- CREAR TRIGGERS DE AUDITORÍA PARA TODAS LAS TABLAS
-- ===============================================

-- Clientes
DROP TRIGGER IF EXISTS trigger_auditoria_clientes ON clientes;
CREATE TRIGGER trigger_auditoria_clientes
    AFTER INSERT OR UPDATE OR DELETE ON clientes
    FOR EACH ROW EXECUTE FUNCTION auditoria_universal();

-- Productos  
DROP TRIGGER IF EXISTS trigger_auditoria_productos ON productos;
CREATE TRIGGER trigger_auditoria_productos
    AFTER INSERT OR UPDATE OR DELETE ON productos
    FOR EACH ROW EXECUTE FUNCTION auditoria_universal();

-- Ventas
DROP TRIGGER IF EXISTS trigger_auditoria_ventas ON ventas;
CREATE TRIGGER trigger_auditoria_ventas
    AFTER INSERT OR UPDATE OR DELETE ON ventas
    FOR EACH ROW EXECUTE FUNCTION auditoria_universal();

-- Empleados
DROP TRIGGER IF EXISTS trigger_auditoria_empleados ON empleados;
CREATE TRIGGER trigger_auditoria_empleados
    AFTER INSERT OR UPDATE OR DELETE ON empleados
    FOR EACH ROW EXECUTE FUNCTION auditoria_universal();

-- Sucursales
DROP TRIGGER IF EXISTS trigger_auditoria_sucursales ON sucursales;
CREATE TRIGGER trigger_auditoria_sucursales
    AFTER INSERT OR UPDATE OR DELETE ON sucursales
    FOR EACH ROW EXECUTE FUNCTION auditoria_universal();

-- Proveedores
DROP TRIGGER IF EXISTS trigger_auditoria_proveedores ON proveedores;
CREATE TRIGGER trigger_auditoria_proveedores
    AFTER INSERT OR UPDATE OR DELETE ON proveedores
    FOR EACH ROW EXECUTE FUNCTION auditoria_universal();

-- Gastos
DROP TRIGGER IF EXISTS trigger_auditoria_gastos ON gastos;
CREATE TRIGGER trigger_auditoria_gastos
    AFTER INSERT OR UPDATE OR DELETE ON gastos
    FOR EACH ROW EXECUTE FUNCTION auditoria_universal();

-- Compras
DROP TRIGGER IF EXISTS trigger_auditoria_compras ON compras;
CREATE TRIGGER trigger_auditoria_compras
    AFTER INSERT OR UPDATE OR DELETE ON compras
    FOR EACH ROW EXECUTE FUNCTION auditoria_universal();

-- ===============================================
-- TRIGGERS DE MÉTRICAS AUTOMÁTICAS
-- ===============================================

-- Métricas de clientes (cuando cambian las ventas)
DROP TRIGGER IF EXISTS trigger_metricas_cliente_ventas ON ventas;
CREATE TRIGGER trigger_metricas_cliente_ventas
    AFTER INSERT OR UPDATE OR DELETE ON ventas
    FOR EACH ROW EXECUTE FUNCTION actualizar_metricas_cliente();

-- Métricas de productos (cuando cambian las ventas)
DROP TRIGGER IF EXISTS trigger_metricas_producto_ventas ON ventas;
CREATE TRIGGER trigger_metricas_producto_ventas
    AFTER INSERT OR UPDATE OR DELETE ON ventas
    FOR EACH ROW EXECUTE FUNCTION actualizar_metricas_producto();

-- ===============================================
-- TRIGGERS DE VALIDACIÓN
-- ===============================================

-- Validación de clientes
DROP TRIGGER IF EXISTS trigger_validar_cliente ON clientes;
CREATE TRIGGER trigger_validar_cliente
    BEFORE INSERT OR UPDATE ON clientes
    FOR EACH ROW EXECUTE FUNCTION validar_cliente();

-- Validación de ventas
DROP TRIGGER IF EXISTS trigger_validar_venta ON ventas;
CREATE TRIGGER trigger_validar_venta
    BEFORE INSERT OR UPDATE ON ventas
    FOR EACH ROW EXECUTE FUNCTION validar_venta();
```

---

## 🧪 **PRUEBAS Y EJEMPLOS**

### **🔍 Probar Auditoría:**

```sql
-- Insertar un nuevo cliente
INSERT INTO clientes (nombre_completo, email, telefono, ciudad, edad) 
VALUES ('Carlos Trigger', 'carlos@trigger.com', '555-9999', 'Madrid', 35);

-- Ver el registro de auditoría
SELECT 
    tabla,
    operacion,
    fecha_operacion,
    usuario,
    datos_nuevos->>'nombre_completo' as nombre,
    datos_nuevos->>'email' as email
FROM auditoria_general 
WHERE tabla = 'clientes' 
ORDER BY fecha_operacion DESC 
LIMIT 5;
```

### **📊 Probar Métricas Automáticas:**

```sql
-- Insertar una venta
INSERT INTO ventas (id_cliente, id_producto, cantidad, precio, fecha_venta)
VALUES (1, 1, 2, 100.00, CURRENT_DATE);

-- Ver métricas actualizadas automáticamente
SELECT 
    c.nombre_completo,
    mc.total_ventas,
    mc.cantidad_ventas,
    mc.ticket_promedio,
    mc.ultima_compra
FROM clientes c
JOIN metricas_clientes mc ON c.id_cliente = mc.id_cliente
WHERE c.id_cliente = 1;
```

### **🛡️ Probar Validaciones:**

```sql
-- Intentar insertar email inválido (debe fallar)
INSERT INTO clientes (nombre_completo, email, edad) 
VALUES ('Test Validation', 'email-malo', 25);

-- Intentar insertar edad inválida (debe fallar)
INSERT INTO clientes (nombre_completo, email, edad) 
VALUES ('Test Validation', 'test@email.com', 150);

-- Intentar insertar venta con precio negativo (debe fallar)
INSERT INTO ventas (id_cliente, id_producto, cantidad, precio)
VALUES (1, 1, 1, -50.00);
```

---

## 📈 **CONSULTAS DE ANÁLISIS**

### **🔍 Análisis de Auditoría:**

```sql
-- Actividad por tabla en los últimos 7 días
SELECT 
    tabla,
    operacion,
    COUNT(*) as total_operaciones,
    COUNT(DISTINCT usuario) as usuarios_distintos
FROM auditoria_general 
WHERE fecha_operacion >= CURRENT_DATE - INTERVAL '7 days'
GROUP BY tabla, operacion
ORDER BY total_operaciones DESC;

-- Usuarios más activos
SELECT 
    usuario,
    COUNT(*) as total_operaciones,
    COUNT(DISTINCT tabla) as tablas_modificadas,
    MIN(fecha_operacion) as primera_actividad,
    MAX(fecha_operacion) as ultima_actividad
FROM auditoria_general 
WHERE fecha_operacion >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY usuario
ORDER BY total_operaciones DESC;

-- Cambios en un registro específico
SELECT 
    fecha_operacion,
    operacion,
    usuario,
    datos_anteriores,
    datos_nuevos
FROM auditoria_general 
WHERE tabla = 'clientes' AND id_registro = 1
ORDER BY fecha_operacion DESC;
```

### **📊 Dashboard de Métricas:**

```sql
-- Top 10 clientes por valor
SELECT 
    c.nombre_completo,
    c.ciudad,
    mc.total_ventas,
    mc.cantidad_ventas,
    mc.ticket_promedio,
    mc.ultima_compra,
    CASE 
        WHEN mc.ultima_compra >= CURRENT_DATE - INTERVAL '30 days' THEN 'Activo'
        WHEN mc.ultima_compra >= CURRENT_DATE - INTERVAL '90 days' THEN 'Inactivo'
        ELSE 'Perdido'
    END as estado_cliente
FROM clientes c
JOIN metricas_clientes mc ON c.id_cliente = mc.id_cliente
ORDER BY mc.total_ventas DESC
LIMIT 10;

-- Productos más rentables
SELECT 
    p.nombre_producto,
    p.precio as precio_actual,
    mp.total_vendido,
    mp.ingresos_generados,
    mp.veces_vendido,
    mp.precio_promedio_venta,
    mp.ultima_venta,
    ROUND(mp.ingresos_generados / NULLIF(mp.total_vendido, 0), 2) as precio_promedio_unitario
FROM productos p
JOIN metricas_productos mp ON p.id_producto = mp.id_producto
WHERE mp.total_vendido > 0
ORDER BY mp.ingresos_generados DESC
LIMIT 10;
```

---

## 🔧 **MANTENIMIENTO DE TRIGGERS**

### **🧹 Limpieza de Auditoría:**

```sql
-- Función para limpiar auditoría antigua
CREATE OR REPLACE FUNCTION limpiar_auditoria_antigua(dias_antiguedad INTEGER DEFAULT 90)
RETURNS INTEGER AS $$
DECLARE
    registros_eliminados INTEGER;
BEGIN
    DELETE FROM auditoria_general 
    WHERE fecha_operacion < CURRENT_DATE - INTERVAL '1 day' * dias_antiguedad;
    
    GET DIAGNOSTICS registros_eliminados = ROW_COUNT;
    
    RAISE NOTICE 'Eliminados % registros de auditoría anteriores a % días', 
                 registros_eliminados, dias_antiguedad;
    
    RETURN registros_eliminados;
END;
$$ LANGUAGE plpgsql;

-- Ejecutar limpieza (eliminar registros > 90 días)
SELECT limpiar_auditoria_antigua(90);
```

### **📊 Recalcular Métricas:**

```sql
-- Función para recalcular todas las métricas
CREATE OR REPLACE FUNCTION recalcular_metricas()
RETURNS VOID AS $$
BEGIN
    -- Limpiar métricas existentes
    TRUNCATE TABLE metricas_clientes;
    TRUNCATE TABLE metricas_productos;
    
    -- Recalcular métricas de clientes
    INSERT INTO metricas_clientes (
        id_cliente, total_ventas, cantidad_ventas, ticket_promedio,
        primera_compra, ultima_compra, fecha_actualizacion
    )
    SELECT 
        v.id_cliente,
        SUM(v.precio * v.cantidad),
        COUNT(*),
        AVG(v.precio * v.cantidad),
        MIN(v.fecha_venta),
        MAX(v.fecha_venta),
        CURRENT_TIMESTAMP
    FROM ventas v
    GROUP BY v.id_cliente;
    
    -- Recalcular métricas de productos
    INSERT INTO metricas_productos (
        id_producto, total_vendido, ingresos_generados, veces_vendido,
        precio_promedio_venta, ultima_venta, fecha_actualizacion
    )
    SELECT 
        v.id_producto,
        SUM(v.cantidad),
        SUM(v.precio * v.cantidad),
        COUNT(*),
        AVG(v.precio),
        MAX(v.fecha_venta),
        CURRENT_TIMESTAMP
    FROM ventas v
    GROUP BY v.id_producto;
    
    RAISE NOTICE 'Métricas recalculadas exitosamente';
END;
$$ LANGUAGE plpgsql;

-- Ejecutar recálculo
SELECT recalcular_metricas();
```

---

## 🚨 **TROUBLESHOOTING**

### **❌ Problemas Comunes:**

#### **1. Trigger no se ejecuta:**
```sql
-- Verificar que el trigger existe
SELECT 
    schemaname,
    tablename,
    triggername,
    definition
FROM pg_triggers 
WHERE tablename = 'clientes';

-- Verificar que la función existe
SELECT proname, prosrc 
FROM pg_proc 
WHERE proname = 'auditoria_universal';
```

#### **2. Error en función de trigger:**
```sql
-- Ver logs de PostgreSQL para errores detallados
SELECT * FROM pg_stat_activity WHERE state = 'active';

-- Probar función manualmente
SELECT auditoria_universal();
```

#### **3. Rendimiento lento:**
```sql
-- Ver triggers que más tiempo consumen
SELECT 
    schemaname,
    tablename,
    triggername,
    calls,
    total_time,
    mean_time
FROM pg_stat_user_functions
WHERE schemaname = 'public'
ORDER BY total_time DESC;

-- Crear índices para mejorar rendimiento
CREATE INDEX IF NOT EXISTS idx_auditoria_tabla_fecha 
ON auditoria_general(tabla, fecha_operacion DESC);
```

---

## 💡 **MEJORES PRÁCTICAS**

### **✅ Recomendaciones:**

1. **Usar BEFORE para validación, AFTER para auditoría**
2. **Mantener funciones simples y rápidas**
3. **Crear índices en tablas de auditoría**
4. **Limpiar auditoría antigua regularmente**
5. **Documentar lógica de negocio en comentarios**
6. **Probar exhaustivamente antes de producción**

### **⚠️ Precauciones:**

1. **Triggers pueden impactar rendimiento**
2. **Errores en triggers abortan toda la transacción**
3. **Triggers recursivos pueden causar bucles infinitos**
4. **Cambios en esquema requieren actualizar triggers**

---

## 🔗 **RECURSOS ADICIONALES**

### **📚 Guías Relacionadas:**
- **Tutorial SQL:** `../../05-EXERCISES/sql-queries/tutorial-sql.md`
- **Normalización:** `../database-design/normalizacion.md`
- **Calidad de datos:** `../../05-EXERCISES/data-quality/ejercicios-calidad.md`

### **🛠️ Scripts Disponibles:**
```bash
# Archivo con todos los triggers implementados
scripts/crear_triggers.sql

# Ejecutar en PostgreSQL:
psql -U admin -d educacionit -f scripts/crear_triggers.sql
```

### **📖 Documentación:**
- PostgreSQL Trigger Documentation
- PL/pgSQL Language Guide
- Performance Tuning for Triggers

---

## 🆘 **¿NECESITAS AYUDA?**

### **🚨 Problemas Comunes:**
- **Trigger no funciona:** Verificar sintaxis y permisos
- **Rendimiento lento:** Optimizar consultas en funciones
- **Errores de validación:** Revisar lógica de negocio

### **📞 Soporte:**
- **Instructor:** Consulta casos específicos en clase
- **Documentación:** PostgreSQL official trigger docs
- **Community:** PostgreSQL forums y Stack Overflow

**🎯 ¡Con estos triggers tendrás un sistema completo de auditoría, validación y métricas automáticas!**
