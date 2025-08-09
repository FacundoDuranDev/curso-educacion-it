-- Crear base de datos metastore para Hive
CREATE DATABASE metastore;

-- Dar permisos al usuario admin
GRANT ALL PRIVILEGES ON DATABASE metastore TO admin;

-- Conectar a la base de datos metastore
\c metastore;

-- Crear esquema para Hive (esto se hará automáticamente cuando Hive se inicie)
-- Los scripts de inicialización de Hive crearán las tablas necesarias 