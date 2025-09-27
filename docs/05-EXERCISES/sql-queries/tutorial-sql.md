# 📚 TUTORIAL SQL COMPLETO

> **🎯 Objetivo:** Dominar SQL desde lo básico hasta consultas avanzadas con datos reales del curso

## 🚀 **INICIO RÁPIDO**

### **⚡ Para empezar ahora:**
1. **Conectar a la base de datos** → `../../02-HOW-TO-GUIDES/postgresql/conexion-dbeaver.md`
2. **Verificar datos disponibles** → `SELECT * FROM clientes LIMIT 5;`
3. **Seguir este tutorial** paso a paso

### **🗄️ Datos del Curso:**
```sql
-- Tablas disponibles para practicar:
clientes, productos, ventas, empleados, sucursales, 
proveedores, gastos, tiposdegasto, canaldeventa, compras
```

---

## 📋 **NIVEL 1: COMANDOS BÁSICOS**

### **🔍 SELECT - Consultar Datos**

#### **Sintaxis Básica:**
```sql
-- Seleccionar todas las columnas
SELECT * FROM clientes;

-- Seleccionar columnas específicas
SELECT nombre_completo, email FROM clientes;

-- Usar alias para nombres más claros
SELECT 
    nombre_completo AS "Nombre del Cliente",
    email AS "Correo Electrónico"
FROM clientes;
```

#### **🧪 Ejercicios Prácticos:**
```sql
-- 1. Ver los primeros 10 clientes
SELECT * FROM clientes LIMIT 10;

-- 2. Ver solo nombres y ciudades
SELECT nombre_completo, ciudad FROM clientes;

-- 3. Ver productos con alias
SELECT 
    nombre_producto AS "Producto",
    precio AS "Precio ($)"
FROM productos;
```

---

### **🎯 WHERE - Filtrar Datos**

#### **Operadores de Comparación:**
```sql
-- Igualdad
SELECT * FROM clientes WHERE ciudad = 'Madrid';

-- Mayor que
SELECT * FROM productos WHERE precio > 100;

-- Rango
SELECT * FROM clientes WHERE edad BETWEEN 25 AND 35;

-- Lista de valores
SELECT * FROM clientes WHERE ciudad IN ('Madrid', 'Barcelona', 'Valencia');

-- Patrones de texto
SELECT * FROM clientes WHERE nombre_completo LIKE 'Juan%';
SELECT * FROM productos WHERE nombre_producto LIKE '%iPhone%';
```

#### **🧪 Ejercicios Prácticos:**
```sql
-- 1. Clientes mayores de 30 años
SELECT nombre_completo, edad FROM clientes WHERE edad > 30;

-- 2. Productos caros (más de $500)
SELECT nombre_producto, precio FROM productos WHERE precio > 500;

-- 3. Clientes de ciudades específicas
SELECT * FROM clientes 
WHERE ciudad IN ('Madrid', 'Barcelona', 'Sevilla');

-- 4. Buscar productos Apple
SELECT * FROM productos 
WHERE nombre_producto LIKE '%Apple%' OR nombre_producto LIKE '%iPhone%';
```

---

### **📊 ORDER BY - Ordenar Resultados**

```sql
-- Orden ascendente (por defecto)
SELECT * FROM productos ORDER BY precio;

-- Orden descendente
SELECT * FROM productos ORDER BY precio DESC;

-- Múltiples columnas
SELECT * FROM clientes ORDER BY ciudad, edad DESC;
```

#### **🧪 Ejercicios Prácticos:**
```sql
-- 1. Productos del más caro al más barato
SELECT nombre_producto, precio FROM productos 
ORDER BY precio DESC;

-- 2. Clientes por ciudad y edad
SELECT nombre_completo, ciudad, edad FROM clientes 
ORDER BY ciudad, edad;

-- 3. Top 5 productos más caros
SELECT nombre_producto, precio FROM productos 
ORDER BY precio DESC 
LIMIT 5;
```

---

## 📈 **NIVEL 2: FUNCIONES AGREGADAS**

### **🔢 Funciones Básicas**

```sql
-- Contar registros
SELECT COUNT(*) FROM clientes;
SELECT COUNT(DISTINCT ciudad) AS "Ciudades únicas" FROM clientes;

-- Sumar valores
SELECT SUM(precio * cantidad) AS "Ingresos totales" FROM ventas;

-- Promedio
SELECT AVG(precio) AS "Precio promedio" FROM productos;

-- Máximo y mínimo
SELECT MAX(precio) AS "Producto más caro" FROM productos;
SELECT MIN(edad) AS "Cliente más joven" FROM clientes;
```

#### **🧪 Ejercicios Prácticos:**
```sql
-- 1. Estadísticas de clientes
SELECT 
    COUNT(*) AS "Total clientes",
    AVG(edad) AS "Edad promedio",
    MIN(edad) AS "Más joven",
    MAX(edad) AS "Mayor edad"
FROM clientes;

-- 2. Estadísticas de productos
SELECT 
    COUNT(*) AS "Total productos",
    AVG(precio) AS "Precio promedio",
    MAX(precio) AS "Más caro",
    MIN(precio) AS "Más barato"
FROM productos;

-- 3. Análisis de ventas
SELECT 
    COUNT(*) AS "Total ventas",
    SUM(precio * cantidad) AS "Ingresos totales",
    AVG(precio * cantidad) AS "Venta promedio"
FROM ventas;
```

---

### **📊 GROUP BY - Agrupar Datos**

```sql
-- Agrupar por una columna
SELECT ciudad, COUNT(*) AS "Clientes por ciudad"
FROM clientes 
GROUP BY ciudad;

-- Agrupar con funciones
SELECT 
    ciudad,
    COUNT(*) AS "Total clientes",
    AVG(edad) AS "Edad promedio"
FROM clientes 
GROUP BY ciudad;

-- Filtrar grupos con HAVING
SELECT ciudad, COUNT(*) AS total
FROM clientes 
GROUP BY ciudad 
HAVING COUNT(*) > 10;
```

#### **🧪 Ejercicios Prácticos:**
```sql
-- 1. Clientes por ciudad
SELECT 
    ciudad,
    COUNT(*) AS "Total clientes",
    AVG(edad) AS "Edad promedio"
FROM clientes 
GROUP BY ciudad
ORDER BY COUNT(*) DESC;

-- 2. Ventas por empleado
SELECT 
    id_empleado,
    COUNT(*) AS "Total ventas",
    SUM(precio * cantidad) AS "Ingresos generados"
FROM ventas 
GROUP BY id_empleado
ORDER BY SUM(precio * cantidad) DESC;

-- 3. Productos por rango de precio
SELECT 
    CASE 
        WHEN precio < 100 THEN 'Económico'
        WHEN precio BETWEEN 100 AND 500 THEN 'Medio'
        ELSE 'Premium'
    END AS "Rango de precio",
    COUNT(*) AS "Cantidad productos"
FROM productos 
GROUP BY 
    CASE 
        WHEN precio < 100 THEN 'Económico'
        WHEN precio BETWEEN 100 AND 500 THEN 'Medio'
        ELSE 'Premium'
    END;
```

---

## 🔗 **NIVEL 3: JOINS (UNIONES)**

### **🎯 INNER JOIN - Datos que Coinciden**

```sql
-- Unir clientes con sus ventas
SELECT 
    c.nombre_completo,
    v.fecha_venta,
    v.precio * v.cantidad AS total_venta
FROM clientes c
INNER JOIN ventas v ON c.id_cliente = v.id_cliente;

-- Múltiples joins
SELECT 
    c.nombre_completo AS cliente,
    p.nombre_producto AS producto,
    v.cantidad,
    v.precio * v.cantidad AS total
FROM clientes c
INNER JOIN ventas v ON c.id_cliente = v.id_cliente
INNER JOIN productos p ON v.id_producto = p.id_producto;
```

### **📊 LEFT JOIN - Incluir Todos los Registros de la Izquierda**

```sql
-- Todos los clientes, tengan o no ventas
SELECT 
    c.nombre_completo,
    COUNT(v.id_venta) AS "Total compras",
    COALESCE(SUM(v.precio * v.cantidad), 0) AS "Total gastado"
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
GROUP BY c.id_cliente, c.nombre_completo
ORDER BY "Total gastado" DESC;
```

#### **🧪 Ejercicios Prácticos:**
```sql
-- 1. Top 10 clientes por compras
SELECT 
    c.nombre_completo,
    c.ciudad,
    COUNT(v.id_venta) AS "Total compras",
    SUM(v.precio * v.cantidad) AS "Total gastado"
FROM clientes c
INNER JOIN ventas v ON c.id_cliente = v.id_cliente
GROUP BY c.id_cliente, c.nombre_completo, c.ciudad
ORDER BY "Total gastado" DESC
LIMIT 10;

-- 2. Productos más vendidos
SELECT 
    p.nombre_producto,
    COUNT(v.id_venta) AS "Veces vendido",
    SUM(v.cantidad) AS "Unidades totales"
FROM productos p
INNER JOIN ventas v ON p.id_producto = v.id_producto
GROUP BY p.id_producto, p.nombre_producto
ORDER BY "Unidades totales" DESC
LIMIT 5;

-- 3. Ventas por sucursal y mes
SELECT 
    s.nombre_sucursal,
    DATE_TRUNC('month', v.fecha_venta) AS mes,
    COUNT(v.id_venta) AS "Total ventas",
    SUM(v.precio * v.cantidad) AS "Ingresos"
FROM sucursales s
INNER JOIN ventas v ON s.id_sucursal = v.id_sucursal
GROUP BY s.id_sucursal, s.nombre_sucursal, DATE_TRUNC('month', v.fecha_venta)
ORDER BY mes DESC, "Ingresos" DESC;
```

---

## 🚀 **NIVEL 4: CONSULTAS AVANZADAS**

### **📊 Subconsultas**

```sql
-- Clientes con compras superiores al promedio
SELECT nombre_completo, ciudad
FROM clientes 
WHERE id_cliente IN (
    SELECT id_cliente 
    FROM ventas 
    GROUP BY id_cliente 
    HAVING SUM(precio * cantidad) > (
        SELECT AVG(total_cliente)
        FROM (
            SELECT SUM(precio * cantidad) AS total_cliente
            FROM ventas 
            GROUP BY id_cliente
        ) AS promedios
    )
);

-- Productos nunca vendidos
SELECT nombre_producto, precio
FROM productos 
WHERE id_producto NOT IN (
    SELECT DISTINCT id_producto 
    FROM ventas 
    WHERE id_producto IS NOT NULL
);
```

### **🔄 Window Functions (Funciones de Ventana)**

```sql
-- Ranking de clientes por gastos
SELECT 
    c.nombre_completo,
    SUM(v.precio * v.cantidad) AS total_gastado,
    RANK() OVER (ORDER BY SUM(v.precio * v.cantidad) DESC) AS ranking
FROM clientes c
INNER JOIN ventas v ON c.id_cliente = v.id_cliente
GROUP BY c.id_cliente, c.nombre_completo
ORDER BY ranking;

-- Comparar con promedio móvil
SELECT 
    fecha_venta,
    precio * cantidad AS venta,
    AVG(precio * cantidad) OVER (
        ORDER BY fecha_venta 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS promedio_7_dias
FROM ventas 
ORDER BY fecha_venta;
```

### **🎯 Common Table Expressions (CTE)**

```sql
-- Análisis de clientes VIP
WITH clientes_gastos AS (
    SELECT 
        c.id_cliente,
        c.nombre_completo,
        c.ciudad,
        SUM(v.precio * v.cantidad) AS total_gastado,
        COUNT(v.id_venta) AS total_compras
    FROM clientes c
    INNER JOIN ventas v ON c.id_cliente = v.id_cliente
    GROUP BY c.id_cliente, c.nombre_completo, c.ciudad
),
estadisticas AS (
    SELECT 
        AVG(total_gastado) AS promedio_gasto,
        PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY total_gastado) AS percentil_80
    FROM clientes_gastos
)
SELECT 
    cg.nombre_completo,
    cg.ciudad,
    cg.total_gastado,
    cg.total_compras,
    CASE 
        WHEN cg.total_gastado > e.percentil_80 THEN 'VIP'
        WHEN cg.total_gastado > e.promedio_gasto THEN 'Premium'
        ELSE 'Regular'
    END AS categoria_cliente
FROM clientes_gastos cg
CROSS JOIN estadisticas e
ORDER BY cg.total_gastado DESC;
```

---

## 🛠️ **NIVEL 5: MODIFICACIÓN DE DATOS**

### **➕ INSERT - Insertar Datos**

```sql
-- Insertar un nuevo cliente
INSERT INTO clientes (nombre_completo, email, telefono, ciudad, edad)
VALUES ('Carlos Rodríguez', 'carlos@email.com', '555-0123', 'Madrid', 28);

-- Insertar múltiples registros
INSERT INTO productos (nombre_producto, precio, categoria)
VALUES 
    ('Laptop Gaming', 1299.99, 'Electrónicos'),
    ('Mouse Inalámbrico', 29.99, 'Accesorios'),
    ('Teclado Mecánico', 89.99, 'Accesorios');
```

### **✏️ UPDATE - Actualizar Datos**

```sql
-- Actualizar un registro específico
UPDATE productos 
SET precio = 1199.99 
WHERE nombre_producto = 'Laptop Gaming';

-- Actualización condicional
UPDATE clientes 
SET categoria = 'VIP'
WHERE id_cliente IN (
    SELECT id_cliente 
    FROM ventas 
    GROUP BY id_cliente 
    HAVING SUM(precio * cantidad) > 5000
);
```

### **🗑️ DELETE - Eliminar Datos**

```sql
-- Eliminar registros específicos
DELETE FROM ventas 
WHERE fecha_venta < '2020-01-01';

-- Eliminar con subconsulta
DELETE FROM productos 
WHERE id_producto NOT IN (
    SELECT DISTINCT id_producto 
    FROM ventas 
    WHERE id_producto IS NOT NULL
);
```

---

## 🎯 **EJERCICIOS PRÁCTICOS FINALES**

### **🏆 Desafío 1: Análisis de Rendimiento de Ventas**
```sql
-- Crear un reporte completo de rendimiento
SELECT 
    s.nombre_sucursal,
    DATE_TRUNC('quarter', v.fecha_venta) AS trimestre,
    COUNT(DISTINCT v.id_cliente) AS clientes_unicos,
    COUNT(v.id_venta) AS total_ventas,
    SUM(v.precio * v.cantidad) AS ingresos_totales,
    AVG(v.precio * v.cantidad) AS ticket_promedio,
    RANK() OVER (
        PARTITION BY DATE_TRUNC('quarter', v.fecha_venta)
        ORDER BY SUM(v.precio * v.cantidad) DESC
    ) AS ranking_trimestral
FROM sucursales s
INNER JOIN ventas v ON s.id_sucursal = v.id_sucursal
GROUP BY s.id_sucursal, s.nombre_sucursal, DATE_TRUNC('quarter', v.fecha_venta)
ORDER BY trimestre DESC, ingresos_totales DESC;
```

### **🏆 Desafío 2: Segmentación de Clientes**
```sql
-- Análisis RFM (Recency, Frequency, Monetary)
WITH rfm_base AS (
    SELECT 
        c.id_cliente,
        c.nombre_completo,
        MAX(v.fecha_venta) AS ultima_compra,
        COUNT(v.id_venta) AS frecuencia,
        SUM(v.precio * v.cantidad) AS valor_monetario,
        CURRENT_DATE - MAX(v.fecha_venta) AS dias_desde_ultima_compra
    FROM clientes c
    INNER JOIN ventas v ON c.id_cliente = v.id_cliente
    GROUP BY c.id_cliente, c.nombre_completo
),
rfm_scores AS (
    SELECT *,
        NTILE(5) OVER (ORDER BY dias_desde_ultima_compra) AS recency_score,
        NTILE(5) OVER (ORDER BY frecuencia DESC) AS frequency_score,
        NTILE(5) OVER (ORDER BY valor_monetario DESC) AS monetary_score
    FROM rfm_base
)
SELECT 
    nombre_completo,
    ultima_compra,
    frecuencia,
    valor_monetario,
    recency_score,
    frequency_score,
    monetary_score,
    CASE 
        WHEN recency_score >= 4 AND frequency_score >= 4 AND monetary_score >= 4 THEN 'Champions'
        WHEN recency_score >= 3 AND frequency_score >= 3 AND monetary_score >= 3 THEN 'Loyal Customers'
        WHEN recency_score >= 3 AND frequency_score <= 2 AND monetary_score >= 3 THEN 'Big Spenders'
        WHEN recency_score <= 2 AND frequency_score >= 3 THEN 'At Risk'
        ELSE 'Others'
    END AS segmento_cliente
FROM rfm_scores
ORDER BY monetary_score DESC, frequency_score DESC, recency_score DESC;
```

---

## 📚 **RECURSOS ADICIONALES**

### **🔗 Guías Relacionadas:**
- **Conexión a la base:** `../../02-HOW-TO-GUIDES/postgresql/conexion-dbeaver.md`
- **Conceptos avanzados:** `../../03-CONCEPTS/sql-avanzado.md`
- **Troubleshooting:** `../../02-HOW-TO-GUIDES/troubleshooting/problemas-comunes.md`

### **🎯 Próximos Pasos:**
1. **Ejercicios de calidad de datos:** `../data-quality/ejercicios-calidad.md`
2. **Normalización de bases de datos:** `../../03-CONCEPTS/database-design/normalizacion.md`
3. **Triggers y procedimientos:** `../../03-CONCEPTS/sql-avanzado/triggers.md`

### **💡 Consejos Pro:**
- ✅ **Siempre usar LIMIT** en consultas exploratorias
- ✅ **Crear índices** en columnas frecuentemente consultadas  
- ✅ **Usar EXPLAIN ANALYZE** para optimizar consultas lentas
- ✅ **Hacer backup** antes de UPDATE/DELETE masivos
- ✅ **Usar transacciones** para cambios críticos

---

## 🆘 **¿NECESITAS AYUDA?**

### **🚨 Problemas Comunes:**
- **Error de conexión:** `../../02-HOW-TO-GUIDES/troubleshooting/problemas-comunes.md`
- **Consultas lentas:** `../../03-CONCEPTS/sql-avanzado.md`
- **Datos incorrectos:** `../data-quality/ejercicios-calidad.md`

### **📞 Soporte:**
- **Instructor:** Consulta en clase
- **Documentación:** PostgreSQL official docs
- **Community:** Stack Overflow SQL tag

**🎯 ¡Con este tutorial dominarás SQL desde lo básico hasta consultas de nivel profesional!**
