-- Script de inicialización del esquema de Hive para PostgreSQL
-- Basado en la documentación oficial de Hive 2.3.0

-- Crear base de datos metastore si no existe
CREATE DATABASE IF NOT EXISTS metastore;

-- Conectar a la base de datos metastore
\c metastore;

-- Crear tabla de versiones
CREATE TABLE IF NOT EXISTS "VERSION" (
    "VER_ID" bigint NOT NULL,
    "SCHEMA_VERSION" varchar(127) NOT NULL,
    "VERSION_COMMENT" varchar(255)
);

-- Crear tabla de bases de datos
CREATE TABLE IF NOT EXISTS "DBS" (
    "DB_ID" bigint NOT NULL,
    "DESC" varchar(4000),
    "DB_LOCATION_URI" varchar(4000) NOT NULL,
    "NAME" varchar(128) UNIQUE NOT NULL,
    "OWNER_NAME" varchar(128),
    "OWNER_TYPE" varchar(10)
);

-- Crear tabla de tablas
CREATE TABLE IF NOT EXISTS "TBLS" (
    "TBL_ID" bigint NOT NULL,
    "CREATE_TIME" integer NOT NULL,
    "DB_ID" bigint,
    "LAST_ACCESS_TIME" integer NOT NULL,
    "OWNER" varchar(767),
    "RETENTION" integer NOT NULL,
    "SD_ID" bigint,
    "TBL_NAME" varchar(128) NOT NULL,
    "TBL_TYPE" varchar(128),
    "VIEW_EXPANDED_TEXT" text,
    "VIEW_ORIGINAL_TEXT" text
);

-- Crear tabla de almacenamiento
CREATE TABLE IF NOT EXISTS "SDS" (
    "SD_ID" bigint NOT NULL,
    "CD_ID" bigint,
    "INPUT_FORMAT" varchar(4000),
    "IS_COMPRESSED" boolean NOT NULL,
    "IS_STOREDASSUBDIRECTORIES" boolean NOT NULL,
    "LOCATION" varchar(4000),
    "NUM_BUCKETS" integer NOT NULL,
    "OUTPUT_FORMAT" varchar(4000),
    "SERDE_ID" bigint
);

-- Crear tabla de columnas
CREATE TABLE IF NOT EXISTS "COLUMNS_V2" (
    "CD_ID" bigint NOT NULL,
    "COMMENT" varchar(256),
    "COLUMN_NAME" varchar(767) NOT NULL,
    "TYPE_NAME" varchar(4000) NOT NULL,
    "INTEGER_IDX" integer NOT NULL
);

-- Crear tabla de serdes
CREATE TABLE IF NOT EXISTS "SERDES" (
    "SERDE_ID" bigint NOT NULL,
    "NAME" varchar(128),
    "SLIB" varchar(4000)
);

-- Crear tabla de parámetros de serde
CREATE TABLE IF NOT EXISTS "SERDE_PARAMS" (
    "SERDE_ID" bigint NOT NULL,
    "PARAM_KEY" varchar(256) NOT NULL,
    "PARAM_VALUE" text
);

-- Crear tabla de particiones
CREATE TABLE IF NOT EXISTS "PARTITIONS" (
    "PART_ID" bigint NOT NULL,
    "CREATE_TIME" integer NOT NULL,
    "LAST_ACCESS_TIME" integer NOT NULL,
    "PART_NAME" varchar(767),
    "SD_ID" bigint,
    "TBL_ID" bigint
);

-- Crear tabla de parámetros de partición
CREATE TABLE IF NOT EXISTS "PARTITION_PARAMS" (
    "PART_ID" bigint NOT NULL,
    "PARAM_KEY" varchar(256) NOT NULL,
    "PARAM_VALUE" text
);

-- Crear tabla de parámetros de tabla
CREATE TABLE IF NOT EXISTS "TABLE_PARAMS" (
    "TBL_ID" bigint NOT NULL,
    "PARAM_KEY" varchar(256) NOT NULL,
    "PARAM_VALUE" text
);

-- Crear tabla de parámetros de base de datos
CREATE TABLE IF NOT EXISTS "DATABASE_PARAMS" (
    "DB_ID" bigint NOT NULL,
    "PARAM_KEY" varchar(180) NOT NULL,
    "PARAM_VALUE" text
);

-- Crear tabla de índices
CREATE TABLE IF NOT EXISTS "IDXS" (
    "INDEX_ID" bigint NOT NULL,
    "CREATE_TIME" integer NOT NULL,
    "DEFERRED_REBUILD" boolean NOT NULL,
    "INDEX_HANDLER_CLASS" varchar(4000),
    "INDEX_NAME" varchar(128) NOT NULL,
    "INDEX_TBL_ID" bigint,
    "LAST_ACCESS_TIME" integer NOT NULL,
    "ORIG_TBL_ID" bigint,
    "SD_ID" bigint
);

-- Crear tabla de parámetros de índice
CREATE TABLE IF NOT EXISTS "INDEX_PARAMS" (
    "INDEX_ID" bigint NOT NULL,
    "PARAM_KEY" varchar(256) NOT NULL,
    "PARAM_VALUE" text
);

-- Crear tabla de roles
CREATE TABLE IF NOT EXISTS "ROLES" (
    "ROLE_ID" bigint NOT NULL,
    "CREATE_TIME" integer NOT NULL,
    "OWNER_NAME" varchar(128),
    "ROLE_NAME" varchar(128) NOT NULL
);

-- Crear tabla de usuarios de roles
CREATE TABLE IF NOT EXISTS "ROLE_MAP" (
    "ROLE_GRANT_ID" bigint NOT NULL,
    "ADD_TIME" integer NOT NULL,
    "GRANT_OPTION" integer NOT NULL,
    "GRANTOR" varchar(128),
    "GRANTOR_TYPE" varchar(128),
    "PRINCIPAL_NAME" varchar(128),
    "PRINCIPAL_TYPE" varchar(128),
    "ROLE_ID" bigint
);

-- Crear tabla de privilegios
CREATE TABLE IF NOT EXISTS "PRIVS" (
    "PRIV_ID" bigint NOT NULL,
    "CREATE_TIME" integer NOT NULL,
    "GRANT_OPTION" integer NOT NULL,
    "GRANTOR" varchar(128),
    "GRANTOR_TYPE" varchar(128),
    "PRINCIPAL_NAME" varchar(128),
    "PRINCIPAL_TYPE" varchar(128),
    "PRIVILEGE" varchar(128),
    "TBL_ID" bigint
);

-- Crear tabla de privilegios de columna
CREATE TABLE IF NOT EXISTS "COLUMN_PRIVS" (
    "COLUMN_GRANT_ID" bigint NOT NULL,
    "COLUMN_NAME" varchar(128),
    "CREATE_TIME" integer NOT NULL,
    "GRANT_OPTION" integer NOT NULL,
    "GRANTOR" varchar(128),
    "GRANTOR_TYPE" varchar(128),
    "PRINCIPAL_NAME" varchar(128),
    "PRINCIPAL_TYPE" varchar(128),
    "PRIVILEGE" varchar(128),
    "TBL_ID" bigint
);

-- Crear tabla de funciones
CREATE TABLE IF NOT EXISTS "FUNCS" (
    "FUNC_ID" bigint NOT NULL,
    "CLASS_NAME" varchar(4000),
    "CREATE_TIME" integer NOT NULL,
    "DB_ID" bigint,
    "FUNC_NAME" varchar(128),
    "FUNC_TYPE" integer NOT NULL,
    "OWNER_NAME" varchar(128),
    "OWNER_TYPE" varchar(10)
);

-- Crear tabla de parámetros de función
CREATE TABLE IF NOT EXISTS "FUNC_RU" (
    "FUNC_ID" bigint NOT NULL,
    "RESOURCE_TYPE" integer NOT NULL,
    "RESOURCE_URI" varchar(4000),
    "INTEGER_IDX" integer NOT NULL
);

-- Crear secuencias para los IDs
CREATE SEQUENCE IF NOT EXISTS "DBS_SEQ" START WITH 1;
CREATE SEQUENCE IF NOT EXISTS "TBLS_SEQ" START WITH 1;
CREATE SEQUENCE IF NOT EXISTS "SDS_SEQ" START WITH 1;
CREATE SEQUENCE IF NOT EXISTS "COLUMNS_V2_SEQ" START WITH 1;
CREATE SEQUENCE IF NOT EXISTS "SERDES_SEQ" START WITH 1;
CREATE SEQUENCE IF NOT EXISTS "PARTITIONS_SEQ" START WITH 1;
CREATE SEQUENCE IF NOT EXISTS "IDXS_SEQ" START WITH 1;
CREATE SEQUENCE IF NOT EXISTS "ROLES_SEQ" START WITH 1;
CREATE SEQUENCE IF NOT EXISTS "PRIVS_SEQ" START WITH 1;
CREATE SEQUENCE IF NOT EXISTS "FUNCS_SEQ" START WITH 1;

-- Insertar versión inicial
INSERT INTO "VERSION" ("VER_ID", "SCHEMA_VERSION", "VERSION_COMMENT") 
VALUES (1, '2.3.0', 'Hive release version 2.3.0') 
ON CONFLICT ("VER_ID") DO NOTHING;

-- Dar permisos al usuario admin
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin;
GRANT ALL PRIVILEGES ON SCHEMA public TO admin;

-- Verificar que las tablas se crearon
\dt 