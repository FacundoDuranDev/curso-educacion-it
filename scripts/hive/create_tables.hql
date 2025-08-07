-- Crear base de datos
CREATE DATABASE IF NOT EXISTS retail;
USE retail;

-- Tabla de Clientes
CREATE TABLE IF NOT EXISTS clientes (
    id_cliente INT,
    nombre STRING,
    email STRING,
    telefono STRING,
    direccion STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- Tabla de Productos
CREATE TABLE IF NOT EXISTS productos (
    id_producto INT,
    nombre STRING,
    precio DECIMAL(10,2),
    categoria STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- Tabla de Ventas
CREATE TABLE IF NOT EXISTS ventas (
    id_venta INT,
    id_cliente INT,
    id_producto INT,
    cantidad INT,
    monto_total DECIMAL(10,2),
    fecha_venta DATE
)
PARTITIONED BY (anio INT, mes INT)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',';