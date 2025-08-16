# 📚 Guía Básica de SQL

## 🎯 ¿Qué es SQL?
SQL (Structured Query Language) es el lenguaje estándar para trabajar con bases de datos relacionales. Te permite crear, modificar y consultar datos.

---

## 📋 Comandos Básicos

### 1. SELECT - Consultar datos
```sql
-- Seleccionar todas las columnas
SELECT * FROM nombre_tabla;

-- Seleccionar columnas específicas
SELECT columna1, columna2 FROM nombre_tabla;

-- Seleccionar con alias (cambiar nombre de columna)
SELECT columna1 AS alias1, columna2 AS alias2 FROM nombre_tabla;
```

**Ejemplo práctico:**
```sql
SELECT nombre, edad, ciudad FROM clientes;
SELECT nombre AS "Nombre del Cliente", edad AS "Edad" FROM clientes;
```

### 2. WHERE - Filtrar datos
```sql
-- Filtrar por condición
SELECT * FROM nombre_tabla WHERE condicion;

-- Operadores de comparación
SELECT * FROM clientes WHERE edad > 25;
SELECT * FROM clientes WHERE ciudad = 'Madrid';
SELECT * FROM clientes WHERE edad BETWEEN 18 AND 65;
SELECT * FROM clientes WHERE ciudad IN ('Madrid', 'Barcelona', 'Valencia');
```

**Ejemplos:**
```sql
-- Clientes mayores de 30 años
SELECT * FROM clientes WHERE edad > 30;

-- Clientes de Madrid
SELECT * FROM clientes WHERE ciudad = 'Madrid';

-- Clientes con edad entre 25 y 50
SELECT * FROM clientes WHERE edad BETWEEN 25 AND 50;
```

### 3. ORDER BY - Ordenar resultados
```sql
-- Ordenar ascendente (por defecto)
SELECT * FROM nombre_tabla ORDER BY columna;

-- Ordenar descendente
SELECT * FROM nombre_tabla ORDER BY columna DESC;

-- Ordenar por múltiples columnas
SELECT * FROM nombre_tabla ORDER BY columna1, columna2 DESC;
```

**Ejemplos:**
```sql
-- Ordenar clientes por edad (menor a mayor)
SELECT * FROM clientes ORDER BY edad;

-- Ordenar clientes por edad (mayor a menor)
SELECT * FROM clientes ORDER BY edad DESC;

-- Ordenar por ciudad y luego por edad
SELECT * FROM clientes ORDER BY ciudad, edad DESC;
```

### 4. LIMIT - Limitar resultados
```sql
-- Mostrar solo los primeros 10 registros
SELECT * FROM nombre_tabla LIMIT 10;

-- Combinar con ORDER BY
SELECT * FROM nombre_tabla ORDER BY columna DESC LIMIT 5;
```

**Ejemplo:**
```sql
-- Los 5 clientes más jóvenes
SELECT * FROM clientes ORDER BY edad LIMIT 5;
```

---

## 🔗 JOIN - Unir tablas

### INNER JOIN (Solo registros que coinciden)
```sql
SELECT tabla1.columna1, tabla2.columna2
FROM tabla1
INNER JOIN tabla2 ON tabla1.id = tabla2.tabla1_id;
```

**Ejemplo:**
```sql
-- Unir clientes con sus pedidos
SELECT clientes.nombre, pedidos.fecha, pedidos.total
FROM clientes
INNER JOIN pedidos ON clientes.id = pedidos.cliente_id;
```

### LEFT JOIN (Todos los registros de la tabla izquierda)
```sql
SELECT tabla1.columna1, tabla2.columna2
FROM tabla1
LEFT JOIN tabla2 ON tabla1.id = tabla2.tabla1_id;
```

**Ejemplo:**
```sql
-- Todos los clientes, incluso si no tienen pedidos
SELECT clientes.nombre, pedidos.fecha
FROM clientes
LEFT JOIN pedidos ON clientes.id = pedidos.cliente_id;
```

---

## 📊 Funciones Agregadas

### COUNT - Contar registros
```sql
-- Contar todos los registros
SELECT COUNT(*) FROM nombre_tabla;

-- Contar registros que cumplen condición
SELECT COUNT(*) FROM clientes WHERE edad > 25;
```

### SUM - Sumar valores
```sql
-- Sumar una columna
SELECT SUM(total) FROM pedidos;

-- Sumar con condición
SELECT SUM(total) FROM pedidos WHERE fecha >= '2024-01-01';
```

### AVG - Promedio
```sql
-- Calcular promedio
SELECT AVG(edad) FROM clientes;

-- Promedio con condición
SELECT AVG(total) FROM pedidos WHERE cliente_id = 1;
```

### MAX/MIN - Valor máximo/mínimo
```sql
-- Valor máximo
SELECT MAX(edad) FROM clientes;

-- Valor mínimo
SELECT MIN(total) FROM pedidos;
```

---

## 📝 INSERT - Insertar datos

### Insertar un registro
```sql
INSERT INTO nombre_tabla (columna1, columna2) VALUES (valor1, valor2);
```

**Ejemplo:**
```sql
INSERT INTO clientes (nombre, edad, ciudad) VALUES ('Juan Pérez', 30, 'Madrid');
```

### Insertar múltiples registros
```sql
INSERT INTO clientes (nombre, edad, ciudad) VALUES 
    ('Ana García', 25, 'Barcelona'),
    ('Carlos López', 35, 'Valencia'),
    ('María Rodríguez', 28, 'Madrid');
```

---

## ✏️ UPDATE - Actualizar datos

### Actualizar registros
```sql
UPDATE nombre_tabla SET columna = nuevo_valor WHERE condicion;
```

**Ejemplos:**
```sql
-- Actualizar edad de un cliente específico
UPDATE clientes SET edad = 31 WHERE id = 1;

-- Actualizar ciudad de todos los clientes de Madrid
UPDATE clientes SET ciudad = 'Barcelona' WHERE ciudad = 'Madrid';
```

---

## 🗑️ DELETE - Eliminar datos

### Eliminar registros
```sql
DELETE FROM nombre_tabla WHERE condicion;
```

**Ejemplos:**
```sql
-- Eliminar un cliente específico
DELETE FROM clientes WHERE id = 1;

-- Eliminar todos los clientes menores de 18 años
DELETE FROM clientes WHERE edad < 18;
```

---

## 📊 GROUP BY - Agrupar datos

### Agrupar y agregar
```sql
SELECT columna, COUNT(*) as cantidad
FROM nombre_tabla
GROUP BY columna;
```

**Ejemplos:**
```sql
-- Contar clientes por ciudad
SELECT ciudad, COUNT(*) as cantidad_clientes
FROM clientes
GROUP BY ciudad;

-- Promedio de edad por ciudad
SELECT ciudad, AVG(edad) as edad_promedio
FROM clientes
GROUP BY ciudad;
```

---

## 🔍 HAVING - Filtrar grupos

### Filtrar después de agrupar
```sql
SELECT columna, COUNT(*) as cantidad
FROM nombre_tabla
GROUP BY columna
HAVING COUNT(*) > 5;
```

**Ejemplo:**
```sql
-- Ciudades con más de 10 clientes
SELECT ciudad, COUNT(*) as cantidad_clientes
FROM clientes
GROUP BY ciudad
HAVING COUNT(*) > 10;
```

---

## 🎯 Operadores Lógicos

### AND - Y lógico
```sql
SELECT * FROM clientes WHERE edad > 25 AND ciudad = 'Madrid';
```

### OR - O lógico
```sql
SELECT * FROM clientes WHERE ciudad = 'Madrid' OR ciudad = 'Barcelona';
```

### NOT - Negación
```sql
SELECT * FROM clientes WHERE NOT ciudad = 'Madrid';
```

---

## 📝 Tipos de Datos Comunes

- **INTEGER**: Números enteros (1, 2, 3...)
- **VARCHAR(n)**: Texto de hasta n caracteres
- **TEXT**: Texto sin límite
- **DATE**: Fecha (YYYY-MM-DD)
- **TIMESTAMP**: Fecha y hora
- **DECIMAL(p,s)**: Números decimales
- **BOOLEAN**: Verdadero/Falso

---

## 🔗 **JOINs - Uniendo Tablas (Concepto Fundamental)**

Los JOINs son la base para relacionar datos entre múltiples tablas. Te explico cada tipo con ejemplos visuales:

### **🎯 ¿Qué son los JOINs?**
Los JOINs permiten combinar filas de dos o más tablas basándose en una condición de relación.

### **📊 Tipos de JOINs**

#### **1. INNER JOIN (JOIN por defecto)**
**Solo muestra registros que coinciden en AMBAS tablas**

```sql
-- Sintaxis básica
SELECT columnas
FROM tabla1
INNER JOIN tabla2 ON tabla1.id = tabla2.tabla1_id;

-- Ejemplo práctico
SELECT c.nombre, v.fecha, v.total
FROM clientes c
INNER JOIN ventas v ON c.id = v.id_cliente;
```

**Visualización:**
```
Tabla A: clientes          Tabla B: ventas
┌─────┬─────────┐         ┌─────┬─────────┬─────────┐
│ id  │ nombre  │         │ id  │cliente_id│ total  │
├─────┼─────────┤         ├─────┼─────────┼─────────┤
│  1  │ Juan    │         │  1  │    1    │  100   │
│  2  │ Ana     │         │  2  │    1    │  150   │
│  3  │ Carlos  │         │  3  │    2    │   75   │
└─────┴─────────┘         └─────┴─────────┴─────────┘

INNER JOIN Resultado:
┌─────────┬─────────┬─────────┐
│ nombre  │ fecha  │ total   │
├─────────┼─────────┼─────────┤
│ Juan    │   1    │  100    │ ← Solo registros que coinciden
│ Juan    │   2    │  150    │ ← Solo registros que coinciden
│ Ana     │   3    │   75    │ ← Solo registros que coinciden
└─────────┴─────────┴─────────┘
```

#### **2. LEFT JOIN (LEFT OUTER JOIN)**
**Muestra TODOS los registros de la tabla izquierda + coincidencias de la derecha**

```sql
-- Sintaxis
SELECT columnas
FROM tabla1
LEFT JOIN tabla2 ON tabla1.id = tabla2.tabla1_id;

-- Ejemplo: Todos los clientes, tengan o no ventas
SELECT c.nombre, v.fecha, v.total
FROM clientes c
LEFT JOIN ventas v ON c.id = v.id_cliente;
```

**Visualización:**
```
Tabla A: clientes          Tabla B: ventas
┌─────┬─────────┐         ┌─────┬─────────┬─────────┐
│ id  │ nombre  │         │ id  │cliente_id│ total  │
├─────┼─────────┤         ├─────┼─────────┼─────────┤
│  1  │ Juan    │         │  1  │    1    │  100   │
│  2  │ Ana     │         │  2  │    1    │  150   │
│  3  │ Carlos  │         │  3  │    2    │   75   │
└─────┴─────────┘         └─────┴─────────┴─────────┘

LEFT JOIN Resultado:
┌─────────┬─────────┬─────────┐
│ nombre  │ fecha  │ total   │
├─────────┼─────────┼─────────┤
│ Juan    │   1    │  100    │ ← Coincide
│ Juan    │   2    │  150    │ ← Coincide
│ Ana     │   3    │   75    │ ← Coincide
│ Carlos  │ NULL   │  NULL   │ ← NO tiene ventas, pero aparece
└─────────┴─────────┴─────────┘
```

#### **3. RIGHT JOIN (RIGHT OUTER JOIN)**
**Muestra TODOS los registros de la tabla derecha + coincidencias de la izquierda**

```sql
-- Sintaxis
SELECT columnas
FROM tabla1
RIGHT JOIN tabla2 ON tabla1.id = tabla2.tabla1_id;

-- Ejemplo: Todas las ventas, aunque el cliente no exista
SELECT c.nombre, v.fecha, v.total
FROM clientes c
RIGHT JOIN ventas v ON c.id = v.id_cliente;
```

**Visualización:**
```
Tabla A: clientes          Tabla B: ventas
┌─────┬─────────┐         ┌─────┬─────────┬─────────┐
│ id  │ nombre  │         │ id  │cliente_id│ total  │
├─────┼─────────┤         ├─────┼─────────┼─────────┤
│  1  │ Juan    │         │  1  │    1    │  100   │
│  2  │ Ana     │         │  2  │    1    │  150   │
│  3  │ Carlos  │         │  3  │    2    │   75   │
└─────┴─────────┘         └─────┴─────────┴─────────┘

RIGHT JOIN Resultado:
┌─────────┬─────────┬─────────┐
│ nombre  │ fecha  │ total   │
├─────────┼─────────┼─────────┤
│ Juan    │   1    │  100    │ ← Coincide
│ Juan    │   2    │  150    │ ← Coincide
│ Ana     │   3    │   75    │ ← Coincide
│ NULL    │   4    │  200    │ ← Venta sin cliente (aparece)
└─────────┴─────────┴─────────┘
```

#### **4. FULL JOIN (FULL OUTER JOIN)**
**Muestra TODOS los registros de AMBAS tablas**

```sql
-- Sintaxis
SELECT columnas
FROM tabla1
FULL JOIN tabla2 ON tabla1.id = tabla2.tabla1_id;

-- Ejemplo: Todos los clientes y todas las ventas
SELECT c.nombre, v.fecha, v.total
FROM clientes c
FULL JOIN ventas v ON c.id = v.id_cliente;
```

**Visualización:**
```
Tabla A: clientes          Tabla B: ventas
┌─────┬─────────┐         ┌─────┬─────────┬─────────┐
│ id  │ nombre  │         │ id  │cliente_id│ total  │
├─────┼─────────┤         ├─────┼─────────┼─────────┤
│  1  │ Juan    │         │  1  │    1    │  100   │
│  2  │ Ana     │         │  2  │    1    │  150   │
│  3  │ Carlos  │         │  3  │    2    │   75   │
└─────┴─────────┘         └─────┴─────────┴─────────┘

FULL JOIN Resultado:
┌─────────┬─────────┬─────────┐
│ nombre  │ fecha  │ total   │
├─────────┼─────────┼─────────┤
│ Juan    │   1    │  100    │ ← Coincide
│ Juan    │   2    │  150    │ ← Coincide
│ Ana     │   3    │   75    │ ← Coincide
│ Carlos  │ NULL   │  NULL   │ ← Cliente sin ventas
│ NULL    │   4    │  200    │ ← Venta sin cliente
└─────────┴─────────┴─────────┘
```

#### **5. CROSS JOIN (Producto Cartesiano)**
**Combina CADA fila de la primera tabla con CADA fila de la segunda**

```sql
-- Sintaxis
SELECT columnas
FROM tabla1
CROSS JOIN tabla2;

-- Ejemplo: Todas las combinaciones posibles
SELECT c.nombre, p.nombre as producto
FROM clientes c
CROSS JOIN productos p;
```

**Visualización:**
```
Tabla A: clientes          Tabla B: productos
┌─────┬─────────┐         ┌─────┬─────────┐
│ id  │ nombre  │         │ id  │ nombre  │
├─────┼─────────┤         ├─────┼─────────┤
│  1  │ Juan    │         │  1  │ Laptop  │
│  2  │ Ana     │         │  2  │ Mouse   │
└─────┴─────────┘         └─────┴─────────┘

CROSS JOIN Resultado:
┌─────────┬─────────┐
│ nombre  │producto │
├─────────┼─────────┤
│ Juan    │ Laptop  │ ← Juan + Laptop
│ Juan    │ Mouse   │ ← Juan + Mouse
│ Ana     │ Laptop  │ ← Ana + Laptop
│ Ana     │ Mouse   │ ← Ana + Mouse
└─────────┴─────────┘
```

### **🎯 Casos de Uso Prácticos**

#### **Ejemplo 1: Clientes con sus ventas totales**
```sql
SELECT 
    c.nombre,
    COUNT(v.id_venta) as total_ventas,
    SUM(v.total) as monto_total
FROM clientes c
LEFT JOIN ventas v ON c.id = v.id_cliente
GROUP BY c.id, c.nombre
ORDER BY monto_total DESC;
```

#### **Ejemplo 2: Productos que nunca se vendieron**
```sql
SELECT p.nombre, p.precio
FROM productos p
LEFT JOIN ventas v ON p.id = v.id_producto
WHERE v.id_venta IS NULL;
```

#### **Ejemplo 3: Empleados con ventas por sucursal**
```sql
SELECT 
    e.nombre,
    s.nombre as sucursal,
    COUNT(v.id_venta) as ventas_realizadas
FROM empleados e
INNER JOIN sucursales s ON e.id_sucursal = s.id
LEFT JOIN ventas v ON e.id = v.id_empleado
GROUP BY e.id, e.nombre, s.nombre
ORDER BY ventas_realizadas DESC;
```

### **⚠️ Errores Comunes con JOINs**

#### **1. Olvidar la condición ON**
```sql
-- ❌ MALO - Crea producto cartesiano (miles de filas)
SELECT * FROM clientes JOIN ventas;

-- ✅ BUENO - Especifica la relación
SELECT * FROM clientes JOIN ventas ON clientes.id = ventas.id_cliente;
```

#### **2. Usar JOINs innecesarios**
```sql
-- ❌ MALO - JOIN innecesario
SELECT c.nombre, c.edad
FROM clientes c
JOIN ventas v ON c.id = v.id_cliente
WHERE c.ciudad = 'Madrid';

-- ✅ BUENO - Solo una tabla
SELECT nombre, edad
FROM clientes
WHERE ciudad = 'Madrid';
```

#### **3. Confundir LEFT vs RIGHT JOIN**
```sql
-- ❌ CONFUSO - RIGHT JOIN
SELECT c.nombre, v.fecha
FROM clientes c
RIGHT JOIN ventas v ON c.id = v.id_cliente;

-- ✅ CLARO - LEFT JOIN (más intuitivo)
SELECT c.nombre, v.fecha
FROM ventas v
LEFT JOIN clientes c ON v.id_cliente = c.id;
```

### **🔍 Diagrama de Venn de JOINs**

```
INNER JOIN:        LEFT JOIN:         RIGHT JOIN:        FULL JOIN:
    A ∩ B             A                    B              A ∪ B
   ┌───┐            ┌───┐               ┌───┐           ┌───┐
   │   │            │   │               │   │           │   │
   │███│            │███│               │███│           │███│
   │   │            │   │               │   │           │   │
   └───┘            └───┘               └───┘           └───┘
```

---

## 💡 Consejos Prácticos

### 1. Siempre usa WHERE en UPDATE y DELETE
```sql
-- ❌ MALO - Actualiza TODOS los registros
UPDATE clientes SET edad = 30;

-- ✅ BUENO - Actualiza solo los que necesitas
UPDATE clientes SET edad = 30 WHERE id = 1;
```

### 2. Usa alias para tablas largas
```sql
SELECT c.nombre, p.fecha
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id;
```

### 3. Comenta tu código
```sql
-- Obtener clientes de Madrid mayores de 25 años
SELECT nombre, edad, ciudad
FROM clientes
WHERE ciudad = 'Madrid' AND edad > 25
ORDER BY edad DESC;
```

### 4. Prueba consultas pequeñas primero
```sql
-- Primero ver qué hay en la tabla
SELECT * FROM clientes LIMIT 5;

-- Luego aplicar filtros
SELECT * FROM clientes WHERE ciudad = 'Madrid' LIMIT 5;
```

---

## 🚀 Ejercicios Prácticos

### Ejercicio 1: Consulta básica
```sql
-- Encuentra todos los clientes de Madrid
SELECT * FROM clientes WHERE ciudad = 'Madrid';
```

### Ejercicio 2: Agregación
```sql
-- Calcula el promedio de edad de los clientes
SELECT AVG(edad) as edad_promedio FROM clientes;
```

### Ejercicio 3: JOIN
```sql
-- Obtén el nombre del cliente y sus pedidos
SELECT c.nombre, p.fecha, p.total
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id;
```

### Ejercicio 4: GROUP BY
```sql
-- Cuenta cuántos clientes hay por ciudad
SELECT ciudad, COUNT(*) as cantidad
FROM clientes
GROUP BY ciudad
ORDER BY cantidad DESC;
```

---

## 📚 Recursos Adicionales

- **Documentación oficial**: Busca la documentación de tu base de datos específica
- **Práctica**: La mejor manera de aprender SQL es practicando
- **Prueba y error**: No tengas miedo de experimentar con consultas

---

*¡Recuerda: SQL es como hablar con la base de datos en su propio idioma!* 🗣️💾 