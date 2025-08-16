# 📊 Ejemplos de Normalización de Bases de Datos (1FN a 5FN)

## 🎯 **¿Qué es la Normalización?**

La normalización es un proceso que organiza los datos de una base de datos para:
- ✅ **Eliminar redundancias** (datos duplicados)
- ✅ **Evitar anomalías** (problemas al insertar, actualizar o eliminar)
- ✅ **Mejorar la integridad** de los datos
- ✅ **Optimizar el rendimiento** de las consultas

---

## 🔢 **Primera Forma Normal (1FN)**

### **Regla:** Cada celda debe contener un solo valor atómico (no divisible)

### ❌ **ANTES (No normalizado):**
```sql
CREATE TABLE empleados (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(100),
    telefonos VARCHAR(200),  -- Múltiples teléfonos en una celda
    habilidades VARCHAR(300) -- Múltiples habilidades en una celda
);

-- Datos problemáticos:
INSERT INTO empleados VALUES 
(1, 'Juan Pérez', '555-1234, 555-5678', 'SQL, Python, Java'),
(2, 'Ana García', '555-9999', 'Python, R');
```

**Problemas:**
- Múltiples teléfonos en una celda
- Múltiples habilidades en una celda
- Difícil de buscar y filtrar

### ✅ **DESPUÉS (1FN):**
```sql
-- Tabla principal
CREATE TABLE empleados (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(100)
);

-- Tabla de teléfonos
CREATE TABLE telefonos_empleados (
    id INTEGER PRIMARY KEY,
    id_empleado INTEGER,
    telefono VARCHAR(20),
    FOREIGN KEY (id_empleado) REFERENCES empleados(id)
);

-- Tabla de habilidades
CREATE TABLE habilidades_empleados (
    id INTEGER PRIMARY KEY,
    id_empleado INTEGER,
    habilidad VARCHAR(100),
    FOREIGN KEY (id_empleado) REFERENCES empleados(id)
);

-- Datos normalizados:
INSERT INTO empleados VALUES (1, 'Juan Pérez'), (2, 'Ana García');

INSERT INTO telefonos_empleados VALUES 
(1, 1, '555-1234'), (2, 1, '555-5678'), (3, 2, '555-9999');

INSERT INTO habilidades_empleados VALUES 
(1, 1, 'SQL'), (2, 1, 'Python'), (3, 1, 'Java'),
(4, 2, 'Python'), (5, 2, 'R');
```

---

## 🔢 **Segunda Forma Normal (2FN)**

### **Regla:** Debe estar en 1FN + No debe tener dependencias parciales

### ❌ **ANTES (No en 2FN):**
```sql
CREATE TABLE pedidos_productos (
    id_pedido INTEGER,
    id_producto INTEGER,
    nombre_producto VARCHAR(100),    -- Depende solo de id_producto
    precio_producto DECIMAL(10,2),   -- Depende solo de id_producto
    cantidad INTEGER,                -- Depende de id_pedido + id_producto
    fecha_pedido DATE,               -- Depende solo de id_pedido
    PRIMARY KEY (id_pedido, id_producto)
);
```

**Problemas:**
- `nombre_producto` y `precio_producto` dependen solo de `id_producto`
- `fecha_pedido` depende solo de `id_pedido`
- Esto causa redundancia y anomalías

### ✅ **DESPUÉS (2FN):**
```sql
-- Tabla de pedidos
CREATE TABLE pedidos (
    id_pedido INTEGER PRIMARY KEY,
    fecha_pedido DATE,
    id_cliente INTEGER
);

-- Tabla de productos
CREATE TABLE productos (
    id_producto INTEGER PRIMARY KEY,
    nombre_producto VARCHAR(100),
    precio_producto DECIMAL(10,2)
);

-- Tabla de detalles de pedidos
CREATE TABLE detalles_pedidos (
    id_pedido INTEGER,
    id_producto INTEGER,
    cantidad INTEGER,
    precio_unitario DECIMAL(10,2),
    PRIMARY KEY (id_pedido, id_producto),
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);
```

---

## 🔢 **Tercera Forma Normal (3FN)**

### **Regla:** Debe estar en 2FN + No debe tener dependencias transitivas

### ❌ **ANTES (No en 3FN):**
```sql
CREATE TABLE empleados (
    id_empleado INTEGER PRIMARY KEY,
    nombre VARCHAR(100),
    id_departamento INTEGER,
    nombre_departamento VARCHAR(100),    -- Depende de id_departamento
    ubicacion_departamento VARCHAR(100), -- Depende de id_departamento
    salario DECIMAL(10,2)
);
```

**Problemas:**
- `nombre_departamento` y `ubicacion_departamento` dependen de `id_departamento`
- Si cambia el nombre del departamento, hay que actualizar múltiples registros
- Posibles inconsistencias

### ✅ **DESPUÉS (3FN):**
```sql
-- Tabla de empleados
CREATE TABLE empleados (
    id_empleado INTEGER PRIMARY KEY,
    nombre VARCHAR(100),
    id_departamento INTEGER,
    salario DECIMAL(10,2),
    FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento)
);

-- Tabla de departamentos
CREATE TABLE departamentos (
    id_departamento INTEGER PRIMARY KEY,
    nombre_departamento VARCHAR(100),
    ubicacion_departamento VARCHAR(100)
);
```

---

## 🔢 **Forma Normal de Boyce-Codd (BCNF)**

### **Regla:** Debe estar en 3FN + Para cada dependencia funcional X → Y, X debe ser superclave

### ❌ **ANTES (No en BCNF):**
```sql
CREATE TABLE reservas_hotel (
    id_hotel INTEGER,
    id_habitacion INTEGER,
    fecha_inicio DATE,
    fecha_fin DATE,
    id_cliente INTEGER,
    PRIMARY KEY (id_hotel, id_habitacion, fecha_inicio)
);
```

**Problemas:**
- Un cliente puede reservar múltiples habitaciones en la misma fecha
- Una habitación puede ser reservada por múltiples clientes en fechas diferentes
- Dependencias funcionales complejas

### ✅ **DESPUÉS (BCNF):**
```sql
-- Tabla de reservas
CREATE TABLE reservas (
    id_reserva INTEGER PRIMARY KEY,
    id_hotel INTEGER,
    id_habitacion INTEGER,
    fecha_inicio DATE,
    fecha_fin DATE,
    id_cliente INTEGER,
    UNIQUE (id_hotel, id_habitacion, fecha_inicio),
    FOREIGN KEY (id_hotel, id_habitacion) REFERENCES habitaciones(id_hotel, id_habitacion),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- Tabla de habitaciones
CREATE TABLE habitaciones (
    id_hotel INTEGER,
    id_habitacion INTEGER,
    tipo_habitacion VARCHAR(50),
    precio DECIMAL(10,2),
    PRIMARY KEY (id_hotel, id_habitacion)
);
```

---

## 🔢 **Cuarta Forma Normal (4FN)**

### **Regla:** Debe estar en BCNF + No debe tener dependencias multivaluadas

### ❌ **ANTES (No en 4FN):**
```sql
CREATE TABLE empleados_habilidades_idiomas (
    id_empleado INTEGER,
    habilidad VARCHAR(100),
    idioma VARCHAR(50),
    PRIMARY KEY (id_empleado, habilidad, idioma)
);

-- Datos problemáticos:
-- Empleado 1: Habilidades (SQL, Python), Idiomas (Español, Inglés)
-- Esto crea 4 combinaciones: (SQL, Español), (SQL, Inglés), (Python, Español), (Python, Inglés)
```

**Problemas:**
- Dependencias multivaluadas entre habilidades e idiomas
- Combinaciones innecesarias
- Datos redundantes

### ✅ **DESPUÉS (4FN):**
```sql
-- Tabla de empleados
CREATE TABLE empleados (
    id_empleado INTEGER PRIMARY KEY,
    nombre VARCHAR(100)
);

-- Tabla de habilidades de empleados
CREATE TABLE habilidades_empleados (
    id_empleado INTEGER,
    habilidad VARCHAR(100),
    PRIMARY KEY (id_empleado, habilidad),
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);

-- Tabla de idiomas de empleados
CREATE TABLE idiomas_empleados (
    id_empleado INTEGER,
    idioma VARCHAR(50),
    nivel VARCHAR(20),
    PRIMARY KEY (id_empleado, idioma),
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);
```

---

## 🔢 **Quinta Forma Normal (5FN)**

### **Regla:** Debe estar en 4FN + No debe tener dependencias de unión

### ❌ **ANTES (No en 5FN):**
```sql
CREATE TABLE proveedores_productos_componentes (
    id_proveedor INTEGER,
    id_producto INTEGER,
    id_componente INTEGER,
    PRIMARY KEY (id_proveedor, id_producto, id_componente)
);

-- Problema: Si un proveedor vende un producto y también vende un componente,
-- y el producto usa ese componente, entonces el proveedor debe vender ambos
```

### ✅ **DESPUÉS (5FN):**
```sql
-- Tabla de proveedores
CREATE TABLE proveedores (
    id_proveedor INTEGER PRIMARY KEY,
    nombre VARCHAR(100)
);

-- Tabla de productos
CREATE TABLE productos (
    id_producto INTEGER PRIMARY KEY,
    nombre VARCHAR(100)
);

-- Tabla de componentes
CREATE TABLE componentes (
    id_componente INTEGER PRIMARY KEY,
    nombre VARCHAR(100)
);

-- Tabla de proveedores-productos
CREATE TABLE proveedores_productos (
    id_proveedor INTEGER,
    id_producto INTEGER,
    precio DECIMAL(10,2),
    PRIMARY KEY (id_proveedor, id_producto),
    FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- Tabla de proveedores-componentes
CREATE TABLE proveedores_componentes (
    id_proveedor INTEGER,
    id_componente INTEGER,
    precio DECIMAL(10,2),
    PRIMARY KEY (id_proveedor, id_componente),
    FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor),
    FOREIGN KEY (id_componente) REFERENCES componentes(id_componente)
);

-- Tabla de productos-componentes
CREATE TABLE productos_componentes (
    id_producto INTEGER,
    id_componente INTEGER,
    cantidad INTEGER,
    PRIMARY KEY (id_producto, id_componente),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    FOREIGN KEY (id_componente) REFERENCES componentes(id_componente)
);
```

---

## 🎯 **Ejemplo Completo: Sistema de Biblioteca**

### **❌ Tabla NO normalizada:**
```sql
CREATE TABLE prestamos_libros (
    id_prestamo INTEGER,
    id_libro INTEGER,
    titulo_libro VARCHAR(200),
    autor_libro VARCHAR(100),
    categoria_libro VARCHAR(50),
    id_lector INTEGER,
    nombre_lector VARCHAR(100),
    email_lector VARCHAR(100),
    telefono_lector VARCHAR(20),
    fecha_prestamo DATE,
    fecha_devolucion DATE,
    multa DECIMAL(10,2)
);
```

### **✅ Tablas normalizadas (3FN):**
```sql
-- Tabla de libros
CREATE TABLE libros (
    id_libro INTEGER PRIMARY KEY,
    titulo VARCHAR(200),
    autor VARCHAR(100),
    id_categoria INTEGER,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

-- Tabla de categorías
CREATE TABLE categorias (
    id_categoria INTEGER PRIMARY KEY,
    nombre_categoria VARCHAR(50)
);

-- Tabla de lectores
CREATE TABLE lectores (
    id_lector INTEGER PRIMARY KEY,
    nombre VARCHAR(100),
    email VARCHAR(100),
    telefono VARCHAR(20)
);

-- Tabla de préstamos
CREATE TABLE prestamos (
    id_prestamo INTEGER PRIMARY KEY,
    id_libro INTEGER,
    id_lector INTEGER,
    fecha_prestamo DATE,
    fecha_devolucion DATE,
    multa DECIMAL(10,2),
    FOREIGN KEY (id_libro) REFERENCES libros(id_libro),
    FOREIGN KEY (id_lector) REFERENCES lectores(id_lector)
);
```

---

## 💡 **Ventajas de la Normalización**

### **✅ Beneficios:**
- **Elimina redundancias** - No hay datos duplicados
- **Previene anomalías** - Insert, Update, Delete más seguros
- **Mejora la integridad** - Datos más consistentes
- **Facilita mantenimiento** - Cambios en un solo lugar
- **Optimiza consultas** - Mejor rendimiento

### **⚠️ Desventajas:**
- **Más tablas** - Consultas más complejas
- **JOINs necesarios** - Puede afectar rendimiento
- **Diseño más complejo** - Requiere más planificación

---

## 🔍 **Cuándo Normalizar**

### **✅ Normalizar cuando:**
- Hay redundancias de datos
- Se producen anomalías
- Se necesita integridad referencial
- Se trabaja con datos transaccionales

### **⚠️ NO normalizar cuando:**
- Se necesita máximo rendimiento en consultas
- Se trabaja con data warehouses
- Se requiere denormalización por rendimiento

---

## 🚀 **Resumen de las Formas Normales**

| Forma Normal | Regla Principal | Objetivo |
|--------------|----------------|----------|
| **1FN** | Valores atómicos | Eliminar grupos repetitivos |
| **2FN** | Sin dependencias parciales | Eliminar redundancias |
| **3FN** | Sin dependencias transitivas | Eliminar más redundancias |
| **BCNF** | X→Y, X debe ser superclave | Eliminar anomalías |
| **4FN** | Sin dependencias multivaluadas | Eliminar combinaciones innecesarias |
| **5FN** | Sin dependencias de unión | Eliminar dependencias complejas |

---

## 🎯 **Consejos Prácticos**

1. **Empieza con 3FN** - Es suficiente para la mayoría de casos
2. **BCNF** - Útil para casos complejos
3. **4FN y 5FN** - Solo para casos muy específicos
4. **Denormalización** - Considera para optimizar consultas
5. **Prueba siempre** - Verifica que las consultas funcionen

---

*¡Recuerda: La normalización es un arte, no una ciencia exacta!* 🎨✨
