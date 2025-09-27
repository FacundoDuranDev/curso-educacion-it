# 🔍 EJERCICIOS DE CALIDAD DE DATOS

> **🎯 Objetivo:** Evaluar y mejorar la calidad de los datos en el sistema usando técnicas profesionales

## 🚀 **PREPARACIÓN**

### **📋 Antes de Empezar:**
1. **Conectar a PostgreSQL** → `../../02-HOW-TO-GUIDES/postgresql/conexion-dbeaver.md`
2. **Verificar datos disponibles** → `SELECT count(*) FROM clientes;`
3. **Crear esquema de trabajo** → `CREATE SCHEMA data_quality;`

### **🗄️ Datos para Análisis:**
```sql
-- Tablas principales para evaluar:
clientes, productos, ventas, empleados, sucursales, 
proveedores, gastos, tiposdegasto, canaldeventa, compras
```

---

## 📊 **EJERCICIO 1: ANÁLISIS DE ACTUALIZACIÓN DE DATOS**

### **🎯 Objetivo:** 
Evaluar la actualidad y mantenimiento de la información en el sistema

### **📋 Tareas:**

#### **1.1 Verificar Última Fecha de Actualización**
```sql
-- Análisis de fechas en tabla ventas
SELECT 
    'ventas' as tabla,
    MIN(fecha_venta) as fecha_mas_antigua,
    MAX(fecha_venta) as fecha_mas_reciente,
    COUNT(*) as total_registros,
    CURRENT_DATE - MAX(fecha_venta) as dias_desde_ultima_actualizacion
FROM ventas;

-- Análisis por mes para identificar patrones
SELECT 
    DATE_TRUNC('month', fecha_venta) as mes,
    COUNT(*) as registros_mes,
    SUM(precio * cantidad) as ingresos_mes
FROM ventas 
GROUP BY DATE_TRUNC('month', fecha_venta)
ORDER BY mes DESC;
```

#### **1.2 Documentar Proceso de Actualización**
```sql
-- Crear tabla de metadatos de actualización
CREATE TABLE data_quality.actualizacion_log (
    tabla_nombre VARCHAR(50),
    ultima_actualizacion TIMESTAMP,
    frecuencia_esperada VARCHAR(20),
    responsable VARCHAR(100),
    observaciones TEXT
);

-- Insertar información conocida
INSERT INTO data_quality.actualizacion_log VALUES
('clientes', '2024-01-15 10:30:00', 'Diaria', 'Sistema CRM', 'Actualización automática desde sistema de ventas'),
('productos', '2024-01-10 14:00:00', 'Semanal', 'Equipo Producto', 'Actualización manual de catálogo'),
('ventas', '2024-01-15 23:59:59', 'Tiempo real', 'Sistema POS', 'Sincronización automática cada hora');
```

#### **1.3 Proponer Mejoras**
```sql
-- Identificar tablas con datos antiguos
WITH analisis_fechas AS (
    SELECT 
        'ventas' as tabla,
        MAX(fecha_venta) as ultima_fecha,
        CURRENT_DATE - MAX(fecha_venta) as dias_antiguedad
    FROM ventas
    UNION ALL
    SELECT 
        'gastos' as tabla,
        MAX(fecha_gasto) as ultima_fecha,
        CURRENT_DATE - MAX(fecha_gasto) as dias_antiguedad
    FROM gastos
)
SELECT 
    tabla,
    ultima_fecha,
    dias_antiguedad,
    CASE 
        WHEN dias_antiguedad > 30 THEN 'CRÍTICO: Datos muy antiguos'
        WHEN dias_antiguedad > 7 THEN 'ADVERTENCIA: Datos desactualizados'
        ELSE 'OK: Datos recientes'
    END as estado_actualizacion
FROM analisis_fechas
ORDER BY dias_antiguedad DESC;
```

---

## 📋 **EJERCICIO 2: COMPLETITUD DE DATOS**

### **🎯 Objetivo:** 
Verificar la integridad y completitud de la información en todas las tablas

### **📋 Tareas:**

#### **2.1 Análisis de Campos Nulos por Tabla**
```sql
-- Función para analizar nulos en clientes
SELECT 
    'id_cliente' as campo,
    COUNT(*) as total_registros,
    COUNT(id_cliente) as registros_completos,
    COUNT(*) - COUNT(id_cliente) as registros_nulos,
    ROUND(100.0 * (COUNT(*) - COUNT(id_cliente)) / COUNT(*), 2) as porcentaje_nulos
FROM clientes
UNION ALL
SELECT 
    'nombre_completo' as campo,
    COUNT(*) as total_registros,
    COUNT(nombre_completo) as registros_completos,
    COUNT(*) - COUNT(nombre_completo) as registros_nulos,
    ROUND(100.0 * (COUNT(*) - COUNT(nombre_completo)) / COUNT(*), 2) as porcentaje_nulos
FROM clientes
UNION ALL
SELECT 
    'email' as campo,
    COUNT(*) as total_registros,
    COUNT(email) as registros_completos,
    COUNT(*) - COUNT(email) as registros_nulos,
    ROUND(100.0 * (COUNT(*) - COUNT(email)) / COUNT(*), 2) as porcentaje_nulos
FROM clientes
UNION ALL
SELECT 
    'telefono' as campo,
    COUNT(*) as total_registros,
    COUNT(telefono) as registros_completos,
    COUNT(*) - COUNT(telefono) as registros_nulos,
    ROUND(100.0 * (COUNT(*) - COUNT(telefono)) / COUNT(*), 2) as porcentaje_nulos
FROM clientes
UNION ALL
SELECT 
    'ciudad' as campo,
    COUNT(*) as total_registros,
    COUNT(ciudad) as registros_completos,
    COUNT(*) - COUNT(ciudad) as registros_nulos,
    ROUND(100.0 * (COUNT(*) - COUNT(ciudad)) / COUNT(*), 2) as porcentaje_nulos
FROM clientes
ORDER BY porcentaje_nulos DESC;
```

#### **2.2 Identificar Tablas con Datos Incompletos**
```sql
-- Crear vista de resumen de completitud
CREATE OR REPLACE VIEW data_quality.completitud_resumen AS
WITH completitud_clientes AS (
    SELECT 
        'clientes' as tabla,
        COUNT(*) as total_registros,
        COUNT(nombre_completo) as nombres_completos,
        COUNT(email) as emails_completos,
        COUNT(telefono) as telefonos_completos,
        COUNT(ciudad) as ciudades_completas
    FROM clientes
),
completitud_productos AS (
    SELECT 
        'productos' as tabla,
        COUNT(*) as total_registros,
        COUNT(nombre_producto) as nombres_completos,
        COUNT(precio) as precios_completos,
        COUNT(categoria) as categorias_completas
    FROM productos
)
SELECT 
    tabla,
    total_registros,
    ROUND(100.0 * nombres_completos / total_registros, 1) as completitud_nombre,
    CASE 
        WHEN tabla = 'clientes' THEN ROUND(100.0 * emails_completos / total_registros, 1)
        ELSE ROUND(100.0 * precios_completos / total_registros, 1)
    END as completitud_campo2,
    CASE 
        WHEN tabla = 'clientes' THEN ROUND(100.0 * telefonos_completos / total_registros, 1)
        ELSE ROUND(100.0 * categorias_completas / total_registros, 1)
    END as completitud_campo3
FROM completitud_clientes
UNION ALL
SELECT 
    tabla,
    total_registros,
    ROUND(100.0 * nombres_completos / total_registros, 1) as completitud_nombre,
    ROUND(100.0 * precios_completos / total_registros, 1) as completitud_precio,
    ROUND(100.0 * categorias_completas / total_registros, 1) as completitud_categoria
FROM completitud_productos;

-- Ver el resumen
SELECT * FROM data_quality.completitud_resumen;
```

#### **2.3 Estrategia para Completar Información Faltante**
```sql
-- Identificar patrones en datos faltantes
SELECT 
    ciudad,
    COUNT(*) as total_clientes,
    COUNT(email) as con_email,
    COUNT(telefono) as con_telefono,
    ROUND(100.0 * COUNT(email) / COUNT(*), 1) as porcentaje_email,
    ROUND(100.0 * COUNT(telefono) / COUNT(*), 1) as porcentaje_telefono
FROM clientes
GROUP BY ciudad
ORDER BY total_clientes DESC;

-- Crear plan de mejora
CREATE TABLE data_quality.plan_mejora_completitud (
    tabla VARCHAR(50),
    campo VARCHAR(50),
    porcentaje_faltante DECIMAL(5,2),
    prioridad VARCHAR(10),
    estrategia TEXT,
    responsable VARCHAR(100),
    fecha_objetivo DATE
);

INSERT INTO data_quality.plan_mejora_completitud VALUES
('clientes', 'email', 15.5, 'ALTA', 'Campaña de actualización de datos via SMS/llamada', 'Equipo CRM', '2024-02-15'),
('clientes', 'telefono', 8.2, 'MEDIA', 'Solicitar en próxima interacción con cliente', 'Vendedores', '2024-03-01'),
('productos', 'categoria', 12.1, 'ALTA', 'Revisión manual del catálogo de productos', 'Equipo Producto', '2024-02-01');
```

---

## 🔎 **EJERCICIO 3: TRAZABILIDAD DE DATOS**

### **🎯 Objetivo:** 
Identificar y documentar las fuentes de datos del sistema

### **📋 Tareas:**

#### **3.1 Mapear Origen de Cada Conjunto de Datos**
```sql
-- Crear tabla de linaje de datos
CREATE TABLE data_quality.linaje_datos (
    tabla_destino VARCHAR(50),
    campo_destino VARCHAR(50),
    sistema_origen VARCHAR(100),
    tabla_origen VARCHAR(50),
    campo_origen VARCHAR(50),
    tipo_transformacion VARCHAR(50),
    frecuencia_actualizacion VARCHAR(30),
    ultimo_proceso TIMESTAMP
);

-- Documentar linaje conocido
INSERT INTO data_quality.linaje_datos VALUES
('clientes', 'id_cliente', 'Sistema CRM', 'crm_customers', 'customer_id', 'Mapeo directo', 'Tiempo real', '2024-01-15 10:30:00'),
('clientes', 'nombre_completo', 'Sistema CRM', 'crm_customers', 'full_name', 'Concatenación nombre + apellido', 'Tiempo real', '2024-01-15 10:30:00'),
('clientes', 'email', 'Sistema CRM', 'crm_customers', 'email_address', 'Validación formato', 'Tiempo real', '2024-01-15 10:30:00'),
('productos', 'nombre_producto', 'ERP', 'inventory_items', 'item_name', 'Mapeo directo', 'Diario', '2024-01-14 02:00:00'),
('productos', 'precio', 'ERP', 'inventory_items', 'unit_price', 'Conversión moneda', 'Diario', '2024-01-14 02:00:00'),
('ventas', 'fecha_venta', 'Sistema POS', 'pos_transactions', 'transaction_date', 'Mapeo directo', 'Cada hora', '2024-01-15 15:00:00');
```

#### **3.2 Análisis de Consistencia entre Fuentes**
```sql
-- Verificar consistencia de precios entre sistemas
WITH precios_ventas AS (
    SELECT 
        id_producto,
        AVG(precio) as precio_promedio_ventas,
        COUNT(*) as transacciones
    FROM ventas 
    WHERE fecha_venta >= CURRENT_DATE - INTERVAL '30 days'
    GROUP BY id_producto
)
SELECT 
    p.id_producto,
    p.nombre_producto,
    p.precio as precio_catalogo,
    pv.precio_promedio_ventas,
    ABS(p.precio - pv.precio_promedio_ventas) as diferencia,
    CASE 
        WHEN ABS(p.precio - pv.precio_promedio_ventas) > p.precio * 0.05 THEN 'REVISAR'
        ELSE 'OK'
    END as estado_consistencia
FROM productos p
INNER JOIN precios_ventas pv ON p.id_producto = pv.id_producto
WHERE pv.transacciones >= 5
ORDER BY diferencia DESC;
```

#### **3.3 Documentar Transformaciones**
```sql
-- Crear documentación de transformaciones
CREATE TABLE data_quality.transformaciones (
    proceso VARCHAR(100),
    descripcion TEXT,
    reglas_negocio TEXT,
    validaciones TEXT,
    casos_especiales TEXT,
    responsable VARCHAR(100)
);

INSERT INTO data_quality.transformaciones VALUES
('Carga Clientes CRM', 
 'Extracción diaria de clientes desde sistema CRM principal',
 'Solo clientes activos; Validar formato email; Normalizar nombres',
 'Email debe contener @; Teléfono solo números; Ciudad en lista válida',
 'Clientes VIP tienen prioridad; Duplicados se resuelven por fecha más reciente',
 'Equipo Data Engineering'
),
('Sincronización Inventario',
 'Actualización de productos y precios desde ERP',
 'Precios en USD; Solo productos activos; Categorías estandarizadas',
 'Precio > 0; Nombre no vacío; Categoría en lista maestra',
 'Productos descontinuados marcar como inactivos; Precios especiales requieren aprobación',
 'Equipo Producto + Data Engineering'
);
```

---

## 📈 **EJERCICIO 4: CONSISTENCIA Y VALIDACIÓN**

### **🎯 Objetivo:** 
Implementar reglas de validación y detectar inconsistencias

### **📋 Tareas:**

#### **4.1 Definir Reglas de Validación**
```sql
-- Crear tabla de reglas de calidad
CREATE TABLE data_quality.reglas_validacion (
    regla_id SERIAL PRIMARY KEY,
    tabla VARCHAR(50),
    campo VARCHAR(50),
    regla_descripcion TEXT,
    consulta_validacion TEXT,
    nivel_criticidad VARCHAR(10),
    activa BOOLEAN DEFAULT true
);

-- Insertar reglas básicas
INSERT INTO data_quality.reglas_validacion 
(tabla, campo, regla_descripcion, consulta_validacion, nivel_criticidad) VALUES
('clientes', 'email', 'Email debe tener formato válido', 
 'SELECT COUNT(*) FROM clientes WHERE email NOT LIKE ''%@%'' AND email IS NOT NULL', 
 'ALTA'),
('clientes', 'edad', 'Edad debe estar entre 18 y 120 años', 
 'SELECT COUNT(*) FROM clientes WHERE edad < 18 OR edad > 120', 
 'MEDIA'),
('productos', 'precio', 'Precio debe ser mayor a 0', 
 'SELECT COUNT(*) FROM productos WHERE precio <= 0', 
 'ALTA'),
('ventas', 'cantidad', 'Cantidad debe ser mayor a 0', 
 'SELECT COUNT(*) FROM ventas WHERE cantidad <= 0', 
 'ALTA'),
('ventas', 'fecha_venta', 'Fecha de venta no puede ser futura', 
 'SELECT COUNT(*) FROM ventas WHERE fecha_venta > CURRENT_DATE', 
 'MEDIA');
```

#### **4.2 Ejecutar Validaciones**
```sql
-- Función para ejecutar todas las validaciones
DO $$
DECLARE
    regla RECORD;
    resultado INTEGER;
BEGIN
    -- Crear tabla de resultados si no existe
    CREATE TABLE IF NOT EXISTS data_quality.resultados_validacion (
        fecha_ejecucion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        regla_id INTEGER,
        tabla VARCHAR(50),
        campo VARCHAR(50),
        regla_descripcion TEXT,
        registros_invalidos INTEGER,
        nivel_criticidad VARCHAR(10)
    );
    
    -- Ejecutar cada regla
    FOR regla IN SELECT * FROM data_quality.reglas_validacion WHERE activa = true LOOP
        EXECUTE regla.consulta_validacion INTO resultado;
        
        INSERT INTO data_quality.resultados_validacion 
        (regla_id, tabla, campo, regla_descripcion, registros_invalidos, nivel_criticidad)
        VALUES (regla.regla_id, regla.tabla, regla.campo, regla.regla_descripcion, resultado, regla.nivel_criticidad);
    END LOOP;
END $$;

-- Ver resultados de validación
SELECT 
    fecha_ejecucion,
    tabla,
    campo,
    regla_descripcion,
    registros_invalidos,
    nivel_criticidad,
    CASE 
        WHEN registros_invalidos = 0 THEN '✅ PASS'
        WHEN nivel_criticidad = 'ALTA' AND registros_invalidos > 0 THEN '❌ FAIL'
        ELSE '⚠️ WARNING'
    END as resultado
FROM data_quality.resultados_validacion 
WHERE fecha_ejecucion::date = CURRENT_DATE
ORDER BY nivel_criticidad, registros_invalidos DESC;
```

---

## 📊 **EJERCICIO 5: REPORTE DE CALIDAD INTEGRAL**

### **🎯 Objetivo:** 
Crear un dashboard de calidad de datos completo

### **📋 Tareas:**

#### **5.1 Crear Métricas de Calidad**
```sql
-- Vista consolidada de métricas de calidad
CREATE OR REPLACE VIEW data_quality.dashboard_calidad AS
WITH metricas_base AS (
    SELECT 
        'clientes' as tabla,
        COUNT(*) as total_registros,
        COUNT(DISTINCT id_cliente) as registros_unicos,
        COUNT(nombre_completo) as nombres_completos,
        COUNT(email) as emails_completos,
        COUNT(CASE WHEN email LIKE '%@%' THEN 1 END) as emails_validos
    FROM clientes
    UNION ALL
    SELECT 
        'productos' as tabla,
        COUNT(*) as total_registros,
        COUNT(DISTINCT id_producto) as registros_unicos,
        COUNT(nombre_producto) as nombres_completos,
        COUNT(precio) as precios_completos,
        COUNT(CASE WHEN precio > 0 THEN 1 END) as precios_validos
    FROM productos
    UNION ALL
    SELECT 
        'ventas' as tabla,
        COUNT(*) as total_registros,
        COUNT(DISTINCT CONCAT(id_cliente, '-', id_producto, '-', fecha_venta)) as registros_unicos,
        COUNT(fecha_venta) as fechas_completas,
        COUNT(cantidad) as cantidades_completas,
        COUNT(CASE WHEN cantidad > 0 THEN 1 END) as cantidades_validas
    FROM ventas
)
SELECT 
    tabla,
    total_registros,
    registros_unicos,
    ROUND(100.0 * registros_unicos / total_registros, 2) as porcentaje_unicidad,
    ROUND(100.0 * nombres_completos / total_registros, 2) as completitud_nombres,
    ROUND(100.0 * emails_completos / total_registros, 2) as completitud_campo2,
    ROUND(100.0 * emails_validos / NULLIF(emails_completos, 0), 2) as validez_campo2
FROM metricas_base;

-- Ver dashboard
SELECT * FROM data_quality.dashboard_calidad;
```

#### **5.2 Crear Alertas Automáticas**
```sql
-- Sistema de alertas de calidad
CREATE TABLE data_quality.alertas_calidad (
    alerta_id SERIAL PRIMARY KEY,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tabla VARCHAR(50),
    metrica VARCHAR(50),
    valor_actual DECIMAL(10,2),
    umbral_critico DECIMAL(10,2),
    nivel_alerta VARCHAR(10),
    descripcion TEXT,
    resuelta BOOLEAN DEFAULT false
);

-- Función para generar alertas
CREATE OR REPLACE FUNCTION data_quality.generar_alertas()
RETURNS TABLE(nuevas_alertas INTEGER) AS $$
DECLARE
    alerta_count INTEGER := 0;
BEGIN
    -- Alerta por completitud baja de emails
    INSERT INTO data_quality.alertas_calidad (tabla, metrica, valor_actual, umbral_critico, nivel_alerta, descripcion)
    SELECT 
        'clientes',
        'completitud_email',
        completitud_campo2,
        85.0,
        'ALTA',
        'Completitud de emails por debajo del umbral crítico'
    FROM data_quality.dashboard_calidad 
    WHERE tabla = 'clientes' AND completitud_campo2 < 85.0
    AND NOT EXISTS (
        SELECT 1 FROM data_quality.alertas_calidad 
        WHERE tabla = 'clientes' AND metrica = 'completitud_email' 
        AND resuelta = false AND fecha_creacion::date = CURRENT_DATE
    );
    
    GET DIAGNOSTICS alerta_count = ROW_COUNT;
    RETURN QUERY SELECT alerta_count;
END;
$$ LANGUAGE plpgsql;

-- Ejecutar generación de alertas
SELECT * FROM data_quality.generar_alertas();

-- Ver alertas activas
SELECT 
    tabla,
    metrica,
    valor_actual,
    umbral_critico,
    nivel_alerta,
    descripcion,
    fecha_creacion
FROM data_quality.alertas_calidad 
WHERE resuelta = false
ORDER BY nivel_alerta, fecha_creacion DESC;
```

---

## 🎯 **EJERCICIOS AVANZADOS**

### **🏆 Desafío 1: Detección de Duplicados**
```sql
-- Encontrar posibles clientes duplicados
WITH duplicados_potenciales AS (
    SELECT 
        nombre_completo,
        email,
        telefono,
        COUNT(*) as cantidad_registros,
        STRING_AGG(id_cliente::text, ', ') as ids_duplicados
    FROM clientes 
    GROUP BY nombre_completo, email, telefono
    HAVING COUNT(*) > 1
)
SELECT 
    'Nombre + Email + Teléfono' as criterio_duplicacion,
    COUNT(*) as grupos_duplicados,
    SUM(cantidad_registros) as total_registros_duplicados
FROM duplicados_potenciales
UNION ALL
-- Duplicados por email solamente
SELECT 
    'Solo Email' as criterio_duplicacion,
    COUNT(*) as grupos_duplicados,
    SUM(cantidad_registros) as total_registros_duplicados
FROM (
    SELECT email, COUNT(*) as cantidad_registros
    FROM clientes 
    WHERE email IS NOT NULL
    GROUP BY email
    HAVING COUNT(*) > 1
) as duplicados_email;
```

### **🏆 Desafío 2: Análisis de Outliers**
```sql
-- Detectar outliers en precios de productos
WITH estadisticas_precios AS (
    SELECT 
        AVG(precio) as precio_promedio,
        STDDEV(precio) as desviacion_estandar,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY precio) as q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY precio) as q3
    FROM productos
),
outliers AS (
    SELECT 
        p.*,
        e.precio_promedio,
        e.desviacion_estandar,
        e.q1,
        e.q3,
        e.q3 - e.q1 as iqr,
        CASE 
            WHEN p.precio < (e.q1 - 1.5 * (e.q3 - e.q1)) THEN 'Outlier Inferior'
            WHEN p.precio > (e.q3 + 1.5 * (e.q3 - e.q1)) THEN 'Outlier Superior'
            ELSE 'Normal'
        END as tipo_outlier
    FROM productos p
    CROSS JOIN estadisticas_precios e
)
SELECT 
    tipo_outlier,
    COUNT(*) as cantidad,
    MIN(precio) as precio_minimo,
    MAX(precio) as precio_maximo,
    AVG(precio) as precio_promedio_grupo
FROM outliers
GROUP BY tipo_outlier
ORDER BY precio_promedio_grupo;
```

---

## 📚 **RECURSOS Y PRÓXIMOS PASOS**

### **🔗 Guías Relacionadas:**
- **Tutorial SQL:** `../sql-queries/tutorial-sql.md`
- **Conceptos de normalización:** `../../03-CONCEPTS/database-design/normalizacion.md`
- **Troubleshooting:** `../../02-HOW-TO-GUIDES/troubleshooting/problemas-comunes.md`

### **🎯 Herramientas Recomendadas:**
- **DBeaver:** Para análisis visual de datos
- **PostgreSQL EXPLAIN:** Para optimizar consultas
- **pgAdmin:** Para administración avanzada

### **💡 Mejores Prácticas:**
- ✅ **Automatizar validaciones** con jobs programados
- ✅ **Documentar reglas de negocio** claramente
- ✅ **Monitorear métricas** regularmente
- ✅ **Involucrar stakeholders** en definición de calidad
- ✅ **Crear alertas proactivas** para problemas críticos

---

## 🆘 **¿NECESITAS AYUDA?**

### **🚨 Problemas Comunes:**
- **Consultas lentas:** Usar índices y LIMIT
- **Datos inconsistentes:** Validar en origen
- **Alertas falsas:** Ajustar umbrales

### **📞 Soporte:**
- **Instructor:** Consulta en clase
- **Documentación:** PostgreSQL data quality best practices
- **Community:** Data quality forums

**🎯 ¡Con estos ejercicios dominarás la evaluación y mejora de calidad de datos a nivel profesional!**
