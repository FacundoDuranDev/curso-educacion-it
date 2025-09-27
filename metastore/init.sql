-- Crear la base de datos para Hive Metastore
CREATE DATABASE IF NOT EXISTS metastore_db;

-- Crear usuario para Hive
CREATE USER IF NOT EXISTS 'hive'@'%' IDENTIFIED BY 'hive123';

-- Otorgar permisos
GRANT ALL PRIVILEGES ON metastore_db.* TO 'hive'@'%';
FLUSH PRIVILEGES;

-- Usar la base de datos
USE metastore_db;

-- Script básico de inicialización para Hive Metastore
-- Las tablas se crearán automáticamente cuando Hive se conecte por primera vez



