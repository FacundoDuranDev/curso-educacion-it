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