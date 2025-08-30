# 📊 ANÁLISIS DE CALIDAD DE DATOS - ETAPA 1

## 🎯 Objetivo
Evaluar la calidad de la información disponible y proponer mejoras para asegurar que los datos sean óptimos para el análisis de negocio.

---

## 🔍 1. ACTUALIZACIÓN Y MANTENIMIENTO DE INFORMACIÓN

### **Estado Actual:**
- **Fechas de datos:** Los datos abarcan desde 2015 hasta 2019
- **Última actualización:** 2019 (datos con 4+ años de antigüedad)
- **Frecuencia de actualización:** No se especifica en los datos

### **Problemas Identificados:**
- ❌ **Datos desactualizados:** Información de hace más de 4 años
- ❌ **Falta de trazabilidad:** No hay indicadores de cuándo se actualizó por última vez
- ❌ **Ausencia de metadatos:** No se especifica la fuente ni el proceso de extracción

### **Propuestas de Mejora:**
1. **Implementar proceso de actualización automática:**
   - Actualización diaria/semanal de transacciones
   - Actualización mensual de catálogos (productos, empleados)
   - Actualización trimestral de datos maestros (clientes, sucursales)

2. **Agregar campos de auditoría:**
   - `fecha_ultima_actualizacion`
   - `usuario_ultima_actualizacion`
   - `version_datos`
   - `fuente_datos`

3. **Implementar ETL automatizado:**
   - Pipeline de datos con validaciones
   - Alertas de fallos en la carga
   - Logs de auditoría completos

---

## 📋 2. COMPLETITUD DE DATOS

### **Análisis por Tabla:**

#### **Clientes.csv (3,409 registros):**
- ✅ **Completos:** ID, Nombre_y_Apellido, Edad, Fecha_Alta
- ❌ **Incompletos:** Provincia (líneas 12, 15, 20), Localidad (líneas 12, 15, 20)
- ❌ **Campo extra:** `col10` (vacío, debe eliminarse)
- ❌ **Inconsistencias:** Coordenadas X,Y con formatos mixtos

#### **PRODUCTOS.csv (293 registros):**
- ✅ **Completos:** ID_PRODUCTO, Concepto, Tipo, Precio
- ❌ **Datos de prueba:** Producto1-Producto8 con precios extremos (0.00, 244,444,442.00)
- ❌ **Inconsistencias:** Algunos productos sin tipo especificado

#### **Sucursales.csv (33 registros):**
- ✅ **Completos:** ID, Sucursal, Direccion, Localidad, Provincia
- ❌ **Inconsistencias:** Formato de provincia variable (Bs As, Bs.As., Buenos Aires, etc.)
- ❌ **Coordenadas:** Algunas coordenadas con formato inconsistente

#### **Empleados.csv (269 registros):**
- ✅ **Completos:** ID_empleado, Apellido, Nombre, Sucursal, Sector, Cargo, Salario
- ❌ **Duplicados:** ID 1674 aparece en múltiples sucursales (Caseros y Cabildo)

#### **Venta.csv (2.5MB, múltiples registros):**
- ✅ **Completos:** Todos los campos obligatorios

#### **Compra.csv (11,541 registros):**
- ✅ **Completos:** Todos los campos obligatorios
- ❌ **Validaciones:** Precios de compra vs venta (análisis de márgenes)

#### **Gasto.csv (8,642 registros):**
- ✅ **Completos:** Todos los campos obligatorios
- ❌ **Validaciones:** Montos extremos o inconsistentes

### **Propuestas de Mejora:**
1. **Implementar validaciones de integridad:**
   - Campos obligatorios no nulos
   - Rangos válidos para precios, fechas, edades
   - Validación de coordenadas geográficas

2. **Eliminar datos de prueba:**
   - Remover Producto1-Producto8
   - Limpiar registros con valores extremos

3. **Estandarizar formatos:**
   - Nombres de provincias consistentes
   - Formato de coordenadas uniforme
   - Eliminación de campos innecesarios (col10)

---

## 🔗 3. FUENTES DE DATOS

### **Estado Actual:**
- ❌ **No documentadas:** No se especifica el origen de los datos
- ❌ **Sin trazabilidad:** No hay información sobre sistemas fuente
- ❌ **Falta de metadatos:** Ausencia de documentación de origen

### **Propuestas de Mejora:**
1. **Documentar fuentes de datos:**
   - Sistema de ventas (POS)
   - Sistema de recursos humanos
   - Sistema de inventario
   - Sistema de contabilidad

2. **Implementar catálogo de datos:**
   - Documentación de cada tabla
   - Descripción de campos
   - Reglas de negocio aplicadas
   - Frecuencia de actualización

3. **Trazabilidad completa:**
   - Logs de extracción
   - Timestamps de origen
   - Usuario responsable de la extracción

---

## 🏗️ 4. NORMALIZACIÓN Y ESTRUCTURA

### **Problemas Identificados:**

#### **Nomenclatura Inconsistente:**
- **Clientes:** `ID` vs **Productos:** `ID_PRODUCTO`
- **Empleados:** `ID_empleado` vs **Venta:** `Id_Venta`
- **Sucursales:** `ID` vs **Compra:** `Id_Producto`

#### **Estructura de Datos:**
- **Separadores mixtos:** Algunos archivos usan `;` otros `,`
- **Formato de fechas:** Inconsistente entre archivos
- **Coordenadas:** Formato mixto (con/sin signo negativo)

#### **Relaciones:**
- **Claves foráneas:** No están explícitamente definidas
- **Integridad referencial:** No validada en los datos

### **Propuestas de Mejora:**

#### **4.1 Estandarización de Nombres:**
```sql
-- Convención propuesta:
-- Tablas: snake_case (clientes, productos, ventas)
-- Campos: snake_case (id_cliente, nombre_producto, fecha_venta)
-- Claves primarias: id_[nombre_tabla]
-- Claves foráneas: id_[tabla_referenciada]
```

#### **4.2 Estructura Normalizada Propuesta:**
```sql
-- Dimensión Clientes
CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nombre_apellido VARCHAR(100) NOT NULL,
    provincia VARCHAR(50),
    localidad VARCHAR(100),
    domicilio TEXT,
    telefono VARCHAR(20),
    edad INTEGER CHECK (edad > 0 AND edad < 120),
    coordenada_x DECIMAL(10,8),
    coordenada_y DECIMAL(10,8),
    fecha_alta DATE NOT NULL,
    usuario_alta VARCHAR(50),
    fecha_ultima_modificacion TIMESTAMP,
    usuario_ultima_modificacion VARCHAR(50),
    marca_baja BOOLEAN DEFAULT FALSE
);

-- Dimensión Productos
CREATE TABLE productos (
    id_producto SERIAL PRIMARY KEY,
    concepto VARCHAR(200) NOT NULL,
    tipo VARCHAR(50),
    precio DECIMAL(10,2) CHECK (precio >= 0),
    activo BOOLEAN DEFAULT TRUE
);

-- Dimensión Sucursales
CREATE TABLE sucursales (
    id_sucursal SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion TEXT,
    localidad VARCHAR(100),
    provincia VARCHAR(50),
    latitud DECIMAL(10,8),
    longitud DECIMAL(10,8)
);

-- Dimensión Empleados
CREATE TABLE empleados (
    id_empleado SERIAL PRIMARY KEY,
    apellido VARCHAR(100) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    id_sucursal INTEGER REFERENCES sucursales(id_sucursal),
    sector VARCHAR(50),
    cargo VARCHAR(50),
    salario DECIMAL(10,2) CHECK (salario > 0),
    activo BOOLEAN DEFAULT TRUE
);

-- Dimensión Proveedores
CREATE TABLE proveedores (
    id_proveedor SERIAL PRIMARY KEY,
    nombre VARCHAR(200),
    direccion TEXT,
    ciudad VARCHAR(100),
    provincia VARCHAR(50),
    pais VARCHAR(50) DEFAULT 'ARGENTINA',
    departamento VARCHAR(100)
);

-- Dimensión Tipos de Gasto
CREATE TABLE tipos_gasto (
    id_tipo_gasto SERIAL PRIMARY KEY,
    descripcion VARCHAR(100) NOT NULL,
    monto_aproximado DECIMAL(10,2)
);

-- Dimensión Canales de Venta
CREATE TABLE canales_venta (
    id_canal SERIAL PRIMARY KEY,
    codigo INTEGER UNIQUE,
    descripcion VARCHAR(50) NOT NULL
);

-- Tabla de Hechos Ventas
CREATE TABLE ventas (
    id_venta SERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    fecha_entrega DATE,
    id_canal INTEGER REFERENCES canales_venta(id_canal),
    id_cliente INTEGER REFERENCES clientes(id_cliente),
    id_sucursal INTEGER REFERENCES sucursales(id_sucursal),
    id_empleado INTEGER REFERENCES empleados(id_empleado),
    id_producto INTEGER REFERENCES productos(id_producto),
    precio DECIMAL(10,2) CHECK (precio > 0),
    cantidad INTEGER CHECK (cantidad > 0),
    monto_total DECIMAL(12,2) GENERATED ALWAYS AS (precio * cantidad) STORED
);

-- Tabla de Hechos Compras
CREATE TABLE compras (
    id_compra SERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    id_producto INTEGER REFERENCES productos(id_producto),
    cantidad INTEGER CHECK (cantidad > 0),
    precio DECIMAL(10,2) CHECK (precio > 0),
    id_proveedor INTEGER REFERENCES proveedores(id_proveedor),
    monto_total DECIMAL(12,2) GENERATED ALWAYS AS (precio * cantidad) STORED
);

-- Tabla de Hechos Gastos
CREATE TABLE gastos (
    id_gasto SERIAL PRIMARY KEY,
    id_sucursal INTEGER REFERENCES sucursales(id_sucursal),
    id_tipo_gasto INTEGER REFERENCES tipos_gasto(id_tipo_gasto),
    fecha DATE NOT NULL,
    monto DECIMAL(10,2) CHECK (monto > 0)
);
```

#### **4.3 Índices Recomendados:**
```sql
-- Índices para mejorar performance
CREATE INDEX idx_ventas_fecha ON ventas(fecha);
CREATE INDEX idx_ventas_cliente ON ventas(id_cliente);
CREATE INDEX idx_ventas_sucursal ON ventas(id_sucursal);
CREATE INDEX idx_ventas_producto ON ventas(id_producto);

CREATE INDEX idx_compras_fecha ON compras(fecha);
CREATE INDEX idx_compras_producto ON compras(id_producto);
CREATE INDEX idx_compras_proveedor ON compras(id_proveedor);

CREATE INDEX idx_gastos_fecha ON gastos(fecha);
CREATE INDEX idx_gastos_sucursal ON gastos(id_sucursal);

CREATE INDEX idx_clientes_provincia ON clientes(provincia);
CREATE INDEX idx_clientes_localidad ON clientes(localidad);
```

---

## 🚀 PLAN DE IMPLEMENTACIÓN

### **Fase 1: Limpieza de Datos (1-2 semanas)**
1. Eliminar registros de prueba
2. Estandarizar formatos
3. Completar campos faltantes
4. Validar integridad referencial

### **Fase 2: Restructuración (2-3 semanas)**
1. Crear nueva estructura normalizada
2. Migrar datos existentes
3. Implementar validaciones
4. Crear índices de performance

### **Fase 3: Automatización (2-3 semanas)**
1. Implementar ETL automatizado
2. Configurar alertas de calidad
3. Documentar procesos
4. Capacitar equipo

### **Fase 4: Monitoreo (Continua)**
1. Dashboard de calidad de datos
2. Reportes de inconsistencias
3. Auditoría regular
4. Mejora continua

---

## 📊 MÉTRICAS DE CALIDAD

### **Indicadores a Monitorear:**
- **Completitud:** % de campos no nulos
- **Consistencia:** % de registros que pasan validaciones
- **Actualidad:** Días desde última actualización
- **Integridad:** % de claves foráneas válidas
- **Precisión:** % de datos dentro de rangos esperados

### **Alertas Recomendadas:**
- Datos con más de 24 horas sin actualizar
- Registros con valores fuera de rango
- Inconsistencias en integridad referencial
- Fallos en procesos ETL

---

## 🎯 BENEFICIOS ESPERADOS

1. **Mejora en la calidad de análisis:** Datos más confiables
2. **Reducción de errores:** Validaciones automáticas
3. **Mejor performance:** Estructura optimizada
4. **Trazabilidad completa:** Auditoría de datos
5. **Escalabilidad:** Estructura preparada para crecimiento
6. **Cumplimiento:** Mejores prácticas de gobierno de datos

---

## 📝 CONCLUSIÓN

La implementación de estas mejoras transformará la calidad de los datos de un estado **crítico** a un estado **óptimo**, permitiendo análisis de negocio más confiables y decisiones estratégicas basadas en información de alta calidad.

**Prioridad Alta:** Implementar validaciones y limpieza de datos
**Prioridad Media:** Restructuración y normalización
**Prioridad Baja:** Automatización y monitoreo avanzado

