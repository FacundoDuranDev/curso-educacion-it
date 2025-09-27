# 🗄️ CREACIÓN DE BASES DE DATOS EN POSTGRESQL

## 📋 **RESUMEN**
Esta guía te enseñará cómo crear, gestionar y configurar bases de datos en PostgreSQL, usando como ejemplos prácticos las bases de datos `metastore` y `educacionit` del proyecto.

---

## 🎯 **OBJETIVO**
- ✅ Entender qué son las bases de datos en PostgreSQL
- ✅ Aprender a crear bases de datos desde cero
- ✅ Configurar usuarios y permisos
- ✅ Gestionar múltiples bases de datos
- ✅ Aplicar conocimientos con ejemplos reales

---

## 🔍 **¿QUÉ ES UNA BASE DE DATOS EN POSTGRESQL?**

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

## 🏗️ **TIPOS DE BASES DE DATOS EN NUESTRO PROYECTO**

### **1. Base de Datos `metastore`**
- **Propósito:** Almacenar metadatos de Apache Hive
- **Contenido:** Tablas del sistema de Hive (DBS, TBLS, COLUMNS_V2, etc.)
- **Usuario:** `postgres` (superusuario)
- **Contraseña:** `jupyter`
- **Nota:** Esta base se crea automáticamente al levantar el servicio

### **2. Base de Datos `educacionit`**
- **Propósito:** Datos del curso de Data Engineering
- **Contenido:** Tablas de negocio (clientes, productos, ventas, etc.)
- **Usuario:** `admin`
- **Contraseña:** `admin123`
- **Nota:** Esta base se crea manualmente con scripts

---

## 🔧 **COMANDOS ESENCIALES PARA CREAR BASES DE DATOS**

### **Conectar a PostgreSQL:**
```bash
# Desde el contenedor
docker-compose exec metastore psql -U postgres

# Desde el host (si tienes psql instalado)
psql -h localhost -p 5432 -U postgres
```

### **Comandos SQL Básicos:**
```sql
-- Ver todas las bases de datos
\l

-- Crear nueva base de datos
CREATE DATABASE nombre_base;

-- Conectar a una base específica
\c nombre_base

-- Ver tablas en la base actual
\dt

-- Salir de psql
\q
```

---

## 🏗️ **CREAR BASE DE DATOS PASO A PASO**

### **Paso 1: Conectar como Superusuario**
```bash
docker-compose exec metastore psql -U postgres
```

### **Paso 2: Crear la Base de Datos**
```sql
-- Crear base de datos educacionit
CREATE DATABASE educacionit
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.utf8'
    LC_CTYPE = 'en_US.utf8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

-- Verificar que se creó
\l
```

### **Paso 3: Crear Usuario Específico**
```sql
-- Crear usuario admin
CREATE USER admin WITH PASSWORD 'admin123';

-- Dar permisos completos sobre la base educacionit
GRANT ALL PRIVILEGES ON DATABASE educacionit TO admin;

-- Conectar a la base educacionit
\c educacionit

-- Dar permisos sobre el esquema público
GRANT ALL ON SCHEMA public TO admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin;
```

### **Paso 4: Verificar Configuración**
```sql
-- Ver usuarios
\du

-- Ver permisos
\dp

-- Salir
\q
```

---

## 📊 **GESTIÓN DE MÚLTIPLES BASES DE DATOS**

### **Estructura Recomendada:**
```
PostgreSQL Instance
├── postgres (base por defecto)
├── metastore (metadatos de Hive)
├── educacionit (datos del curso)
├── analytics (análisis avanzados)
└── staging (datos de prueba)
```

### **Comandos de Gestión:**
```sql
-- Listar todas las bases
\l

-- Conectar a base específica
\c educacionit

-- Ver información de la base actual
SELECT current_database();

-- Ver tamaño de la base
SELECT pg_size_pretty(pg_database_size('educacionit'));

-- Ver estadísticas de uso
SELECT 
    datname as "Base de Datos",
    numbackends as "Conexiones Activas",
    xact_commit as "Transacciones Commit",
    xact_rollback as "Transacciones Rollback"
FROM pg_stat_database 
WHERE datname = 'educacionit';
```

---

## 👥 **GESTIÓN DE USUARIOS Y PERMISOS**

### **Tipos de Usuarios:**

#### **1. Superusuario (postgres):**
- ✅ Acceso completo al sistema
- ✅ Puede crear/eliminar bases de datos
- ✅ Puede crear/eliminar usuarios
- ✅ Acceso a todas las funciones administrativas

#### **2. Usuario Administrador (admin):**
- ✅ Acceso completo a base específica
- ✅ Puede crear/eliminar tablas
- ✅ Puede gestionar datos
- ❌ No puede crear bases de datos
- ❌ No puede crear usuarios

#### **3. Usuario de Solo Lectura (readonly):**
- ✅ Puede consultar datos
- ❌ No puede modificar datos
- ❌ No puede crear objetos

### **Comandos de Usuarios:**
```sql
-- Crear usuario
CREATE USER nombre_usuario WITH PASSWORD 'contraseña';

-- Crear usuario con privilegios específicos
CREATE USER admin WITH PASSWORD 'admin123' CREATEDB CREATEROLE;

-- Modificar usuario
ALTER USER nombre_usuario WITH PASSWORD 'nueva_contraseña';

-- Eliminar usuario
DROP USER nombre_usuario;

-- Ver todos los usuarios
\du
```

---

## 🔐 **GESTIÓN DE PERMISOS**

### **Niveles de Permisos:**

#### **Nivel de Base de Datos:**
```sql
-- Dar permisos sobre base de datos
GRANT CONNECT ON DATABASE educacionit TO admin;
GRANT TEMPORARY ON DATABASE educacionit TO admin;

-- Quitar permisos
REVOKE CONNECT ON DATABASE educacionit FROM usuario;
```

#### **Nivel de Esquema:**
```sql
-- Dar permisos sobre esquema
GRANT USAGE ON SCHEMA public TO admin;
GRANT CREATE ON SCHEMA public TO admin;

-- Dar todos los permisos
GRANT ALL ON SCHEMA public TO admin;
```

#### **Nivel de Tabla:**
```sql
-- Dar permisos sobre tabla específica
GRANT SELECT ON TABLE clientes TO readonly_user;
GRANT INSERT, UPDATE ON TABLE clientes TO admin;

-- Dar todos los permisos sobre tabla
GRANT ALL PRIVILEGES ON TABLE clientes TO admin;
```

#### **Nivel de Columna:**
```sql
-- Dar permisos sobre columnas específicas
GRANT SELECT (nombre, email) ON TABLE clientes TO readonly_user;
```

---

## 📋 **PATRONES DE CREACIÓN COMUNES**

### **Patrón 1: Base de Datos para Desarrollo**
```sql
-- Crear base para desarrollo
CREATE DATABASE proyecto_dev
    WITH OWNER = postgres
    ENCODING = 'UTF8';

-- Crear usuario desarrollador
CREATE USER dev_user WITH PASSWORD 'dev123';

-- Dar permisos
GRANT CONNECT ON DATABASE proyecto_dev TO dev_user;
\c proyecto_dev
GRANT ALL ON SCHEMA public TO dev_user;
```

### **Patrón 2: Base de Datos para Producción**
```sql
-- Crear base para producción
CREATE DATABASE proyecto_prod
    WITH OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = 100;

-- Crear usuario de aplicación
CREATE USER app_user WITH PASSWORD 'app_secure_password';

-- Crear usuario de solo lectura para reportes
CREATE USER report_user WITH PASSWORD 'report_password';

-- Configurar permisos
GRANT CONNECT ON DATABASE proyecto_prod TO app_user, report_user;
\c proyecto_prod
GRANT ALL ON SCHEMA public TO app_user;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO report_user;
```

### **Patrón 3: Base de Datos para Analytics**
```sql
-- Crear base para analytics
CREATE DATABASE analytics
    WITH OWNER = postgres
    ENCODING = 'UTF8';

-- Crear usuario de analytics
CREATE USER analytics_user WITH PASSWORD 'analytics123';

-- Configurar permisos específicos
GRANT CONNECT ON DATABASE analytics TO analytics_user;
\c analytics
GRANT USAGE ON SCHEMA public TO analytics_user;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO analytics_user;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO analytics_user;
```

---

## 🔍 **VERIFICACIÓN Y MONITOREO**

### **Verificar Configuración:**
```sql
-- Ver información de la base actual
SELECT 
    current_database() as "Base Actual",
    current_user as "Usuario Actual",
    session_user as "Usuario de Sesión";

-- Ver permisos del usuario actual
SELECT 
    schemaname,
    tablename,
    privilege_type
FROM information_schema.table_privileges 
WHERE grantee = current_user;
```

### **Monitorear Uso:**
```sql
-- Ver conexiones activas
SELECT 
    datname,
    usename,
    application_name,
    client_addr,
    state
FROM pg_stat_activity 
WHERE datname = 'educacionit';

-- Ver tamaño de bases de datos
SELECT 
    datname as "Base de Datos",
    pg_size_pretty(pg_database_size(datname)) as "Tamaño"
FROM pg_database 
ORDER BY pg_database_size(datname) DESC;
```

---

## 🎯 **MEJORES PRÁCTICAS**

### **Nomenclatura:**
- ✅ **Bases de datos**: snake_case, descriptivo
- ✅ **Usuarios**: snake_case, propósito claro
- ✅ **Contraseñas**: Fuertes, únicas por entorno

### **Seguridad:**
- ✅ **Principio de menor privilegio**: Dar solo permisos necesarios
- ✅ **Usuarios específicos**: Un usuario por aplicación
- ✅ **Contraseñas seguras**: Mínimo 12 caracteres
- ✅ **Auditoría**: Monitorear accesos

### **Organización:**
- ✅ **Separación por entorno**: dev, staging, prod
- ✅ **Separación por propósito**: analytics, app, logs
- ✅ **Documentación**: Registrar estructura y usuarios

---

## 🚀 **EJERCICIOS PRÁCTICOS**

### **Ejercicio 1: Crear Base de Datos de Prueba**
```sql
-- Crear base de datos 'pruebas'
CREATE DATABASE pruebas WITH OWNER = postgres;

-- Crear usuario 'tester'
CREATE USER tester WITH PASSWORD 'test123';

-- Dar permisos apropiados
GRANT CONNECT ON DATABASE pruebas TO tester;
\c pruebas
GRANT ALL ON SCHEMA public TO tester;
```

### **Ejercicio 2: Configurar Usuario de Solo Lectura**
```sql
-- Crear usuario readonly
CREATE USER readonly_user WITH PASSWORD 'readonly123';

-- Dar solo permisos de lectura
GRANT CONNECT ON DATABASE educacionit TO readonly_user;
\c educacionit
GRANT USAGE ON SCHEMA public TO readonly_user;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonly_user;
```

### **Ejercicio 3: Verificar Configuración**
```sql
-- Conectar como readonly_user y verificar permisos
\c educacionit readonly_user
SELECT * FROM clientes LIMIT 5;  -- Debería funcionar
INSERT INTO clientes VALUES (1, 'test');  -- Debería fallar
```

---

**🎯 ¡Ahora sabes crear y gestionar bases de datos PostgreSQL como un profesional!**
