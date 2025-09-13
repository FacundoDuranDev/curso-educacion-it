-- Script para cargar datos en las tablas de Hive desde HDFS

USE educacionit;

-- Cargar datos en las tablas (respetando delimitadores)

-- 1. Canal de venta (delimitador: ,)
LOAD DATA INPATH '/user/data/etapa1/CanalDeVenta.csv' 
OVERWRITE INTO TABLE canal_venta;

-- 2. Productos (delimitador: ,)
LOAD DATA INPATH '/user/data/etapa1/PRODUCTOS.csv' 
OVERWRITE INTO TABLE productos;

-- 3. Proveedores (delimitador: ,)
LOAD DATA INPATH '/user/data/etapa1/Proveedores.csv' 
OVERWRITE INTO TABLE proveedores;

-- 4. Sucursales (delimitador: ;)
LOAD DATA INPATH '/user/data/etapa1/Sucursales.csv' 
OVERWRITE INTO TABLE sucursales;

-- 5. Empleados (usar archivo limpio, delimitador: ,)
LOAD DATA INPATH '/user/data/etapa1/Empleados_clean.csv' 
OVERWRITE INTO TABLE empleados;

-- 6. Clientes (delimitador: ;)
LOAD DATA INPATH '/user/data/etapa1/Clientes.csv' 
OVERWRITE INTO TABLE clientes;

-- 7. Tipos de gasto (delimitador: ,)
LOAD DATA INPATH '/user/data/etapa1/TiposDeGasto.csv' 
OVERWRITE INTO TABLE tipos_gasto;

-- 8. Gastos (delimitador: ,)
LOAD DATA INPATH '/user/data/etapa1/Gasto.csv' 
OVERWRITE INTO TABLE gastos;

-- 9. Compras (delimitador: ,)
LOAD DATA INPATH '/user/data/etapa1/Compra.csv' 
OVERWRITE INTO TABLE compras;

-- 10. Ventas (delimitador: ,)
LOAD DATA INPATH '/user/data/etapa1/Venta.csv' 
OVERWRITE INTO TABLE ventas;

-- Verificar datos cargados
SELECT 'canal_venta' as tabla, COUNT(*) as registros FROM canal_venta
UNION ALL
SELECT 'productos', COUNT(*) FROM productos
UNION ALL
SELECT 'proveedores', COUNT(*) FROM proveedores  
UNION ALL
SELECT 'sucursales', COUNT(*) FROM sucursales
UNION ALL
SELECT 'empleados', COUNT(*) FROM empleados
UNION ALL
SELECT 'clientes', COUNT(*) FROM clientes
UNION ALL
SELECT 'tipos_gasto', COUNT(*) FROM tipos_gasto
UNION ALL
SELECT 'gastos', COUNT(*) FROM gastos
UNION ALL
SELECT 'compras', COUNT(*) FROM compras
UNION ALL
SELECT 'ventas', COUNT(*) FROM ventas
ORDER BY tabla;

