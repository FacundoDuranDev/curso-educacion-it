# 📊 NORMALIZACIÓN DE BASES DE DATOS (1FN a 5FN)

> **🎯 Objetivo:** Dominar la normalización para diseñar bases de datos eficientes y sin redundancias

## 🚀 **¿QUÉ ES LA NORMALIZACIÓN?**

### **📋 Definición:**
La normalización es un proceso sistemático que organiza los datos de una base de datos para:

- ✅ **Eliminar redundancias** (datos duplicados innecesarios)
- ✅ **Evitar anomalías** (problemas al insertar, actualizar o eliminar)
- ✅ **Mejorar la integridad** de los datos
- ✅ **Optimizar el rendimiento** y mantenimiento
- ✅ **Facilitar el crecimiento** del sistema

### **🎯 Beneficios Clave:**
```
ANTES (Sin normalizar):
❌ Datos duplicados en múltiples lugares
❌ Inconsistencias cuando se actualiza
❌ Desperdicio de espacio de almacenamiento
❌ Dificultad para mantener integridad

DESPUÉS (Normalizado):
✅ Cada dato se almacena una sola vez
✅ Actualizaciones consistentes automáticamente
✅ Uso eficiente del espacio
✅ Integridad referencial garantizada
```

---

## 🔢 **PRIMERA FORMA NORMAL (1FN)**

### **📋 Regla Principal:**
> Cada celda debe contener un **valor atómico** (no divisible)

### **❌ ANTES (No Normalizado):**

```sql
-- Tabla con múltiples valores en una celda (INCORRECTO)
CREATE TABLE empleados_mal (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(100),
    telefonos VARCHAR(200),      -- ❌ Múltiples teléfonos en una celda
    habilidades VARCHAR(300),    -- ❌ Múltiples habilidades en una celda
    proyectos VARCHAR(400)       -- ❌ Múltiples proyectos en una celda
);

-- Datos problemáticos:
INSERT INTO empleados_mal VALUES 
(1, 'Juan Pérez', '555-1234, 555-5678, 555-9999', 'SQL, Python, Java, Docker', 'Proyecto A, Proyecto B'),
(2, 'Ana García', '555-4444', 'Python, R, Machine Learning', 'Proyecto C'),
(3, 'Carlos López', '555-7777, 555-8888', 'Java, Spring, Microservicios', 'Proyecto A, Proyecto D, Proyecto E');
```

**🚨 Problemas de este diseño:**
- Imposible buscar empleados con habilidad específica
- No se pueden hacer JOINs efectivos
- Difícil contar cuántos proyectos tiene cada empleado
- Formato inconsistente (comas, espacios)

### **✅ DESPUÉS (1FN Aplicada):**

```sql
-- Tabla principal normalizada
CREATE TABLE empleados (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Tabla separada para teléfonos
CREATE TABLE empleados_telefonos (
    id INTEGER PRIMARY KEY,
    empleado_id INTEGER REFERENCES empleados(id),
    telefono VARCHAR(20) NOT NULL,
    tipo VARCHAR(20) DEFAULT 'trabajo' -- 'trabajo', 'personal', 'móvil'
);

-- Tabla separada para habilidades
CREATE TABLE empleados_habilidades (
    id INTEGER PRIMARY KEY,
    empleado_id INTEGER REFERENCES empleados(id),
    habilidad VARCHAR(50) NOT NULL,
    nivel VARCHAR(20) DEFAULT 'intermedio' -- 'básico', 'intermedio', 'avanzado'
);

-- Tabla separada para proyectos
CREATE TABLE empleados_proyectos (
    id INTEGER PRIMARY KEY,
    empleado_id INTEGER REFERENCES empleados(id),
    proyecto VARCHAR(100) NOT NULL,
    fecha_asignacion DATE DEFAULT CURRENT_DATE,
    activo BOOLEAN DEFAULT true
);

-- Datos normalizados:
INSERT INTO empleados VALUES 
(1, 'Juan Pérez'),
(2, 'Ana García'),
(3, 'Carlos López');

INSERT INTO empleados_telefonos VALUES 
(1, 1, '555-1234', 'trabajo'),
(2, 1, '555-5678', 'personal'),
(3, 1, '555-9999', 'móvil'),
(4, 2, '555-4444', 'trabajo'),
(5, 3, '555-7777', 'trabajo'),
(6, 3, '555-8888', 'personal');

INSERT INTO empleados_habilidades VALUES 
(1, 1, 'SQL', 'avanzado'),
(2, 1, 'Python', 'intermedio'),
(3, 1, 'Java', 'básico'),
(4, 1, 'Docker', 'intermedio'),
(5, 2, 'Python', 'avanzado'),
(6, 2, 'R', 'avanzado'),
(7, 2, 'Machine Learning', 'intermedio'),
(8, 3, 'Java', 'avanzado'),
(9, 3, 'Spring', 'avanzado'),
(10, 3, 'Microservicios', 'intermedio');
```

**🎯 Beneficios conseguidos:**
```sql
-- Ahora puedes hacer consultas poderosas:

-- Empleados con habilidad específica
SELECT e.nombre 
FROM empleados e
JOIN empleados_habilidades eh ON e.id = eh.empleado_id
WHERE eh.habilidad = 'Python';

-- Contar habilidades por empleado
SELECT e.nombre, COUNT(eh.habilidad) as total_habilidades
FROM empleados e
LEFT JOIN empleados_habilidades eh ON e.id = eh.empleado_id
GROUP BY e.id, e.nombre;

-- Empleados con más de 2 teléfonos
SELECT e.nombre, COUNT(et.telefono) as total_telefonos
FROM empleados e
JOIN empleados_telefonos et ON e.id = et.empleado_id
GROUP BY e.id, e.nombre
HAVING COUNT(et.telefono) > 2;
```

---

## 🔑 **SEGUNDA FORMA NORMAL (2FN)**

### **📋 Reglas:**
1. ✅ Debe estar en **1FN**
2. ✅ **Todos los atributos no-clave** deben depender **completamente** de la clave primaria

### **❌ ANTES (Solo 1FN):**

```sql
-- Tabla con dependencias parciales (PROBLEMÁTICA)
CREATE TABLE pedidos_items_mal (
    pedido_id INTEGER,
    producto_id INTEGER,
    cantidad INTEGER,
    precio_unitario DECIMAL(10,2),
    -- ❌ Estos campos dependen solo de pedido_id, no de la clave completa
    fecha_pedido DATE,
    cliente_nombre VARCHAR(100),
    cliente_direccion VARCHAR(200),
    -- ❌ Estos campos dependen solo de producto_id
    producto_nombre VARCHAR(100),
    producto_categoria VARCHAR(50),
    PRIMARY KEY (pedido_id, producto_id)
);

-- Datos con redundancia:
INSERT INTO pedidos_items_mal VALUES 
(1, 101, 2, 25.99, '2024-01-15', 'Juan Pérez', 'Calle Mayor 123', 'Laptop HP', 'Electrónicos'),
(1, 102, 1, 15.50, '2024-01-15', 'Juan Pérez', 'Calle Mayor 123', 'Mouse Logitech', 'Accesorios'),
(1, 103, 3, 8.99, '2024-01-15', 'Juan Pérez', 'Calle Mayor 123', 'Cable USB', 'Accesorios'),
(2, 101, 1, 25.99, '2024-01-16', 'Ana García', 'Avenida Sol 456', 'Laptop HP', 'Electrónicos'),
(2, 104, 2, 12.75, '2024-01-16', 'Ana García', 'Avenida Sol 456', 'Teclado Mecánico', 'Accesorios');
```

**🚨 Problemas identificados:**
- Información del cliente se repite en cada item del pedido
- Información del producto se repite en cada pedido
- Si cambia la dirección del cliente, hay que actualizar múltiples registros
- Desperdicio de espacio significativo

### **✅ DESPUÉS (2FN Aplicada):**

```sql
-- Tabla de clientes (información que depende del cliente)
CREATE TABLE clientes (
    cliente_id INTEGER PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(200),
    telefono VARCHAR(20),
    email VARCHAR(100)
);

-- Tabla de productos (información que depende del producto)
CREATE TABLE productos (
    producto_id INTEGER PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    categoria VARCHAR(50),
    precio_actual DECIMAL(10,2),
    descripcion TEXT
);

-- Tabla de pedidos (información que depende del pedido)
CREATE TABLE pedidos (
    pedido_id INTEGER PRIMARY KEY,
    cliente_id INTEGER REFERENCES clientes(cliente_id),
    fecha_pedido DATE NOT NULL DEFAULT CURRENT_DATE,
    estado VARCHAR(20) DEFAULT 'pendiente',
    total DECIMAL(10,2)
);

-- Tabla de items de pedido (solo información que depende de ambos)
CREATE TABLE pedidos_items (
    pedido_id INTEGER REFERENCES pedidos(pedido_id),
    producto_id INTEGER REFERENCES productos(producto_id),
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10,2) NOT NULL, -- Precio al momento del pedido
    PRIMARY KEY (pedido_id, producto_id)
);

-- Datos normalizados:
INSERT INTO clientes VALUES 
(1, 'Juan Pérez', 'Calle Mayor 123', '555-1234', 'juan@email.com'),
(2, 'Ana García', 'Avenida Sol 456', '555-5678', 'ana@email.com');

INSERT INTO productos VALUES 
(101, 'Laptop HP', 'Electrónicos', 25.99, 'Laptop para uso profesional'),
(102, 'Mouse Logitech', 'Accesorios', 15.50, 'Mouse inalámbrico ergonómico'),
(103, 'Cable USB', 'Accesorios', 8.99, 'Cable USB-C de alta velocidad'),
(104, 'Teclado Mecánico', 'Accesorios', 12.75, 'Teclado mecánico retroiluminado');

INSERT INTO pedidos VALUES 
(1, 1, '2024-01-15', 'completado', 76.47),
(2, 2, '2024-01-16', 'pendiente', 51.49);

INSERT INTO pedidos_items VALUES 
(1, 101, 2, 25.99),
(1, 102, 1, 15.50),
(1, 103, 3, 8.99),
(2, 101, 1, 25.99),
(2, 104, 2, 12.75);
```

**🎯 Beneficios conseguidos:**
```sql
-- Consultas más eficientes y flexibles:

-- Pedidos completos con información del cliente
SELECT 
    p.pedido_id,
    c.nombre as cliente,
    c.direccion,
    p.fecha_pedido,
    p.total
FROM pedidos p
JOIN clientes c ON p.cliente_id = c.cliente_id;

-- Detalle completo de un pedido
SELECT 
    p.pedido_id,
    c.nombre as cliente,
    pr.nombre as producto,
    pi.cantidad,
    pi.precio_unitario,
    pi.cantidad * pi.precio_unitario as subtotal
FROM pedidos p
JOIN clientes c ON p.cliente_id = c.cliente_id
JOIN pedidos_items pi ON p.pedido_id = pi.pedido_id
JOIN productos pr ON pi.producto_id = pr.producto_id
WHERE p.pedido_id = 1;

-- Actualizar dirección del cliente (solo un lugar)
UPDATE clientes SET direccion = 'Nueva Dirección 789' WHERE cliente_id = 1;
```

---

## 🔐 **TERCERA FORMA NORMAL (3FN)**

### **📋 Reglas:**
1. ✅ Debe estar en **2FN**
2. ✅ **No debe haber dependencias transitivas** (atributo no-clave que depende de otro atributo no-clave)

### **❌ ANTES (Solo 2FN):**

```sql
-- Tabla con dependencias transitivas (PROBLEMÁTICA)
CREATE TABLE empleados_mal_3fn (
    empleado_id INTEGER PRIMARY KEY,
    nombre VARCHAR(100),
    departamento_codigo VARCHAR(10),
    -- ❌ Estos campos dependen de departamento_codigo, no del empleado
    departamento_nombre VARCHAR(100),
    departamento_ubicacion VARCHAR(100),
    departamento_presupuesto DECIMAL(12,2),
    salario DECIMAL(10,2)
);

-- Datos con dependencia transitiva:
INSERT INTO empleados_mal_3fn VALUES 
(1, 'Juan Pérez', 'IT', 'Tecnología', 'Edificio A - Piso 3', 500000.00, 75000.00),
(2, 'Ana García', 'IT', 'Tecnología', 'Edificio A - Piso 3', 500000.00, 80000.00),
(3, 'Carlos López', 'VENTAS', 'Ventas y Marketing', 'Edificio B - Piso 1', 300000.00, 65000.00),
(4, 'María Rodríguez', 'IT', 'Tecnología', 'Edificio A - Piso 3', 500000.00, 85000.00),
(5, 'Pedro Martín', 'VENTAS', 'Ventas y Marketing', 'Edificio B - Piso 1', 300000.00, 70000.00);
```

**🚨 Problemas identificados:**
- Información del departamento se repite para cada empleado
- Si cambia el presupuesto del departamento IT, hay que actualizar múltiples registros
- Si se elimina el último empleado de un departamento, se pierde la información del departamento

### **✅ DESPUÉS (3FN Aplicada):**

```sql
-- Tabla de departamentos (información independiente)
CREATE TABLE departamentos (
    codigo VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ubicacion VARCHAR(100),
    presupuesto DECIMAL(12,2),
    manager_id INTEGER, -- Referencia circular, se llena después
    fecha_creacion DATE DEFAULT CURRENT_DATE
);

-- Tabla de empleados (sin dependencias transitivas)
CREATE TABLE empleados_3fn (
    empleado_id INTEGER PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    departamento_codigo VARCHAR(10) REFERENCES departamentos(codigo),
    salario DECIMAL(10,2),
    fecha_ingreso DATE DEFAULT CURRENT_DATE,
    activo BOOLEAN DEFAULT true
);

-- Actualizar referencia circular
ALTER TABLE departamentos 
ADD CONSTRAINT fk_manager 
FOREIGN KEY (manager_id) REFERENCES empleados_3fn(empleado_id);

-- Datos normalizados:
INSERT INTO departamentos VALUES 
('IT', 'Tecnología', 'Edificio A - Piso 3', 500000.00, NULL),
('VENTAS', 'Ventas y Marketing', 'Edificio B - Piso 1', 300000.00, NULL),
('RRHH', 'Recursos Humanos', 'Edificio C - Piso 2', 200000.00, NULL);

INSERT INTO empleados_3fn VALUES 
(1, 'Juan Pérez', 'IT', 75000.00, '2023-01-15', true),
(2, 'Ana García', 'IT', 80000.00, '2023-03-10', true),
(3, 'Carlos López', 'VENTAS', 65000.00, '2023-02-20', true),
(4, 'María Rodríguez', 'IT', 85000.00, '2023-04-05', true),
(5, 'Pedro Martín', 'VENTAS', 70000.00, '2023-06-12', true);

-- Asignar managers
UPDATE departamentos SET manager_id = 4 WHERE codigo = 'IT';
UPDATE departamentos SET manager_id = 5 WHERE codigo = 'VENTAS';
```

**🎯 Beneficios conseguidos:**
```sql
-- Consultas más mantenibles:

-- Empleados con información de departamento
SELECT 
    e.nombre as empleado,
    e.salario,
    d.nombre as departamento,
    d.ubicacion,
    d.presupuesto
FROM empleados_3fn e
JOIN departamentos d ON e.departamento_codigo = d.codigo;

-- Cambiar presupuesto de departamento (solo un lugar)
UPDATE departamentos SET presupuesto = 600000.00 WHERE codigo = 'IT';

-- Estadísticas por departamento
SELECT 
    d.nombre as departamento,
    COUNT(e.empleado_id) as total_empleados,
    AVG(e.salario) as salario_promedio,
    SUM(e.salario) as costo_total_salarios,
    d.presupuesto,
    d.presupuesto - SUM(e.salario) as presupuesto_disponible
FROM departamentos d
LEFT JOIN empleados_3fn e ON d.codigo = e.departamento_codigo
WHERE e.activo = true
GROUP BY d.codigo, d.nombre, d.presupuesto;
```

---

## 🏛️ **FORMA NORMAL BOYCE-CODD (BCNF)**

### **📋 Reglas:**
1. ✅ Debe estar en **3FN**
2. ✅ **Toda dependencia funcional** debe tener como determinante una **superclave**

### **🎯 Caso de Uso - Sistema de Cursos:**

```sql
-- Situación compleja: Un profesor puede enseñar un curso en múltiples horarios
-- Un curso puede ser enseñado por múltiples profesores
-- Cada combinación profesor-curso tiene un horario específico

-- ❌ Diseño problemático (3FN pero no BCNF)
CREATE TABLE cursos_profesores_mal (
    curso VARCHAR(50),
    profesor VARCHAR(50),
    horario VARCHAR(20),
    aula VARCHAR(10),
    PRIMARY KEY (curso, profesor, horario)
);

-- Si un profesor solo puede enseñar un curso en un horario específico,
-- pero un curso puede tener múltiples horarios con diferentes profesores

-- ✅ Diseño BCNF
CREATE TABLE cursos (
    curso_id INTEGER PRIMARY KEY,
    nombre VARCHAR(100),
    creditos INTEGER,
    descripcion TEXT
);

CREATE TABLE profesores (
    profesor_id INTEGER PRIMARY KEY,
    nombre VARCHAR(100),
    especialidad VARCHAR(50),
    email VARCHAR(100)
);

CREATE TABLE horarios (
    horario_id INTEGER PRIMARY KEY,
    dia_semana VARCHAR(10),
    hora_inicio TIME,
    hora_fin TIME,
    aula VARCHAR(10)
);

CREATE TABLE curso_asignaciones (
    asignacion_id INTEGER PRIMARY KEY,
    curso_id INTEGER REFERENCES cursos(curso_id),
    profesor_id INTEGER REFERENCES profesores(profesor_id),
    horario_id INTEGER REFERENCES horarios(horario_id),
    semestre VARCHAR(20),
    UNIQUE(profesor_id, horario_id, semestre), -- Un profesor, un horario
    UNIQUE(horario_id, semestre) -- Un horario, una asignación por semestre
);
```

---

## 🔢 **CUARTA FORMA NORMAL (4FN)**

### **📋 Reglas:**
1. ✅ Debe estar en **BCNF**
2. ✅ **No debe haber dependencias multivaluadas** independientes

### **🎯 Caso de Uso - Empleados con Habilidades y Proyectos:**

```sql
-- ❌ Problema: Dependencias multivaluadas
-- Un empleado puede tener múltiples habilidades independientemente de sus proyectos
-- Un empleado puede trabajar en múltiples proyectos independientemente de sus habilidades

CREATE TABLE empleados_habilidades_proyectos_mal (
    empleado_id INTEGER,
    habilidad VARCHAR(50),
    proyecto VARCHAR(50),
    PRIMARY KEY (empleado_id, habilidad, proyecto)
);

-- Esto genera combinaciones innecesarias:
-- Si Juan tiene habilidades [Java, Python] y proyectos [A, B]
-- Se generan 4 registros: (Juan, Java, A), (Juan, Java, B), (Juan, Python, A), (Juan, Python, B)

-- ✅ Solución 4FN: Separar las dependencias multivaluadas
CREATE TABLE empleados_habilidades_4fn (
    empleado_id INTEGER,
    habilidad VARCHAR(50),
    PRIMARY KEY (empleado_id, habilidad)
);

CREATE TABLE empleados_proyectos_4fn (
    empleado_id INTEGER,
    proyecto VARCHAR(50),
    fecha_asignacion DATE,
    PRIMARY KEY (empleado_id, proyecto)
);
```

---

## 🏆 **QUINTA FORMA NORMAL (5FN) - FORMA NORMAL DE PROYECCIÓN-UNIÓN**

### **📋 Reglas:**
1. ✅ Debe estar en **4FN**
2. ✅ **No debe haber dependencias de unión** que no sean implicadas por claves candidatas

### **🎯 Caso de Uso Complejo - Proveedores, Productos y Ciudades:**

```sql
-- Situación: Un proveedor puede suministrar un producto a una ciudad
-- Pero solo si: el proveedor opera en esa ciudad Y el producto se vende en esa ciudad

-- ✅ Diseño 5FN
CREATE TABLE proveedores_5fn (
    proveedor_id INTEGER PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE productos_5fn (
    producto_id INTEGER PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE ciudades_5fn (
    ciudad_id INTEGER PRIMARY KEY,
    nombre VARCHAR(100)
);

-- Relaciones binarias necesarias
CREATE TABLE proveedor_ciudad (
    proveedor_id INTEGER REFERENCES proveedores_5fn(proveedor_id),
    ciudad_id INTEGER REFERENCES ciudades_5fn(ciudad_id),
    PRIMARY KEY (proveedor_id, ciudad_id)
);

CREATE TABLE producto_ciudad (
    producto_id INTEGER REFERENCES productos_5fn(producto_id),
    ciudad_id INTEGER REFERENCES ciudades_5fn(ciudad_id),
    PRIMARY KEY (producto_id, ciudad_id)
);

CREATE TABLE proveedor_producto (
    proveedor_id INTEGER REFERENCES proveedores_5fn(proveedor_id),
    producto_id INTEGER REFERENCES productos_5fn(producto_id),
    PRIMARY KEY (proveedor_id, producto_id)
);

-- La relación ternaria se deriva automáticamente de las tres binarias
```

---

## 🎯 **EJERCICIOS PRÁCTICOS**

### **🏆 Ejercicio 1: Normalizar Sistema de Biblioteca**

```sql
-- ❌ Tabla no normalizada
CREATE TABLE biblioteca_mal (
    libro_id INTEGER,
    titulo VARCHAR(200),
    autores VARCHAR(300), -- Múltiples autores separados por comas
    generos VARCHAR(200), -- Múltiples géneros
    editorial VARCHAR(100),
    editorial_direccion VARCHAR(200),
    editorial_telefono VARCHAR(20),
    fecha_publicacion DATE,
    isbn VARCHAR(20),
    prestamo_id INTEGER,
    usuario_nombre VARCHAR(100),
    usuario_direccion VARCHAR(200),
    usuario_telefono VARCHAR(20),
    fecha_prestamo DATE,
    fecha_devolucion DATE
);

-- ✅ Tu tarea: Normalizar hasta 3FN
-- Crear las tablas necesarias y mostrar las relaciones
```

### **🏆 Ejercicio 2: Análisis de Normalización**

```sql
-- Analiza esta tabla y identifica qué forma normal viola:
CREATE TABLE ventas_completas (
    venta_id INTEGER PRIMARY KEY,
    cliente_id INTEGER,
    cliente_nombre VARCHAR(100),
    cliente_ciudad VARCHAR(50),
    vendedor_id INTEGER,
    vendedor_nombre VARCHAR(100),
    vendedor_comision DECIMAL(5,2),
    producto_id INTEGER,
    producto_nombre VARCHAR(100),
    categoria VARCHAR(50),
    precio_unitario DECIMAL(10,2),
    cantidad INTEGER,
    descuento DECIMAL(5,2),
    total_linea DECIMAL(10,2), -- cantidad * precio_unitario * (1 - descuento)
    fecha_venta DATE
);

-- Preguntas:
-- 1. ¿Qué problemas de normalización identificas?
-- 2. ¿Hasta qué forma normal llega?
-- 3. Propón un diseño normalizado
```

---

## 📊 **CUÁNDO NO NORMALIZAR (DESNORMALIZACIÓN)**

### **🎯 Casos Válidos para Desnormalización:**

#### **1. Sistemas de Reporting/Analytics**
```sql
-- Para reportes, a veces es mejor tener datos desnormalizados
CREATE TABLE ventas_resumen_desnormalizado (
    fecha DATE,
    producto_nombre VARCHAR(100),
    categoria VARCHAR(50),
    vendedor_nombre VARCHAR(100),
    region VARCHAR(50),
    cantidad_vendida INTEGER,
    ingresos DECIMAL(12,2),
    costo DECIMAL(12,2),
    ganancia DECIMAL(12,2)
);

-- Beneficio: Consultas de reporte súper rápidas
-- Costo: Mantenimiento más complejo
```

#### **2. Sistemas de Alto Rendimiento**
```sql
-- Cache de datos frecuentemente consultados
CREATE TABLE productos_con_cache (
    producto_id INTEGER PRIMARY KEY,
    nombre VARCHAR(100),
    precio DECIMAL(10,2),
    -- Campos desnormalizados para rendimiento
    total_ventas_mes INTEGER,
    rating_promedio DECIMAL(3,2),
    stock_actual INTEGER
);
```

### **⚖️ Cuándo Considerar Desnormalización:**
- ✅ **Consultas muy frecuentes** que requieren múltiples JOINs
- ✅ **Sistemas de solo lectura** (data warehouses)
- ✅ **Requisitos de rendimiento críticos**
- ✅ **Datos que cambian raramente**

### **❌ Cuándo NO Desnormalizar:**
- ❌ **Datos que cambian frecuentemente**
- ❌ **Sistemas transaccionales** (OLTP)
- ❌ **Cuando la consistencia es crítica**
- ❌ **Equipos pequeños** (difícil mantener)

---

## 💡 **MEJORES PRÁCTICAS**

### **✅ Recomendaciones Generales:**

1. **Empezar Normalizado:**
   ```sql
   -- Siempre diseña normalizado primero
   -- Desnormaliza solo cuando sea necesario y medible
   ```

2. **Documentar Decisiones:**
   ```sql
   -- Documenta por qué desnormalizas
   COMMENT ON TABLE ventas_resumen IS 
   'Tabla desnormalizada para reportes. Actualizada cada noche a las 2 AM';
   ```

3. **Usar Vistas para Abstracción:**
   ```sql
   -- Mantén datos normalizados, usa vistas para presentación
   CREATE VIEW empleados_completo AS
   SELECT 
       e.nombre,
       e.salario,
       d.nombre as departamento,
       d.ubicacion
   FROM empleados e
   JOIN departamentos d ON e.departamento_codigo = d.codigo;
   ```

4. **Índices Estratégicos:**
   ```sql
   -- Los datos normalizados necesitan índices bien pensados
   CREATE INDEX idx_empleados_departamento ON empleados(departamento_codigo);
   CREATE INDEX idx_ventas_cliente_fecha ON ventas(cliente_id, fecha_venta);
   ```

---

## 🔗 **RECURSOS ADICIONALES**

### **📚 Guías Relacionadas:**
- **Tutorial SQL:** `../../05-EXERCISES/sql-queries/tutorial-sql.md`
- **Ejercicios de calidad:** `../../05-EXERCISES/data-quality/ejercicios-calidad.md`
- **Triggers avanzados:** `../sql-avanzado/triggers.md`

### **🛠️ Herramientas Útiles:**
- **DBeaver:** Para diseñar diagramas ER
- **draw.io:** Para documentar esquemas
- **PostgreSQL:** Para implementar y probar

### **📖 Lecturas Recomendadas:**
- "Database Design for Mere Mortals" - Michael Hernandez
- "SQL Antipatterns" - Bill Karwin
- PostgreSQL Documentation - Table Design

---

## 🆘 **¿NECESITAS AYUDA?**

### **🚨 Problemas Comunes:**
- **Sobre-normalización:** No siempre 5FN es mejor
- **Rendimiento lento:** Considera índices antes que desnormalización
- **Diseño complejo:** Empieza simple, evoluciona gradualmente

### **📞 Soporte:**
- **Instructor:** Consulta en clase sobre casos específicos
- **Documentación:** PostgreSQL table design best practices
- **Community:** Database design forums

**🎯 ¡Con estos conceptos dominarás el diseño de bases de datos eficientes y mantenibles!**
