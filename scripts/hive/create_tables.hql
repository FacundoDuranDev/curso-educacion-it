-- Crear base de datos
CREATE DATABASE IF NOT EXISTS retail;
USE retail;

-- Tabla de Clientes (usando ; como separador)
CREATE TABLE IF NOT EXISTS clientes (
    id INT,
    provincia STRING,
    nombre_y_apellido STRING,
    domicilio STRING,
    telefono STRING,
    edad INT,
    localidad STRING,
    x DOUBLE,
    y DOUBLE,
    fecha_alta DATE,
    usuario_alta STRING,
    fecha_ultima_modificacion DATE,
    usuario_ultima_modificacion STRING,
    marca_baja STRING,
    col10 STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ';'
STORED AS TEXTFILE;

-- Tabla de Productos (usando , como separador)
CREATE TABLE IF NOT EXISTS productos (
    id_producto INT,
    concepto STRING,
    tipo STRING,
    precio DECIMAL(10,2)
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- Tabla de Ventas (usando , como separador)
CREATE TABLE IF NOT EXISTS ventas (
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
PARTITIONED BY (anio INT, mes INT)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',';

-- Tabla de Sucursales
CREATE TABLE IF NOT EXISTS sucursales (
    id_sucursal INT,
    nombre STRING,
    direccion STRING,
    localidad STRING,
    provincia STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- Tabla de Empleados
CREATE TABLE IF NOT EXISTS empleados (
    id_empleado INT,
    nombre STRING,
    apellido STRING,
    email STRING,
    telefono STRING,
    id_sucursal INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- Tabla de Canal de Venta
CREATE TABLE IF NOT EXISTS canal_venta (
    id_canal INT,
    descripcion STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;