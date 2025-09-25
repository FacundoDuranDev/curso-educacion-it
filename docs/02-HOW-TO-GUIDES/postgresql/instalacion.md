# 🐘 INSTALACIÓN POSTGRESQL

> **🎯 Objetivo:** Configurar PostgreSQL completo con la base de datos del curso

## 🚀 **INSTALACIÓN RÁPIDA**

### **⚡ Opción 1: Con todo el entorno (RECOMENDADA)**
```bash
# Instala PostgreSQL + Hadoop + Spark + Jupyter
git clone https://github.com/FacundoDuranDev/curso-educacion-it.git
cd curso-educacion-it
make
```

### **🎯 Opción 2: Solo PostgreSQL**
```bash
# Solo la base de datos
docker-compose up -d metastore
```

---

## 📊 **QUÉ OBTIENES**

### **✅ Base de Datos Lista:**
- 🗄️ **PostgreSQL 11** corriendo en puerto 5432
- 📊 **Base de datos `educacionit`** con todas las tablas
- 👤 **Usuario `admin`** con contraseña `admin123`
- 🔧 **Datos de ejemplo** cargados automáticamente

### **📋 Tablas Incluidas:**
```sql
-- Tablas principales del curso
Clientes        -- Información de clientes
Productos       -- Catálogo de productos  
Ventas          -- Transacciones de venta
Empleados       -- Personal de la empresa
Sucursales      -- Ubicaciones de tiendas
Proveedores     -- Proveedores de productos
Gastos          -- Gastos operativos
TiposDeGasto    -- Categorías de gastos
CanalDeVenta    -- Canales de distribución
Compras         -- Compras a proveedores
```

---

## 🔧 **VERIFICACIÓN RÁPIDA**

### **1. Verificar que PostgreSQL está corriendo:**
```bash
docker ps | grep metastore
# Debe mostrar: educacionit-metastore-1 ... Up
```

### **2. Probar conexión:**
```bash
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "SELECT 'Conexión OK!' as resultado;"
```

### **3. Ver tablas disponibles:**
```bash
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\dt"
```

---

## 🌐 **CONECTAR DESDE APLICACIONES**

### **📊 DBeaver (Recomendado):**
```
Host: localhost
Puerto: 5432
Base de datos: educacionit
Usuario: admin
Contraseña: admin123
```
👉 **Guía detallada:** `conexion-dbeaver.md`

### **🐍 Python:**
```python
import psycopg2

conn = psycopg2.connect(
    host="localhost",
    port=5432,
    database="educacionit",
    user="admin",
    password="admin123"
)
```

### **☕ Java (JDBC):**
```java
String url = "jdbc:postgresql://localhost:5432/educacionit";
String username = "admin";
String password = "admin123";
Connection conn = DriverManager.getConnection(url, username, password);
```

---

## 🚨 **TROUBLESHOOTING**

### **❌ "Connection refused"**
```bash
# Verificar que el contenedor está corriendo
docker-compose ps metastore

# Si no está corriendo, levantarlo
docker-compose up -d metastore

# Ver logs si hay errores
docker-compose logs metastore
```

### **❌ "Database does not exist"**
```bash
# Crear la base de datos manualmente
docker exec -it educacionit-metastore-1 psql -U postgres -c "CREATE DATABASE educacionit;"

# Crear usuario admin
docker exec -it educacionit-metastore-1 psql -U postgres -c "
CREATE USER admin WITH PASSWORD 'admin123';
GRANT ALL PRIVILEGES ON DATABASE educacionit TO admin;
"
```

### **❌ "Password authentication failed"**
```bash
# Recrear usuario admin
docker exec -it educacionit-metastore-1 psql -U postgres -c "
DROP USER IF EXISTS admin;
CREATE USER admin WITH PASSWORD 'admin123';
GRANT ALL PRIVILEGES ON DATABASE educacionit TO admin;
"
```

---

## 📚 **CARGAR DATOS**

### **🎯 Datos Automáticos:**
Los datos se cargan automáticamente cuando ejecutas `make`. Incluye:
- ✅ **Clientes:** 1000+ registros
- ✅ **Productos:** Catálogo completo
- ✅ **Ventas:** Transacciones históricas
- ✅ **Empleados:** Personal de ejemplo

### **📥 Carga Manual:**
Si necesitas recargar datos:
```bash
# Ejecutar script de carga
docker exec -it educacionit-metastore-1 bash -c "
cd /opt && 
psql -U admin -d educacionit -f /path/to/load_data.sql
"
```

👉 **Guía completa:** `carga-datos.md`

---

## 🎯 **PRÓXIMOS PASOS**

### **📊 Para Análisis de Datos:**
1. **Conectar DBeaver** → `conexion-dbeaver.md`
2. **Ejecutar consultas SQL** → `../../05-EXERCISES/sql-queries/`
3. **Crear reportes** → `../../03-CONCEPTS/sql-avanzado.md`

### **🔄 Para Integración Big Data:**
1. **Configurar Hive** → `../hadoop-spark/hive-setup.md`
2. **Spark + PostgreSQL** → `../hadoop-spark/spark-postgresql.md`
3. **ETL Pipelines** → `../../03-CONCEPTS/etl-patterns.md`

---

## ℹ️ **INFORMACIÓN TÉCNICA**

### **🔧 Configuración del Contenedor:**
```yaml
# docker-compose.yml
metastore:
  image: postgres:11
  hostname: metastore
  environment:
    POSTGRES_PASSWORD: jupyter
  ports:
    - "5432:5432"
  volumes:
    - postgres_data:/var/lib/postgresql/data
```

### **👥 Usuarios Configurados:**
```sql
-- Usuario administrador del sistema
postgres / jupyter

-- Usuario del curso (para ejercicios)
admin / admin123
```

### **🗄️ Bases de Datos:**
```sql
-- Base principal del curso
educacionit

-- Base del metastore Hive (automática)
metastore

-- Base por defecto
postgres
```

---

## 🆘 **¿NECESITAS AYUDA?**

- 🚨 **Problemas comunes:** `../troubleshooting/problemas-comunes.md`
- 🔑 **Credenciales:** `../../04-REFERENCE/credenciales.md`
- 📞 **Soporte:** Consulta con tu instructor

**🎯 ¡Con PostgreSQL configurado, ya puedes empezar a trabajar con datos reales!**
