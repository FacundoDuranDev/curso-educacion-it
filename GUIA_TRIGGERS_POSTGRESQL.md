# Guía Completa de Triggers PostgreSQL - Basada en crear_triggers.sql

## 📋 Descripción General

Esta guía explica el sistema de triggers implementado en el archivo `scripts/crear_triggers.sql` para la base de datos `educacionit`. El sistema proporciona auditoría completa, validación de datos y métricas automáticas.

## 🏗️ Estructura del Sistema

### 1. Tablas Auxiliares

#### 1.1 Tabla de Auditoría General (`auditoria_general`)
```sql
CREATE TABLE IF NOT EXISTS auditoria_general (
    id SERIAL PRIMARY KEY,
    tabla VARCHAR(100),
    operacion VARCHAR(10),
    id_registro INTEGER,
    fecha_operacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(50) DEFAULT CURRENT_USER,
    datos_anteriores JSONB,
    datos_nuevos JSONB,
    ip_cliente INET DEFAULT inet_client_addr()
);
```

**Propósito:** Registra todas las operaciones INSERT, UPDATE y DELETE en todas las tablas principales.

**Campos clave:**
- `tabla`: Nombre de la tabla donde ocurrió la operación
- `operacion`: Tipo de operación (INSERT, UPDATE, DELETE)
- `id_registro`: ID del registro afectado
- `datos_anteriores/datos_nuevos`: Contenido completo del registro en formato JSONB

#### 1.2 Tabla de Métricas de Clientes (`metricas_clientes`)
```sql
CREATE TABLE IF NOT EXISTS metricas_clientes (
    id_cliente INTEGER PRIMARY KEY,
    total_ventas DECIMAL(15,2) DEFAULT 0,
    cantidad_ventas INTEGER DEFAULT 0,
    ticket_promedio DECIMAL(10,2) DEFAULT 0,
    ultima_compra DATE,
    primera_compra DATE,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Propósito:** Calcula y almacena automáticamente métricas de ventas por cliente.

#### 1.3 Tabla de Logs de Validación (`logs_validacion`)
```sql
CREATE TABLE IF NOT EXISTS logs_validacion (
    id SERIAL PRIMARY KEY,
    tabla VARCHAR(100),
    id_registro INTEGER,
    campo VARCHAR(100),
    valor_anterior TEXT,
    valor_nuevo TEXT,
    tipo_validacion VARCHAR(50),
    mensaje TEXT,
    fecha_validacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(50) DEFAULT CURRENT_USER,
    severidad VARCHAR(20) DEFAULT 'INFO'
);
```

**Propósito:** Registra todas las validaciones realizadas por los triggers.

**Niveles de severidad:**
- `INFO`: Validación exitosa
- `ADVERTENCIA`: Problema detectado pero no bloqueante
- `ERROR`: Error crítico que bloquea la operación

#### 1.4 Tabla de Datos Problemáticos (`datos_problematicos`)
```sql
CREATE TABLE IF NOT EXISTS datos_problematicos (
    id SERIAL PRIMARY KEY,
    tabla VARCHAR(100),
    id_registro INTEGER,
    campo VARCHAR(100),
    valor_problematico TEXT,
    tipo_problema VARCHAR(100),
    descripcion TEXT,
    fecha_deteccion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resuelto BOOLEAN DEFAULT FALSE,
    fecha_resolucion TIMESTAMP,
    usuario_resolucion VARCHAR(50)
);
```

**Propósito:** Rastrea problemas de calidad de datos para seguimiento y resolución.

### 2. Funciones de Triggers

#### 2.1 Función de Auditoría General (`auditar_cambios()`)

**Propósito:** Función universal que captura cambios en cualquier tabla.

**Características:**
- Detecta automáticamente la estructura de ID de cada tabla
- Captura datos completos en formato JSONB
- Funciona con INSERT, UPDATE y DELETE

**Lógica de IDs por tabla:**
- `clientes`: `id`
- `productos`: `id_producto`
- `empleados`: `id_empleado`
- `ventas`: `id_venta`
- `compras`: `id_compra`
- `gastos`: `id_gasto`
- `sucursales`: `id`
- `proveedores`: `id_proveedor`
- `tipos_gasto`: `id_tipo_gasto`
- `canal_venta`: `codigo`

#### 2.2 Función de Validación de Clientes (`validar_y_normalizar_cliente()`)

**Validaciones no bloqueantes:**
- Edad fuera de rango (0-120 años)
- Teléfono muy corto (< 7 caracteres)
- Coordenadas X e Y con formato inválido

**Normalizaciones automáticas:**
- Nombres y apellidos: Primera letra mayúscula
- Provincia y localidad: Primera letra mayúscula
- Domicilio: Primera letra mayúscula

**Valores por defecto:**
- Fecha de alta: Fecha actual si no se especifica
- Usuario de alta: Usuario actual si no se especifica
- Fecha de última modificación: Timestamp actual
- Usuario de última modificación: Usuario actual

#### 2.3 Función de Métricas de Clientes (`calcular_metricas_cliente()`)

**Cálculos automáticos:**
- Total de ventas por cliente
- Cantidad de ventas
- Ticket promedio
- Fecha de primera y última compra

**Activación:** Se ejecuta automáticamente después de cada operación en la tabla `ventas`.

#### 2.4 Función de Validación de Ventas (`validar_venta()`)

**Validaciones críticas (bloquean la inserción):**
- Fecha de entrega no puede ser anterior a fecha de venta
- Cantidad debe ser mayor a 0
- Precio debe ser mayor a 0

**Validaciones de referencia (solo generan logs):**
- Cliente debe existir
- Producto debe existir
- Sucursal debe existir
- Empleado debe existir
- Canal de venta debe existir

#### 2.5 Función de Validación de Gastos (`validar_gasto()`)

**Validaciones críticas:**
- Monto debe ser mayor a 0
- Fecha no puede ser en el futuro

**Validaciones de referencia:**
- Sucursal debe existir
- Tipo de gasto debe existir

#### 2.6 Función de Validación de Productos (`validar_producto()`)

**Validaciones críticas:**
- Concepto no puede estar vacío
- Precio no puede ser negativo

**Normalizaciones:**
- Concepto: Primera letra mayúscula
- Tipo: Primera letra mayúscula

#### 2.7 Función de Validación de Empleados (`validar_empleado()`)

**Validaciones críticas:**
- Apellido no puede estar vacío
- Nombre no puede estar vacío
- Salario debe ser mayor a 0

**Normalizaciones:**
- Apellido, nombre, sector y cargo: Primera letra mayúscula

### 3. Triggers Implementados

#### Triggers de Auditoría (AFTER)
- `trigger_auditoria_clientes`
- `trigger_auditoria_productos`
- `trigger_auditoria_empleados`
- `trigger_auditoria_ventas`
- `trigger_auditoria_gastos`
- `trigger_auditoria_sucursales`
- `trigger_auditoria_proveedores`
- `trigger_auditoria_tipos_gasto`
- `trigger_auditoria_canales_venta`

#### Triggers de Validación (BEFORE)
- `trigger_validar_cliente`
- `trigger_validar_venta`
- `trigger_validar_gasto`
- `trigger_validar_producto`
- `trigger_validar_empleado`

#### Triggers de Métricas (AFTER)
- `trigger_metricas_ventas`

### 4. Funciones Utilitarias

#### 4.1 Limpieza de Auditoría (`limpiar_auditoria_antigua()`)
```sql
SELECT limpiar_auditoria_antigua(90); -- Elimina registros de más de 90 días
```

#### 4.2 Estadísticas de Auditoría (`estadisticas_auditoria()`)
```sql
SELECT * FROM estadisticas_auditoria();
```

#### 4.3 Reporte de Validaciones (`reporte_validaciones()`)
```sql
SELECT * FROM reporte_validaciones();
```

#### 4.4 Reporte de Datos Problemáticos (`reporte_datos_problematicos()`)
```sql
SELECT * FROM reporte_datos_problematicos();
```

## 🚀 Instalación y Uso

### 1. Ejecutar el Script
```bash
psql -d educacionit -f scripts/crear_triggers.sql
```

### 2. Verificar Instalación
```sql
-- Verificar triggers activos
SELECT trigger_name, event_manipulation, event_object_table 
FROM information_schema.triggers 
WHERE trigger_schema = 'public';

-- Verificar funciones creadas
SELECT routine_name, routine_type 
FROM information_schema.routines 
WHERE routine_schema = 'public';
```

### 3. Monitoreo del Sistema
```sql
-- Ver operaciones recientes
SELECT * FROM auditoria_general ORDER BY fecha_operacion DESC LIMIT 10;

-- Ver validaciones con problemas
SELECT * FROM logs_validacion WHERE severidad = 'ADVERTENCIA';

-- Ver datos problemáticos pendientes
SELECT * FROM datos_problematicos WHERE resuelto = FALSE;
```

## 🔍 Casos de Uso

### Auditoría de Cambios
- Rastrear quién modificó qué y cuándo
- Mantener historial completo de cambios
- Cumplimiento de auditorías regulatorias

### Validación de Calidad de Datos
- Detectar inconsistencias en tiempo real
- Normalizar datos automáticamente
- Prevenir errores críticos

### Métricas Automáticas
- Calcular KPIs de clientes en tiempo real
- Generar reportes automáticos
- Análisis de comportamiento de compra

## ⚠️ Consideraciones Importantes

### Rendimiento
- Los triggers se ejecutan en cada operación
- Las tablas de auditoría pueden crecer rápidamente
- Usar la función `limpiar_auditoria_antigua()` regularmente

### Mantenimiento
- Revisar regularmente las tablas de logs
- Resolver datos problemáticos identificados
- Monitorear el tamaño de las tablas auxiliares

### Compatibilidad
- El sistema está diseñado para PostgreSQL 11+
- Compatible con la estructura de `create_tables.sql`
- Usa nombres de campos en snake_case

## 📊 Ejemplos de Consultas Útiles

### Análisis de Auditoría por Período
```sql
SELECT 
    DATE(fecha_operacion) as fecha,
    tabla,
    COUNT(*) as operaciones
FROM auditoria_general 
WHERE fecha_operacion >= CURRENT_DATE - INTERVAL '7 days'
GROUP BY DATE(fecha_operacion), tabla
ORDER BY fecha, tabla;
```

### Clientes con Más Problemas de Datos
```sql
SELECT 
    c.nombre_y_apellido,
    COUNT(dp.id) as problemas_detectados
FROM clientes c
JOIN datos_problematicos dp ON c.id = dp.id_registro
WHERE dp.tabla = 'clientes' AND dp.resuelto = FALSE
GROUP BY c.id, c.nombre_y_apellido
ORDER BY problemas_detectados DESC;
```

### Resumen de Validaciones por Tabla
```sql
SELECT 
    tabla,
    COUNT(*) as total_validaciones,
    COUNT(CASE WHEN severidad = 'INFO' THEN 1 END) as exitosas,
    COUNT(CASE WHEN severidad = 'ADVERTENCIA' THEN 1 END) as advertencias
FROM logs_validacion
WHERE fecha_validacion >= CURRENT_DATE
GROUP BY tabla;
```

## 🎯 Beneficios del Sistema

1. **Auditoría Completa**: Rastreo de todos los cambios
2. **Calidad de Datos**: Validación automática y normalización
3. **Métricas en Tiempo Real**: Cálculos automáticos de KPIs
4. **Flexibilidad**: Sistema que no bloquea operaciones por validaciones menores
5. **Trazabilidad**: Historial completo de problemas y resoluciones
6. **Mantenimiento**: Funciones utilitarias para gestión del sistema

Este sistema proporciona una base sólida para la gestión de calidad de datos y auditoría en PostgreSQL, manteniendo la flexibilidad necesaria para operaciones de producción.
