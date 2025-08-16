# 🗄️ Guía de Creación de Bases de Datos en PostgreSQL

## 📋 **Resumen**
Esta guía te enseñará cómo crear, gestionar y configurar bases de datos en PostgreSQL, usando como ejemplos prácticos las bases de datos `metastore` y `educacionit` del proyecto.

---

## 🎯 **Objetivo**
- ✅ Entender qué son las bases de datos en PostgreSQL
- ✅ Aprender a crear bases de datos desde cero
- ✅ Configurar usuarios y permisos
- ✅ Gestionar múltiples bases de datos
- ✅ Aplicar conocimientos con ejemplos reales

---

## 🔍 **¿Qué es una Base de Datos en PostgreSQL?**

### **Definición:**
Una **base de datos** en PostgreSQL es un contenedor lógico que agrupa:
- **Tablas** relacionadas
- **Esquemas** organizacionales
- **Funciones** y procedimientos
- **Vistas** y índices
- **Permisos** y usuarios

### **Analogía:**
Imagina que PostgreSQL es como un **edificio de oficinas**:
- **Edificio** = Instancia de PostgreSQL
- **Pisos** = Bases de datos
- **Oficinas** = Esquemas
- **Muebles** = Tablas
- **Empleados** = Usuarios

---

## 🏗️ **Tipos de Bases de Datos en Nuestro Proyecto**

### **1. Base de Datos `metastore`**
- **Propósito:** Almacenar metadatos de Apache Hive
- **Contenido:** Tablas del sistema de Hive (DBS, TBLS, COLUMNS_V2, etc.)
- **Usuario:** `postgres` (superusuario)
- **Contraseña:** `jupyter`

### **2. Base de Datos `educacionit`**
- **Propósito:** Datos del curso de Data Engineering
- **Contenido:** Tablas de negocio (clientes, productos, ventas, etc.)
- **Usuario:** `admin`
- **Contraseña:** `admin123`

---

## 🔧 **Paso 1: Conectarse a PostgreSQL**

### **1.1 Verificar que PostgreSQL esté corriendo**
```bash
# Verificar contenedores activos
docker ps | grep metastore

# Si no está corriendo, levantarlo
docker-compose up -d metastore
```

### **1.2 Conectarse como Superusuario**
```bash
# Conectar como postgres (superusuario)
docker exec -it educacionit-metastore-1 psql -U postgres
```

**Indicador de éxito:** El prompt cambiará a `postgres=#`

---

## 🗄️ **Paso 2: Crear Base de Datos**

### **2.1 Sintaxis Básica**
```sql
CREATE DATABASE nombre_base_datos;
```

### **2.2 Crear Base de Datos `metastore`**
```sql
CREATE DATABASE metastore;
```

**Resultado esperado:**
```
CREATE DATABASE
```

### **2.3 Crear Base de Datos `educacionit`**
```sql
CREATE DATABASE educacionit;
```

**Resultado esperado:**
```
CREATE DATABASE
```

### **2.4 Crear Base de Datos con Opciones Avanzadas**
```sql
CREATE DATABASE mi_base_datos
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.utf8'
    LC_CTYPE = 'en_US.utf8'
    TEMPLATE = template0;
```

---

## 👤 **Paso 3: Crear Usuarios**

### **3.1 ¿Por qué Crear Usuarios?**
- **Seguridad:** Cada aplicación tiene su propio usuario
- **Permisos:** Control granular sobre bases de datos
- **Auditoría:** Rastrear quién hace qué
- **Mantenimiento:** Fácil gestión de accesos

### **3.2 Crear Usuario `admin`**
```sql
CREATE USER admin WITH PASSWORD 'admin123';
```

**Resultado esperado:**
```
CREATE ROLE
```

### **3.3 Crear Usuario Personalizado**
```sql
CREATE USER mi_usuario WITH PASSWORD 'mi_contraseña';
```

### **3.4 Crear Usuario con Opciones**
```sql
CREATE USER desarrollador 
    WITH 
    PASSWORD = 'dev123'
    CREATEDB
    VALID UNTIL '2025-12-31';
```

---

## 🔐 **Paso 4: Gestionar Permisos**

### **4.1 Tipos de Permisos**
- **CONNECT:** Conectarse a la base de datos
- **CREATE:** Crear objetos (tablas, esquemas)
- **USAGE:** Usar objetos existentes
- **SELECT, INSERT, UPDATE, DELETE:** Operaciones en datos
- **ALL PRIVILEGES:** Todos los permisos

### **4.2 Otorgar Permisos Completos**
```sql
-- Dar todos los permisos sobre educacionit
GRANT ALL PRIVILEGES ON DATABASE educacionit TO admin;

-- Dar permisos sobre todas las tablas futuras
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin;

-- Dar permisos sobre secuencias
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin;
```

### **4.3 Otorgar Permisos Específicos**
```sql
-- Solo lectura
GRANT SELECT ON ALL TABLES IN SCHEMA public TO usuario_lectura;

-- Solo inserción
GRANT INSERT ON TABLE clientes TO usuario_insercion;

-- Solo actualización
GRANT UPDATE ON TABLE productos TO usuario_actualizacion;
```

---

## 📊 **Paso 5: Verificar Creación**

### **5.1 Listar Todas las Bases de Datos**
```sql
\l
```

**Resultado esperado:**
```
                                  List of databases
    Name     |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-------------+----------+----------+------------+------------+-----------------------
 educacionit | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/postgres         +
             |          |          |            |            | postgres=CTc/postgres+
             |          |            |            |            | admin=CTc/postgres
 metastore   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/postgres         +
             |          |          |            |            | postgres=CTc/postgres+
             |          |            |            |            | jupyter=CTc/postgres
 postgres    | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
             |          |            |            |            | postgres=CTc/postgres
 template1   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
             |          |            |            |            | postgres=CTc/postgres
```

### **5.2 Listar Usuarios**
```sql
\du
```

**Resultado esperado:**
```
                                   List of roles
 Role name |                         Attributes                         | Member of 
-----------+------------------------------------------------------------+-----------
 admin     |                                                            | {}
 postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
```

### **5.3 Ver Permisos de una Base de Datos**
```sql
\l+ educacionit
```

---

## 🔄 **Paso 6: Conectarse a Diferentes Bases de Datos**

### **6.1 Cambiar de Base de Datos**
```sql
-- Desde postgres, cambiar a educacionit
\c educacionit

-- O usar comando completo
\connect educacionit
```

### **6.2 Conectarse Directamente desde Terminal**
```bash
# Conectar a metastore
docker exec -it educacionit-metastore-1 psql -U postgres -d metastore

# Conectar a educacionit
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit

# Conectar a postgres (base por defecto)
docker exec -it educacionit-metastore-1 psql -U postgres -d postgres
```

---

## 🏗️ **Paso 7: Crear Esquemas**

### **7.1 ¿Qué es un Esquema?**
Un **esquema** es un contenedor dentro de una base de datos que agrupa:
- Tablas relacionadas
- Funciones
- Vistas
- Índices

### **7.2 Esquema por Defecto**
```sql
-- PostgreSQL crea automáticamente el esquema 'public'
-- Todas las tablas van aquí por defecto
```

### **7.3 Crear Esquema Personalizado**
```sql
-- Crear esquema para ventas
CREATE SCHEMA ventas;

-- Crear esquema para reportes
CREATE SCHEMA reportes;

-- Crear esquema con propietario específico
CREATE SCHEMA auditoria AUTHORIZATION admin;
```

### **7.4 Usar Esquemas**
```sql
-- Crear tabla en esquema específico
CREATE TABLE ventas.clientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100)
);

-- Crear tabla en esquema por defecto
CREATE TABLE public.productos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100)
);
```

---

## 📋 **Paso 8: Ejemplos Prácticos Completos**

### **8.1 Crear Base de Datos para E-commerce**
```sql
-- 1. Crear base de datos
CREATE DATABASE ecommerce;

-- 2. Crear usuario
CREATE USER ecommerce_user WITH PASSWORD 'ecom123';

-- 3. Otorgar permisos
GRANT ALL PRIVILEGES ON DATABASE ecommerce TO ecommerce_user;

-- 4. Conectarse a la nueva base
\c ecommerce

-- 5. Crear esquemas
CREATE SCHEMA ventas;
CREATE SCHEMA inventario;
CREATE SCHEMA usuarios;

-- 6. Crear tablas en esquemas específicos
CREATE TABLE ventas.pedidos (
    id SERIAL PRIMARY KEY,
    fecha_pedido TIMESTAMP DEFAULT NOW(),
    total DECIMAL(10,2)
);

CREATE TABLE inventario.productos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    precio DECIMAL(10,2),
    stock INTEGER
);
```

### **8.2 Crear Base de Datos para Blog**
```sql
-- 1. Crear base de datos
CREATE DATABASE blog;

-- 2. Crear usuario
CREATE USER blog_user WITH PASSWORD 'blog123';

-- 3. Otorgar permisos
GRANT ALL PRIVILEGES ON DATABASE blog TO blog_user;

-- 4. Conectarse
\c blog

-- 5. Crear tablas
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE,
    email VARCHAR(100) UNIQUE,
    fecha_registro TIMESTAMP DEFAULT NOW()
);

CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(200),
    contenido TEXT,
    autor_id INTEGER REFERENCES usuarios(id),
    fecha_publicacion TIMESTAMP DEFAULT NOW()
);
```

---

## 🚨 **Problemas Comunes y Soluciones**

### **Error: "database already exists"**
```sql
-- Solución: Usar IF NOT EXISTS
CREATE DATABASE IF NOT EXISTS mi_base_datos;
```

### **Error: "permission denied"**
```sql
-- Solución: Conectarse como postgres
\c postgres
-- Luego crear la base de datos
```

### **Error: "role does not exist"**
```sql
-- Solución: Crear el usuario primero
CREATE USER mi_usuario WITH PASSWORD 'mi_contraseña';
-- Luego otorgar permisos
```

### **Error: "cannot drop database"**
```sql
-- Solución: Terminar conexiones activas
SELECT pg_terminate_backend(pid) 
FROM pg_stat_activity 
WHERE datname = 'nombre_base_datos';

-- Luego eliminar
DROP DATABASE nombre_base_datos;
```

---

## 🧹 **Paso 9: Mantenimiento y Limpieza**

### **9.1 Eliminar Base de Datos**
```sql
-- Eliminar base de datos (¡CUIDADO!)
DROP DATABASE nombre_base_datos;

-- Eliminar con verificación
DROP DATABASE IF EXISTS nombre_base_datos;
```

### **9.2 Eliminar Usuario**
```sql
-- Eliminar usuario
DROP USER nombre_usuario;

-- Eliminar con verificación
DROP USER IF EXISTS nombre_usuario;
```

### **9.3 Revocar Permisos**
```sql
-- Revocar todos los permisos
REVOKE ALL PRIVILEGES ON DATABASE educacionit FROM admin;

-- Revocar permisos específicos
REVOKE INSERT, UPDATE ON TABLE clientes FROM admin;
```

---

## 📚 **Comandos Útiles de Referencia**

### **Comandos de Base de Datos:**
```sql
\l          -- Listar todas las bases de datos
\l+         -- Listar con detalles
\c nombre   -- Cambiar de base de datos
\connect    -- Conectar a base de datos
```

### **Comandos de Usuario:**
```sql
\du         -- Listar usuarios
\du+        -- Listar usuarios con detalles
\dg         -- Listar grupos
```

### **Comandos de Esquemas:**
```sql
\dn         -- Listar esquemas
\dn+        -- Listar esquemas con detalles
```

### **Comandos de Tablas:**
```sql
\dt         -- Listar tablas del esquema actual
\dt+        -- Listar tablas con detalles
\dt esquema.* -- Listar tablas de un esquema específico
```

---

## 🎯 **Checklist de Verificación**

### **✅ Creación de Base de Datos:**
- [ ] Base de datos creada correctamente
- [ ] Nombre sin espacios ni caracteres especiales
- [ ] Encoding UTF8 configurado
- [ ] Propietario asignado

### **✅ Creación de Usuario:**
- [ ] Usuario creado con contraseña segura
- [ ] Permisos otorgados correctamente
- [ ] Usuario puede conectarse
- [ ] Usuario tiene permisos necesarios

### **✅ Configuración de Permisos:**
- [ ] Permisos de conexión otorgados
- [ ] Permisos de creación otorgados
- [ ] Permisos de uso otorgados
- [ ] Permisos específicos configurados

### **✅ Verificación:**
- [ ] Base de datos aparece en `\l`
- [ ] Usuario aparece en `\du`
- [ ] Permisos funcionan correctamente
- [ ] Conexión exitosa desde aplicación

---

## 🎉 **¡Listo!**

Ahora sabes cómo:
- ✅ **Crear bases de datos** desde cero
- ✅ **Gestionar usuarios** y permisos
- ✅ **Organizar datos** en esquemas
- ✅ **Aplicar conocimientos** con ejemplos reales

**¡Puedes crear cualquier base de datos que necesites para tus proyectos!**

---

## 📞 **Soporte Adicional**

### **Guías relacionadas:**
- 🗄️ **`GUIA_INSTALACION_BASE_DATOS.md`** - Instalación completa de PostgreSQL
- 🔌 **`GUIA_DBEAVER_POSTGRESQL_WINDOWS.md`** - Conexión con DBeaver
- 📊 **`GUIA_SQL.md`** - Sintaxis básica de SQL

### **Recursos útiles:**
- [Documentación oficial de PostgreSQL](https://www.postgresql.org/docs/)
- [Comandos psql](https://www.postgresql.org/docs/current/app-psql.html)
- [Gestión de usuarios y permisos](https://www.postgresql.org/docs/current/user-manag.html)
