-- Script para cargar datos en PostgreSQL usando \copy
-- Base de datos: educacionit

-- 1. Cargar datos de Clientes
\copy clientes FROM 'data/etapa1/Clientes.csv' WITH (FORMAT csv, DELIMITER ';', HEADER true, ENCODING 'UTF8');

-- 2. Cargar datos de Sucursales
\copy sucursales FROM 'data/etapa1/Sucursales.csv' WITH (FORMAT csv, DELIMITER ';', HEADER true, ENCODING 'UTF8');

-- 3. Cargar datos de Tipos de Gasto
\copy tipos_gasto FROM 'data/etapa1/TiposDeGasto.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');

-- 4. Cargar datos de Gastos
\copy gastos FROM 'data/etapa1/Gasto.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');

-- 5. Cargar datos de Compras
\copy compras FROM 'data/etapa1/Compra.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');

-- 6. Cargar datos de Productos
\copy productos FROM 'data/etapa1/PRODUCTOS.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');

-- 7. Cargar datos de Proveedores
\copy proveedores FROM 'data/etapa1/Proveedores.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');

-- 8. Cargar datos de Empleados (usando tabla temporal para evitar duplicados)
CREATE TEMP TABLE temp_empleados (
    id_empleado INTEGER,
    apellido VARCHAR(100),
    nombre VARCHAR(100),
    sucursal VARCHAR(100),
    sector VARCHAR(100),
    cargo VARCHAR(100),
    salario DECIMAL(10,2)
);

\copy temp_empleados FROM 'data/etapa1/Empleados.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');

INSERT INTO empleados (id_empleado, apellido, nombre, sucursal, sector, cargo, salario)
SELECT DISTINCT id_empleado, apellido, nombre, sucursal, sector, cargo, salario
FROM temp_empleados
ON CONFLICT (id_empleado) DO NOTHING;

-- 9. Cargar datos de Canal de Venta
\copy canal_venta FROM 'data/etapa1/CanalDeVenta.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');

-- 10. Cargar datos de Ventas
\copy ventas FROM 'data/etapa1/Venta.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');
