#!/bin/bash

echo "🚀 Configuración completa de Hive para el proyecto de Data Engineering"
echo "====================================================================="

# Verificar que Hive esté funcionando
echo "📋 Verificando conexión a Hive..."
if ! sudo docker exec -it hive-server beeline -u jdbc:hive2://localhost:10000 -e "SHOW DATABASES;" > /dev/null 2>&1; then
    echo "❌ Error: Hive no está funcionando aún"
    echo "   Espera unos minutos más para que HiveServer2 termine de iniciar"
    echo "   Luego ejecuta este script nuevamente"
    exit 1
fi
echo "✅ Hive funcionando correctamente"

# Crear y configurar la base de datos
echo "📋 Configurando base de datos retail..."
sudo docker exec -i hive-server beeline -u jdbc:hive2://localhost:10000 << 'EOF'
-- Crear base de datos
CREATE DATABASE IF NOT EXISTS retail;
USE retail;

-- Crear tabla de Clientes
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

-- Crear tabla de Productos
CREATE TABLE IF NOT EXISTS productos (
    id_producto INT,
    concepto STRING,
    tipo STRING,
    precio DECIMAL(10,2)
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- Crear tabla de Ventas
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

-- Crear tabla de Sucursales
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

-- Crear tabla de Empleados
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

-- Crear tabla de Canal de Venta
CREATE TABLE IF NOT EXISTS canal_venta (
    id_canal INT,
    descripcion STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

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

-- Mostrar algunas consultas de ejemplo
SELECT 'Ejemplo 1: Top 5 productos por ventas' as consulta;
SELECT p.concepto, COUNT(*) as total_ventas
FROM ventas v
JOIN productos p ON v.id_producto = p.id_producto
GROUP BY p.concepto
ORDER BY total_ventas DESC
LIMIT 5;

SELECT 'Ejemplo 2: Ventas por provincia' as consulta;
SELECT c.provincia, COUNT(*) as total_ventas
FROM ventas v
JOIN clientes c ON v.id_cliente = c.id
WHERE c.provincia IS NOT NULL
GROUP BY c.provincia
ORDER BY total_ventas DESC;

SELECT 'Ejemplo 3: Ventas por año y mes' as consulta;
SELECT anio, mes, COUNT(*) as total_ventas
FROM ventas
GROUP BY anio, mes
ORDER BY anio DESC, mes DESC
LIMIT 10;

!quit
EOF

echo ""
echo "🎉 ¡Configuración de Hive completada exitosamente!"
echo "=================================================="
echo ""
echo "📚 Para conectarte a Hive:"
echo "   sudo docker exec -it hive-server beeline -u jdbc:hive2://localhost:10000"
echo ""
echo "📝 Comandos útiles:"
echo "   USE retail;"
echo "   SHOW TABLES;"
echo "   SELECT COUNT(*) FROM clientes;"
echo "   SELECT COUNT(*) FROM ventas;"
echo ""
echo "🔍 Para ver las particiones de ventas:"
echo "   SHOW PARTITIONS ventas;" 