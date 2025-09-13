-- Script para crear tablas en Hive con la misma estructura que PostgreSQL

-- Crear base de datos
CREATE DATABASE IF NOT EXISTS educacionit;
USE educacionit;

-- 1. Tabla canal_venta
CREATE TABLE IF NOT EXISTS canal_venta (
    codigo INT,
    descripcion STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/educacionit.db/canal_venta';

-- 2. Tabla productos
CREATE TABLE IF NOT EXISTS productos (
    id_producto INT,
    concepto STRING,
    tipo STRING,
    precio DECIMAL(10,2)
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/educacionit.db/productos';

-- 3. Tabla proveedores
CREATE TABLE IF NOT EXISTS proveedores (
    id_proveedor INT,
    nombre STRING,
    address STRING,
    city STRING,
    state STRING,
    country STRING,
    departamen STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/educacionit.db/proveedores';

-- 4. Tabla sucursales (delimitador ;)
CREATE TABLE IF NOT EXISTS sucursales (
    id INT,
    sucursal STRING,
    direccion STRING,
    localidad STRING,
    provincia STRING,
    latitud STRING,
    longitud STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ';'
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/educacionit.db/sucursales';

-- 5. Tabla empleados (usar archivo limpio sin duplicados)
CREATE TABLE IF NOT EXISTS empleados (
    id_empleado INT,
    apellido STRING,
    nombre STRING,
    sucursal STRING,
    sector STRING,
    cargo STRING,
    salario DECIMAL(10,2)
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/educacionit.db/empleados';

-- 6. Tabla clientes (delimitador ;)
CREATE TABLE IF NOT EXISTS clientes (
    id INT,
    provincia STRING,
    nombre_y_apellido STRING,
    domicilio STRING,
    telefono STRING,
    edad INT,
    localidad STRING,
    x STRING,
    y STRING,
    fecha_alta STRING,
    usuario_alta STRING,
    fecha_ultima_modificacion STRING,
    usuario_ultima_modificacion STRING,
    marca_baja INT,
    col10 STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ';'
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/educacionit.db/clientes';

-- 7. Tabla tipos_gasto
CREATE TABLE IF NOT EXISTS tipos_gasto (
    id_tipo_gasto INT,
    descripcion STRING,
    monto_aproximado DECIMAL(10,2)
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/educacionit.db/tipos_gasto';

-- 8. Tabla gastos
CREATE TABLE IF NOT EXISTS gastos (
    id_gasto INT,
    id_sucursal INT,
    id_tipo_gasto INT,
    fecha STRING,
    monto DECIMAL(10,2)
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/educacionit.db/gastos';

-- 9. Tabla compras
CREATE TABLE IF NOT EXISTS compras (
    id_compra INT,
    fecha STRING,
    id_producto INT,
    cantidad INT,
    precio DECIMAL(10,2),
    id_proveedor INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/educacionit.db/compras';

-- 10. Tabla ventas
CREATE TABLE IF NOT EXISTS ventas (
    id_venta INT,
    fecha STRING,
    fecha_entrega STRING,
    id_canal INT,
    id_cliente INT,
    id_sucursal INT,
    id_empleado INT,
    id_producto INT,
    precio DECIMAL(10,2),
    cantidad INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/educacionit.db/ventas';

-- Mostrar tablas creadas
SHOW TABLES;

