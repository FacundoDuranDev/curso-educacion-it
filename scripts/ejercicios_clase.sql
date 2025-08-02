-- =====================================================
-- EJERCICIOS PRÁCTICOS - CURSO DATA ENGINEERING
-- EducaciónIT - Base de datos: educacionit
-- =====================================================

-- Ejercicio 1: EXPLORACIÓN DE DATOS
-- =====================================================
-- Analizar la estructura y contenido de las tablas principales

SELECT 'Exploración de datos - Resumen de tablas' as ejercicio;
SELECT '========================================' as separador;

-- Conteo de registros por tabla
SELECT 'Canal de Venta' as tabla, COUNT(*) as registros FROM canal_venta 
UNION ALL SELECT 'Clientes', COUNT(*) FROM clientes 
UNION ALL SELECT 'Compras', COUNT(*) FROM compras 
UNION ALL SELECT 'Empleados', COUNT(*) FROM empleados 
UNION ALL SELECT 'Gastos', COUNT(*) FROM gastos 
UNION ALL SELECT 'Productos', COUNT(*) FROM productos 
UNION ALL SELECT 'Proveedores', COUNT(*) FROM proveedores 
UNION ALL SELECT 'Sucursales', COUNT(*) FROM sucursales 
UNION ALL SELECT 'Tipos de Gasto', COUNT(*) FROM tipos_gasto 
UNION ALL SELECT 'Ventas', COUNT(*) FROM ventas 
ORDER BY tabla;

-- Ejercicio 2: ANÁLISIS DE CALIDAD DE DATOS
-- =====================================================
-- Identificar datos faltantes, duplicados y anomalías

SELECT 'Análisis de calidad de datos' as ejercicio;
SELECT '============================' as separador;

-- 2.1 Datos faltantes en clientes
SELECT 'Clientes con datos faltantes:' as analisis;
SELECT COUNT(*) as clientes_sin_telefono FROM clientes WHERE telefono IS NULL OR telefono = '';
SELECT COUNT(*) as clientes_sin_edad FROM clientes WHERE edad IS NULL;

-- 2.2 Anomalías en precios de productos
SELECT 'Anomalías en precios de productos:' as analisis;
SELECT MIN(precio) as precio_minimo, MAX(precio) as precio_maximo, AVG(precio) as precio_promedio 
FROM productos;

-- 2.3 Anomalías en edades de clientes
SELECT 'Anomalías en edades de clientes:' as analisis;
SELECT MIN(edad) as edad_minima, MAX(edad) as edad_maxima, AVG(edad) as edad_promedio 
FROM clientes WHERE edad IS NOT NULL;

-- Ejercicio 3: ANÁLISIS DE GASTOS
-- =====================================================
-- Analizar gastos por tipo y sucursal

SELECT 'Análisis de gastos por tipo' as ejercicio;
SELECT '===========================' as separador;

-- 3.1 Gastos por tipo
SELECT tg.descripcion, COUNT(*) as cantidad_gastos, SUM(g.monto) as total_gastos
FROM gastos g
JOIN tipos_gasto tg ON g.id_tipo_gasto = tg.id_tipo_gasto
GROUP BY tg.id_tipo_gasto, tg.descripcion
ORDER BY total_gastos DESC;

-- 3.2 Gastos por sucursal
SELECT s.sucursal, COUNT(*) as cantidad_gastos, SUM(g.monto) as total_gastos
FROM gastos g
JOIN sucursales s ON g.id_sucursal = s.id
GROUP BY s.id, s.sucursal
ORDER BY total_gastos DESC;

-- Ejercicio 4: ANÁLISIS DE COMPRAS
-- =====================================================
-- Analizar compras por proveedor y producto

SELECT 'Análisis de compras por proveedor' as ejercicio;
SELECT '=================================' as separador;

-- 4.1 Compras por proveedor
SELECT p.nombre as proveedor, COUNT(*) as cantidad_compras, SUM(c.precio * c.cantidad) as total_comprado
FROM compras c
JOIN proveedores p ON c.id_proveedor = p.id_proveedor
GROUP BY p.id_proveedor, p.nombre
ORDER BY total_comprado DESC;

-- 4.2 Productos más comprados
SELECT pr.concepto, COUNT(*) as cantidad_compras, SUM(c.precio * c.cantidad) as total_comprado
FROM compras c
JOIN productos pr ON c.id_producto = pr.id_producto
GROUP BY pr.id_producto, pr.concepto
ORDER BY cantidad_compras DESC
LIMIT 10;

-- Ejercicio 5: ANÁLISIS TEMPORAL
-- =====================================================
-- Analizar tendencias temporales

SELECT 'Análisis temporal de ventas' as ejercicio;
SELECT '============================' as separador;

-- 5.1 Ventas por mes
SELECT 
    EXTRACT(YEAR FROM fecha) as año,
    EXTRACT(MONTH FROM fecha) as mes,
    COUNT(*) as cantidad_ventas,
    SUM(precio * cantidad) as total_ventas
FROM ventas
GROUP BY EXTRACT(YEAR FROM fecha), EXTRACT(MONTH FROM fecha)
ORDER BY año, mes;

-- 5.2 Ventas por día de la semana
SELECT 
    EXTRACT(DOW FROM fecha) as dia_semana,
    COUNT(*) as cantidad_ventas,
    SUM(precio * cantidad) as total_ventas
FROM ventas
GROUP BY EXTRACT(DOW FROM fecha)
ORDER BY dia_semana;

-- Ejercicio 6: ANÁLISIS DE EMPLEADOS
-- =====================================================
-- Analizar empleados por sucursal y sector

SELECT 'Análisis de empleados por sucursal' as ejercicio;
SELECT '===================================' as separador;

-- 6.1 Empleados por sucursal
SELECT sucursal, COUNT(*) as cantidad_empleados, AVG(salario) as salario_promedio
FROM empleados
GROUP BY sucursal
ORDER BY cantidad_empleados DESC;

-- 6.2 Empleados por sector
SELECT sector, COUNT(*) as cantidad_empleados, AVG(salario) as salario_promedio
FROM empleados
GROUP BY sector
ORDER BY cantidad_empleados DESC;

-- 6.3 Análisis de salarios
SELECT 
    cargo,
    COUNT(*) as cantidad_empleados,
    MIN(salario) as salario_minimo,
    MAX(salario) as salario_maximo,
    AVG(salario) as salario_promedio
FROM empleados
GROUP BY cargo
ORDER BY salario_promedio DESC;

-- Ejercicio 7: ANÁLISIS DE PRODUCTOS
-- =====================================================
-- Analizar productos por tipo y precio

SELECT 'Análisis de productos por tipo' as ejercicio;
SELECT '==============================' as separador;

-- 7.1 Productos por tipo
SELECT tipo, COUNT(*) as cantidad_productos, AVG(precio) as precio_promedio
FROM productos
GROUP BY tipo
ORDER BY cantidad_productos DESC;

-- 7.2 Distribución de precios
SELECT 
    CASE 
        WHEN precio < 100 THEN 'Económico (< $100)'
        WHEN precio BETWEEN 100 AND 500 THEN 'Medio ($100-$500)'
        WHEN precio BETWEEN 500 AND 1000 THEN 'Alto ($500-$1000)'
        ELSE 'Premium (> $1000)'
    END as categoria_precio,
    COUNT(*) as cantidad_productos
FROM productos
GROUP BY 
    CASE 
        WHEN precio < 100 THEN 'Económico (< $100)'
        WHEN precio BETWEEN 100 AND 500 THEN 'Medio ($100-$500)'
        WHEN precio BETWEEN 500 AND 1000 THEN 'Alto ($500-$1000)'
        ELSE 'Premium (> $1000)'
    END
ORDER BY cantidad_productos DESC;

-- Ejercicio 8: ANÁLISIS GEOGRÁFICO
-- =====================================================
-- Analizar distribución geográfica

SELECT 'Análisis geográfico de clientes' as ejercicio;
SELECT '=================================' as separador;

-- 8.1 Clientes por provincia
SELECT provincia, COUNT(*) as cantidad_clientes
FROM clientes
GROUP BY provincia
ORDER BY cantidad_clientes DESC;

-- 8.2 Sucursales por provincia
SELECT provincia, COUNT(*) as cantidad_sucursales
FROM sucursales
GROUP BY provincia
ORDER BY cantidad_sucursales DESC;

-- 8.3 Proveedores por país
SELECT country, COUNT(*) as cantidad_proveedores
FROM proveedores
GROUP BY country
ORDER BY cantidad_proveedores DESC;

-- Ejercicio 9: NORMALIZACIÓN DE DATOS
-- =====================================================
-- Crear tablas normalizadas

SELECT 'Normalización de datos' as ejercicio;
SELECT '======================' as separador;

-- 9.1 Crear tabla de provincias
CREATE TABLE IF NOT EXISTS provincias (
    id_provincia SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL
);

-- Insertar provincias únicas
INSERT INTO provincias (nombre)
SELECT DISTINCT provincia 
FROM clientes 
WHERE provincia IS NOT NULL
ON CONFLICT (nombre) DO NOTHING;

-- 9.2 Crear tabla de tipos de producto
CREATE TABLE IF NOT EXISTS tipos_producto (
    id_tipo SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL
);

-- Insertar tipos de producto únicos
INSERT INTO tipos_producto (nombre)
SELECT DISTINCT tipo 
FROM productos 
WHERE tipo IS NOT NULL
ON CONFLICT (nombre) DO NOTHING;

-- Mostrar resultados de normalización
SELECT 'Provincias normalizadas:' as resultado;
SELECT * FROM provincias ORDER BY nombre;

SELECT 'Tipos de producto normalizados:' as resultado;
SELECT * FROM tipos_producto ORDER BY nombre;

-- Ejercicio 10: CONSULTAS AVANZADAS
-- =====================================================
-- Consultas complejas usando window functions

SELECT 'Consultas avanzadas con window functions' as ejercicio;
SELECT '=========================================' as separador;

-- 10.1 Ranking de productos por proveedor
SELECT 
    p.nombre as proveedor,
    pr.concepto as producto,
    c.precio * c.cantidad as total_comprado,
    RANK() OVER (PARTITION BY p.id_proveedor ORDER BY c.precio * c.cantidad DESC) as ranking
FROM compras c
JOIN productos pr ON c.id_producto = pr.id_producto
JOIN proveedores p ON c.id_proveedor = p.id_proveedor
ORDER BY p.nombre, ranking;

-- 10.2 Análisis detallado de gastos con percentiles
SELECT 
    tg.descripcion,
    COUNT(*) as cantidad_gastos,
    AVG(g.monto) as promedio_gastos,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY g.monto) as mediana_gastos,
    MIN(g.monto) as gasto_minimo,
    MAX(g.monto) as gasto_maximo
FROM gastos g
JOIN tipos_gasto tg ON g.id_tipo_gasto = tg.id_tipo_gasto
GROUP BY tg.id_tipo_gasto, tg.descripcion
ORDER BY promedio_gastos DESC;

-- 10.3 Ventas acumuladas por mes
SELECT 
    EXTRACT(YEAR FROM fecha) as año,
    EXTRACT(MONTH FROM fecha) as mes,
    SUM(precio * cantidad) as ventas_mes,
    SUM(SUM(precio * cantidad)) OVER (
        ORDER BY EXTRACT(YEAR FROM fecha), EXTRACT(MONTH FROM fecha)
        ROWS UNBOUNDED PRECEDING
    ) as ventas_acumuladas
FROM ventas
GROUP BY EXTRACT(YEAR FROM fecha), EXTRACT(MONTH FROM fecha)
ORDER BY año, mes;

SELECT '¡Ejercicios completados exitosamente!' as mensaje_final;
SELECT '=====================================' as separador; 