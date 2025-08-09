-- Usar la base de datos
USE retail;

-- Habilitar particiones dinámicas
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;

-- Cargar datos de clientes
LOAD DATA LOCAL INPATH '/data/Clientes.csv' 
OVERWRITE INTO TABLE clientes;

-- Cargar datos de productos
LOAD DATA LOCAL INPATH '/data/PRODUCTOS.csv' 
OVERWRITE INTO TABLE productos;

-- Cargar datos de sucursales
LOAD DATA LOCAL INPATH '/data/Sucursales.csv' 
OVERWRITE INTO TABLE sucursales;

-- Cargar datos de empleados
LOAD DATA LOCAL INPATH '/data/Empleados.csv' 
OVERWRITE INTO TABLE empleados;

-- Cargar datos de canal de venta
LOAD DATA LOCAL INPATH '/data/CanalDeVenta.csv' 
OVERWRITE INTO TABLE canal_venta;

-- Crear tabla temporal para ventas
CREATE TABLE IF NOT EXISTS temp_ventas (
    id_venta INT,
    fecha DATE,
    fecha_entrega DATE,
    id_canal INT,
    id_cliente INT,
    id_sucursal INT,
    id_empleado INT,
    id_producto INT,
    precio DECIMAL(10,2),
    cantidad INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',';

-- Cargar datos en tabla temporal
LOAD DATA LOCAL INPATH '/data/Venta.csv' 
OVERWRITE INTO TABLE temp_ventas;

-- Insertar datos en la tabla particionada
INSERT INTO TABLE ventas PARTITION(anio, mes)
SELECT 
    id_venta,
    fecha,
    fecha_entrega,
    id_canal,
    id_cliente,
    id_sucursal,
    id_empleado,
    id_producto,
    precio,
    cantidad,
    YEAR(fecha) as anio,
    MONTH(fecha) as mes
FROM temp_ventas;

-- Limpiar tabla temporal
DROP TABLE temp_ventas;

-- Verificar datos cargados
SELECT 'Clientes' as tabla, COUNT(*) as registros FROM clientes
UNION ALL
SELECT 'Productos', COUNT(*) FROM productos
UNION ALL
SELECT 'Sucursales', COUNT(*) FROM sucursales
UNION ALL
SELECT 'Empleados', COUNT(*) FROM empleados
UNION ALL
SELECT 'Canal de Venta', COUNT(*) FROM canal_venta
UNION ALL
SELECT 'Ventas', COUNT(*) FROM ventas
ORDER BY tabla;