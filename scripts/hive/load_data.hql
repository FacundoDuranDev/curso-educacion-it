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

-- Crear tabla temporal para ventas
CREATE TABLE IF NOT EXISTS temp_ventas (
    id_venta INT,
    id_cliente INT,
    id_producto INT,
    cantidad INT,
    monto_total DECIMAL(10,2),
    fecha_venta DATE
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
    id_cliente,
    id_producto,
    cantidad,
    monto_total,
    fecha_venta,
    YEAR(fecha_venta) as anio,
    MONTH(fecha_venta) as mes
FROM temp_ventas;

-- Limpiar tabla temporal
DROP TABLE temp_ventas;