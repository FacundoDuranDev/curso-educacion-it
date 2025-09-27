# 🐝 HIVE SETUP COMPLETO

> **🎯 Objetivo:** Configurar Apache Hive desde cero con PostgreSQL como metastore

## 🚀 **CONFIGURACIÓN RÁPIDA**

### **⚡ Con el entorno completo:**
```bash
# Instala todo automáticamente
git clone https://github.com/FacundoDuranDev/curso-educacion-it.git
cd curso-educacion-it
make
```

### **🎯 Solo Hive (si ya tienes el entorno):**
```bash
# Verificar servicios base
docker-compose ps

# Iniciar Hive específicamente
docker-compose up -d master
```

---

## 🏗️ **ARQUITECTURA DEL SISTEMA**

### **📊 Componentes y Conexiones:**
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   PostgreSQL    │    │      HDFS       │    │   Apache Hive   │
│   (MetaStore)   │◄──►│ (Almacenamiento)│◄──►│   (SQL Engine)  │
│   Puerto: 5432  │    │ Puerto: 8020/9870│   │ Puerto: 10000   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                        │                        │
         │                        │                        │
         └────────────────────────┼────────────────────────┘
                                  │
                        ┌─────────────────┐
                        │   Apache Spark  │
                        │   (Procesamiento)│
                        │ Puerto: 8080    │
                        └─────────────────┘
```

### **🔗 Flujo de Datos:**
1. **PostgreSQL** → Almacena metadatos de Hive (esquemas, tablas, particiones)
2. **HDFS** → Almacena los datos reales en archivos distribuidos
3. **Hive** → Proporciona interfaz SQL sobre HDFS
4. **Spark** → Procesa datos usando Hive como metastore

---

## 🔧 **VERIFICACIÓN DEL ENTORNO**

### **📋 Paso 1: Verificar Servicios Base**
```bash
# Verificar que todos los servicios estén corriendo
docker-compose ps

# Debe mostrar:
# educacionit-metastore-1    (PostgreSQL)
# educacionit-master-1       (Hadoop + Hive + Spark)
# educacionit-worker-1       (Hadoop Worker)
# educacionit-worker-2       (Hadoop Worker)
```

### **🗄️ Paso 2: Verificar PostgreSQL (Metastore)**
```bash
# Conectar a PostgreSQL
docker exec -it educacionit-metastore-1 psql -U jupyter -d metastore

# Verificar tablas del metastore
\dt

# Debe mostrar tablas como: TBLS, DBS, SDS, etc.
```

### **📁 Paso 3: Verificar HDFS**
```bash
# Verificar HDFS desde el master
docker exec -it educacionit-master-1 hdfs dfs -ls /

# Debe mostrar directorios como:
# /tmp, /user, /data, etc.
```

### **🐝 Paso 4: Verificar Hive**
```bash
# Conectar a Hive
docker exec -it educacionit-master-1 hive

# En el prompt de Hive:
SHOW DATABASES;
SHOW TABLES;

# Salir de Hive
exit;
```

---

## 📊 **CONFIGURACIÓN DE DATOS**

### **🗂️ Estructura de Directorios HDFS**
```bash
# Crear estructura de directorios para el curso
docker exec -it educacionit-master-1 hdfs dfs -mkdir -p /data/etapa1
docker exec -it educacionit-master-1 hdfs dfs -mkdir -p /data/etapa2
docker exec -it educacionit-master-1 hdfs dfs -mkdir -p /user/hive/warehouse

# Verificar estructura creada
docker exec -it educacionit-master-1 hdfs dfs -ls -R /data
```

### **📥 Cargar Datos CSV a HDFS**
```bash
# Copiar archivos CSV del curso a HDFS
docker exec -it educacionit-master-1 hdfs dfs -put /opt/data/etapa1/*.csv /data/etapa1/
docker exec -it educacionit-master-1 hdfs dfs -put /opt/data/etapa2/*.csv /data/etapa2/

# Verificar que los archivos se copiaron
docker exec -it educacionit-master-1 hdfs dfs -ls /data/etapa1
docker exec -it educacionit-master-1 hdfs dfs -ls /data/etapa2
```

---

## 🐝 **CREAR TABLAS EN HIVE**

### **📋 Script de Creación de Tablas**
```sql
-- Conectar a Hive
docker exec -it educacionit-master-1 hive

-- Crear base de datos del curso
CREATE DATABASE IF NOT EXISTS educacionit;
USE educacionit;

-- Tabla de clientes
CREATE TABLE IF NOT EXISTS clientes (
    id_cliente INT,
    nombre_completo STRING,
    email STRING,
    telefono STRING,
    ciudad STRING,
    edad INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/data/etapa1/Clientes.csv';

-- Tabla de productos
CREATE TABLE IF NOT EXISTS productos (
    id_producto INT,
    nombre_producto STRING,
    precio DOUBLE,
    categoria STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/data/etapa1/PRODUCTOS.csv';

-- Tabla de ventas
CREATE TABLE IF NOT EXISTS ventas (
    id_venta INT,
    id_cliente INT,
    id_producto INT,
    id_sucursal INT,
    id_empleado INT,
    id_canal INT,
    cantidad INT,
    precio DOUBLE,
    fecha_venta DATE
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/data/etapa1/Venta.csv';

-- Tabla de empleados
CREATE TABLE IF NOT EXISTS empleados (
    id_empleado INT,
    nombre_completo STRING,
    apellido STRING,
    sucursal STRING,
    sector STRING,
    cargo STRING,
    salario DOUBLE
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/data/etapa1/Empleados.csv';

-- Tabla de sucursales
CREATE TABLE IF NOT EXISTS sucursales (
    id_sucursal INT,
    nombre_sucursal STRING,
    direccion STRING,
    localidad STRING,
    provincia STRING,
    latitud DOUBLE,
    longitud DOUBLE
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/data/etapa1/Sucursales.csv';
```

### **✅ Verificar Tablas Creadas**
```sql
-- En Hive, verificar que las tablas se crearon
SHOW TABLES;

-- Ver estructura de una tabla
DESCRIBE clientes;

-- Contar registros en cada tabla
SELECT COUNT(*) FROM clientes;
SELECT COUNT(*) FROM productos;
SELECT COUNT(*) FROM ventas;
SELECT COUNT(*) FROM empleados;
SELECT COUNT(*) FROM sucursales;
```

---

## 🔍 **CONSULTAS DE EJEMPLO**

### **📊 Análisis Básico de Datos**
```sql
-- Top 10 clientes por ciudad
SELECT 
    ciudad,
    COUNT(*) as total_clientes
FROM clientes
GROUP BY ciudad
ORDER BY total_clientes DESC
LIMIT 10;

-- Productos más caros
SELECT 
    nombre_producto,
    precio
FROM productos
ORDER BY precio DESC
LIMIT 10;

-- Ventas por mes
SELECT 
    YEAR(fecha_venta) as año,
    MONTH(fecha_venta) as mes,
    COUNT(*) as total_ventas,
    SUM(precio * cantidad) as ingresos
FROM ventas
GROUP BY YEAR(fecha_venta), MONTH(fecha_venta)
ORDER BY año, mes;
```

### **🔗 JOINs entre Tablas**
```sql
-- Ventas con información de cliente y producto
SELECT 
    c.nombre_completo as cliente,
    p.nombre_producto as producto,
    v.cantidad,
    v.precio,
    v.fecha_venta
FROM ventas v
JOIN clientes c ON v.id_cliente = c.id_cliente
JOIN productos p ON v.id_producto = p.id_producto
LIMIT 10;

-- Análisis de ventas por sucursal
SELECT 
    s.nombre_sucursal,
    s.provincia,
    COUNT(v.id_venta) as total_ventas,
    SUM(v.precio * v.cantidad) as ingresos_totales
FROM ventas v
JOIN sucursales s ON v.id_sucursal = s.id_sucursal
GROUP BY s.id_sucursal, s.nombre_sucursal, s.provincia
ORDER BY ingresos_totales DESC;
```

---

## ⚡ **INTEGRACIÓN CON SPARK**

### **🔥 Usar Hive desde Spark**
```python
# En Jupyter Notebook o PySpark
from pyspark.sql import SparkSession

# Crear SparkSession con soporte Hive
spark = SparkSession.builder \
    .appName("Hive-Spark-Integration") \
    .master("spark://spark-master:7077") \
    .config("spark.executor.memory", "800m") \
    .config("spark.executor.cores", "1") \
    .config("spark.executor.instances", "2") \
    .config("spark.driver.memory", "1g") \
    .config("spark.sql.warehouse.dir", "/user/hive/warehouse") \
    .enableHiveSupport() \
    .getOrCreate()

# Usar tablas de Hive directamente
df_clientes = spark.sql("SELECT * FROM educacionit.clientes LIMIT 10")
df_clientes.show()

# Análisis avanzado con Spark
df_ventas = spark.sql("""
    SELECT 
        c.ciudad,
        COUNT(v.id_venta) as total_ventas,
        SUM(v.precio * v.cantidad) as ingresos
    FROM educacionit.ventas v
    JOIN educacionit.clientes c ON v.id_cliente = c.id_cliente
    GROUP BY c.ciudad
    ORDER BY ingresos DESC
""")

df_ventas.show()
```

### **📊 Crear Vistas Materializadas**
```sql
-- En Hive, crear vista para análisis frecuente
CREATE VIEW IF NOT EXISTS ventas_resumen AS
SELECT 
    c.ciudad,
    p.categoria,
    COUNT(v.id_venta) as total_ventas,
    SUM(v.precio * v.cantidad) as ingresos,
    AVG(v.precio * v.cantidad) as ticket_promedio
FROM ventas v
JOIN clientes c ON v.id_cliente = c.id_cliente
JOIN productos p ON v.id_producto = p.id_producto
GROUP BY c.ciudad, p.categoria;

-- Usar la vista
SELECT * FROM ventas_resumen 
WHERE ciudad = 'Madrid' 
ORDER BY ingresos DESC;
```

---

## 🚨 **TROUBLESHOOTING**

### **❌ "Database does not exist"**
```bash
# Verificar que la base de datos existe
docker exec -it educacionit-master-1 hive -e "SHOW DATABASES;"

# Crear base de datos si no existe
docker exec -it educacionit-master-1 hive -e "CREATE DATABASE educacionit;"
```

### **❌ "Table not found"**
```bash
# Verificar que las tablas existen
docker exec -it educacionit-master-1 hive -e "USE educacionit; SHOW TABLES;"

# Verificar ubicación de archivos en HDFS
docker exec -it educacionit-master-1 hdfs dfs -ls /data/etapa1/
```

### **❌ "Permission denied"**
```bash
# Verificar permisos en HDFS
docker exec -it educacionit-master-1 hdfs dfs -ls -la /data/

# Cambiar permisos si es necesario
docker exec -it educacionit-master-1 hdfs dfs -chmod -R 755 /data/
```

### **❌ "Connection refused"**
```bash
# Verificar que los servicios estén corriendo
docker-compose ps

# Reiniciar servicios si es necesario
docker-compose restart master
```

---

## 📈 **OPTIMIZACIÓN Y RENDIMIENTO**

### **🎯 Configuraciones Recomendadas**
```sql
-- En Hive, optimizar para consultas
SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode = nonstrict;
SET hive.exec.max.dynamic.partitions = 1000;
SET hive.exec.max.dynamic.partitions.pernode = 100;

-- Optimizar JOINs
SET hive.auto.convert.join = true;
SET hive.auto.convert.join.noconditionaltask = true;
SET hive.auto.convert.join.noconditionaltask.size = 1000000000;
```

### **📊 Particionado de Tablas**
```sql
-- Crear tabla particionada por fecha
CREATE TABLE ventas_particionada (
    id_venta INT,
    id_cliente INT,
    id_producto INT,
    cantidad INT,
    precio DOUBLE
)
PARTITIONED BY (fecha_venta DATE)
STORED AS TEXTFILE;

-- Insertar datos en particiones
INSERT INTO TABLE ventas_particionada PARTITION(fecha_venta)
SELECT 
    id_venta,
    id_cliente,
    id_producto,
    cantidad,
    precio,
    fecha_venta
FROM ventas;
```

---

## 🔗 **RECURSOS ADICIONALES**

### **📚 Guías Relacionadas:**
- **HDFS Management:** `hdfs-management.md`
- **YARN Monitoring:** `yarn-monitoring.md`
- **Spark Integration:** `spark-postgresql.md`
- **Troubleshooting:** `../troubleshooting/problemas-comunes.md`

### **🛠️ Herramientas Útiles:**
- **Hive Web UI:** http://localhost:10002 (si está habilitado)
- **HDFS Web UI:** http://localhost:9870
- **Spark Master UI:** http://localhost:8080

### **📖 Documentación:**
- Apache Hive Documentation
- Hive SQL Language Manual
- Hive Performance Tuning

---

## 🆘 **¿NECESITAS AYUDA?**

### **🚨 Problemas Comunes:**
- **Metastore connection:** Verificar PostgreSQL
- **HDFS permissions:** Revisar permisos de archivos
- **Memory issues:** Ajustar configuración de memoria

### **📞 Soporte:**
- **Instructor:** Consulta en clase
- **Logs:** `docker-compose logs master`
- **Documentación:** Hive official docs

**🎯 ¡Con Hive configurado, ya puedes hacer análisis SQL sobre Big Data!**
