# 🐝 Guía Completa: Apache Hive - Configuración y Uso

## 📋 **Resumen Ejecutivo**

Esta guía te permitirá configurar Apache Hive desde cero, incluyendo:
- ✅ **Configuración de HDFS** (sistema de archivos distribuido)
- ✅ **Configuración de Hive MetaStore** con PostgreSQL
- ✅ **Carga de datos** desde archivos CSV
- ✅ **Integración con Spark** para análisis de datos
- ✅ **Resolución de problemas** comunes

---

## 🏗️ **Arquitectura del Sistema**

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

---

## 🚀 **PASO 1: Preparación del Entorno**

### **1.1 Verificar Servicios Base**

```bash
# Verificar que Docker Compose esté corriendo
docker-compose ps

# Deberías ver estos contenedores activos:
# - metastore (PostgreSQL)
# - master (Hadoop + Hive + Spark)
# - worker1, worker2 (Nodos trabajadores)
```

### **1.2 Verificar Conectividad**

```bash
# Verificar PostgreSQL
docker exec curso-educacion-it-metastore-1 psql -U postgres -c "\l"

# Verificar HDFS
docker exec curso-educacion-it-master-1 hdfs dfs -ls /

# Verificar servicios Hadoop
docker exec curso-educacion-it-master-1 jps
```

---

## 🗄️ **PASO 2: Configuración de HDFS**

### **2.1 Crear Directorios Necesarios**

```bash
# Acceder al contenedor master
docker exec -it curso-educacion-it-master-1 bash

# Crear directorios de Hive en HDFS
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -mkdir -p /tmp
hdfs dfs -mkdir -p /user/hive
hdfs dfs -mkdir -p /user/data/etapa1

# Verificar creación
hdfs dfs -ls /user/hive/
```

### **2.2 Configurar Permisos**

```bash
# Dar permisos completos (solo para desarrollo)
hdfs dfs -chmod 777 /user/hive/warehouse
hdfs dfs -chmod 777 /tmp
hdfs dfs -chmod 777 /user/hive
hdfs dfs -chmod 777 /user/data/etapa1

# Verificar permisos
hdfs dfs -ls -d /user/hive/warehouse
```

**📝 Explicación de directorios:**
- **`/user/hive/warehouse`**: Almacena las tablas de Hive
- **`/tmp`**: Directorio temporal para operaciones
- **`/user/hive`**: Directorio de usuario del sistema Hive
- **`/user/data/etapa1`**: Directorio para archivos CSV

---

## 🐝 **PASO 3: Configuración de Apache Hive**

### **3.1 Archivo de Configuración Principal**

El archivo clave es `hive-site.xml`. Aquí está la configuración completa:

```xml
<?xml version="1.0"?>
<configuration>
    <!-- Configuración del MetaStore (PostgreSQL) -->
    <property>
        <name>javax.jdo.option.ConnectionURL</name>
        <value>jdbc:postgresql://metastore:5432/metastore</value>
        <description>JDBC connect string for a JDBC metastore</description>
    </property>

    <property>
        <name>javax.jdo.option.ConnectionDriverName</name>
        <value>org.postgresql.Driver</value>
        <description>Driver class name for a JDBC metastore</description>
    </property>

    <property>
        <name>javax.jdo.option.ConnectionUserName</name>
        <value>jupyter</value>
        <description>Username to use against metastore database</description>
    </property>

    <property>
        <name>javax.jdo.option.ConnectionPassword</name>
        <value>jupyter</value>
        <description>Password to use against metastore database</description>
    </property>

    <!-- Configuración del Warehouse -->
    <property>
        <name>hive.metastore.warehouse.dir</name>
        <value>/user/hive/warehouse</value>
        <description>Location of default database for the warehouse</description>
    </property>

    <!-- Configuración de HiveServer2 -->
    <property>
        <name>hive.server2.thrift.port</name>
        <value>10000</value>
        <description>Port number of HiveServer2 Thrift interface</description>
    </property>

    <property>
        <name>hive.server2.thrift.bind.host</name>
        <value>0.0.0.0</value>
        <description>Bind host on which to run the HiveServer2 Thrift service</description>
    </property>

    <!-- Configuración de Seguridad (Desarrollo) -->
    <property>
        <name>hive.server2.authentication</name>
        <value>NONE</value>
        <description>Authentication mode for HiveServer2</description>
    </property>

    <!-- Configuración de Ejecución -->
    <property>
        <name>hive.execution.engine</name>
        <value>mr</value>
        <description>Execution engine to use (mr/tez/spark)</description>
    </property>

    <!-- Configuración de Schema -->
    <property>
        <name>hive.metastore.schema.verification</name>
        <value>false</value>
        <description>Enforce metastore schema version consistency</description>
    </property>

    <property>
        <name>datanucleus.schema.autoCreateAll</name>
        <value>true</value>
        <description>Auto-create metastore schema</description>
    </property>
</configuration>
```

### **3.2 Aplicar Configuración**

```bash
# Desde el contenedor master
docker exec -it curso-educacion-it-master-1 bash

# Hacer backup de la configuración actual
cp /opt/hive/conf/hive-site.xml /opt/hive/conf/hive-site.xml.backup

# Si tienes un archivo hive-site-working.xml, usarlo:
cp /opt/hive/conf/hive-site-working.xml /opt/hive/conf/hive-site.xml

# Verificar configuración
ls -la /opt/hive/conf/hive-site.xml
```

### **3.3 Inicializar Schema de MetaStore**

```bash
# Inicializar schema de Hive en PostgreSQL
cd /opt/hive/bin
./schematool -dbType postgres -initSchema

# Si ya existe, usar upgrade:
./schematool -dbType postgres -upgradeSchema
```

---

## 🔄 **PASO 4: Iniciar Servicios de Hive**

### **4.1 Iniciar MetaStore**

```bash
# Desde el contenedor master
cd /opt/hive/bin

# Iniciar MetaStore en background
nohup ./hive --service metastore > /tmp/metastore.log 2>&1 &

# Verificar que esté corriendo
ps aux | grep metastore
```

### **4.2 Iniciar HiveServer2 (Opcional)**

```bash
# Iniciar HiveServer2 en background
nohup ./hive --service hiveserver2 > /tmp/hiveserver2.log 2>&1 &

# Verificar que esté corriendo
ps aux | grep hiveserver2

# Verificar puerto
ss -tlnp | grep 10000
```

### **4.3 Script de Inicio Automático**

Crear script para iniciar servicios automáticamente:

```bash
#!/bin/bash
# start-hive.sh

echo "🐝 Iniciando servicios de Hive..."

# Detener servicios existentes
pkill -f HiveServer2
pkill -f MetaStore

# Esperar un momento
sleep 3

# Iniciar MetaStore
echo "📊 Iniciando MetaStore..."
cd /opt/hive/bin
nohup ./hive --service metastore > /tmp/metastore.log 2>&1 &

# Esperar a que MetaStore esté listo
sleep 10

# Iniciar HiveServer2 (opcional)
echo "🔌 Iniciando HiveServer2..."
nohup ./hive --service hiveserver2 > /tmp/hiveserver2.log 2>&1 &

echo "✅ Servicios de Hive iniciados"
echo "📊 MetaStore: Activo"
echo "🔌 HiveServer2: Puerto 10000"
```

---

## 📊 **PASO 5: Crear Base de Datos y Tablas**

### **5.1 Conectar a Hive**

```bash
# Opción 1: Cliente CLI (más simple)
/opt/hive/bin/hive --service cli

# Opción 2: Beeline (más moderno)
/opt/hive/bin/beeline -u jdbc:hive2://localhost:10000
```

### **5.2 Crear Base de Datos**

```sql
-- Crear base de datos
CREATE DATABASE IF NOT EXISTS educacionit
COMMENT 'Base de datos para el curso de Data Engineering'
LOCATION '/user/hive/warehouse/educacionit.db';

-- Usar la base de datos
USE educacionit;

-- Verificar
SHOW DATABASES;
```

### **5.3 Crear Tablas**

```sql
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

-- 3. Tabla clientes (delimitador ;)
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

-- 4. Tabla ventas
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

-- Verificar tablas creadas
SHOW TABLES;
```

---

## 📥 **PASO 6: Carga de Datos**

### **6.1 Subir Archivos CSV a HDFS**

```bash
# Copiar archivos CSV al contenedor master
docker cp data/etapa1/. curso-educacion-it-master-1:/tmp/etapa1/

# Subir archivos a HDFS
hdfs dfs -put /tmp/etapa1/*.csv /user/data/etapa1/

# Verificar archivos
hdfs dfs -ls /user/data/etapa1/
```

### **6.2 Cargar Datos en Tablas**

```sql
-- Cargar canal de venta
LOAD DATA INPATH '/user/data/etapa1/CanalDeVenta.csv' 
OVERWRITE INTO TABLE canal_venta;

-- Cargar productos
LOAD DATA INPATH '/user/data/etapa1/PRODUCTOS.csv' 
OVERWRITE INTO TABLE productos;

-- Cargar clientes (delimitador ;)
LOAD DATA INPATH '/user/data/etapa1/Clientes.csv' 
OVERWRITE INTO TABLE clientes;

-- Cargar ventas
LOAD DATA INPATH '/user/data/etapa1/Venta.csv' 
OVERWRITE INTO TABLE ventas;

-- Verificar datos cargados
SELECT COUNT(*) FROM canal_venta;
SELECT COUNT(*) FROM productos;
SELECT COUNT(*) FROM clientes;
SELECT COUNT(*) FROM ventas;
```

---

## 🔗 **PASO 7: Integración con Spark**

### **7.1 Configurar Spark con Hive**

```python
from pyspark.sql import SparkSession

# Crear sesión de Spark con soporte Hive
spark = SparkSession.builder \
    .appName("HiveIntegration") \
    .enableHiveSupport() \
    .getOrCreate()

# Cambiar a base de datos educacionit
spark.sql("USE educacionit")

# Mostrar tablas
spark.sql("SHOW TABLES").show()
```

### **7.2 Consultas desde Spark**

```python
# Leer datos desde Hive
clientes_df = spark.sql("SELECT * FROM clientes")
ventas_df = spark.sql("SELECT * FROM ventas")

# Análisis combinado
resultado = spark.sql("""
    SELECT 
        c.provincia,
        COUNT(*) as total_ventas,
        SUM(v.precio * v.cantidad) as monto_total
    FROM ventas v 
    JOIN clientes c ON v.id_cliente = c.id 
    WHERE c.provincia IS NOT NULL
    GROUP BY c.provincia 
    ORDER BY total_ventas DESC 
    LIMIT 10
""")

resultado.show()
```

---

## 🔧 **PASO 8: Resolución de Problemas**

### **8.1 Problemas Comunes**

#### **Error: "MetaException: Could not connect to meta store"**
```bash
# Verificar que PostgreSQL esté corriendo
docker ps | grep metastore

# Verificar conectividad
docker exec curso-educacion-it-master-1 ping metastore

# Reiniciar MetaStore
pkill -f MetaStore
/opt/hive/bin/hive --service metastore &
```

#### **Error: "Permission denied" en HDFS**
```bash
# Verificar permisos
hdfs dfs -ls -d /user/hive/warehouse

# Corregir permisos
hdfs dfs -chmod -R 777 /user/hive/warehouse
```

#### **Error: "Table not found"**
```bash
# Verificar que estés en la base correcta
USE educacionit;
SHOW TABLES;

# Verificar ubicación de archivos
hdfs dfs -ls /user/hive/warehouse/educacionit.db/
```

### **8.2 Comandos de Diagnóstico**

```bash
# Ver logs de Hive
tail -f /tmp/metastore.log
tail -f /tmp/hiveserver2.log

# Verificar procesos
ps aux | grep -i hive

# Verificar puertos
ss -tlnp | grep -E "(9083|10000)"

# Verificar conectividad a PostgreSQL
docker exec curso-educacion-it-master-1 psql -h metastore -U jupyter -d metastore -c "\l"
```

---

## 📚 **PASO 9: Scripts de Automatización**

### **9.1 Script Completo de Configuración**

```bash
#!/bin/bash
# setup-hive-complete.sh

echo "🐝 Configuración completa de Apache Hive"
echo "========================================"

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 1. Verificar servicios base
echo -e "${BLUE}📊 Paso 1: Verificando servicios base...${NC}"
docker-compose ps | grep -E "(metastore|master)" || {
    echo -e "${RED}❌ Servicios no están corriendo${NC}"
    exit 1
}

# 2. Configurar HDFS
echo -e "${BLUE}🗄️ Paso 2: Configurando HDFS...${NC}"
docker exec curso-educacion-it-master-1 hdfs dfs -mkdir -p /user/hive/warehouse /tmp /user/hive /user/data/etapa1
docker exec curso-educacion-it-master-1 hdfs dfs -chmod 777 /user/hive/warehouse /tmp /user/hive /user/data/etapa1

# 3. Configurar Hive
echo -e "${BLUE}🐝 Paso 3: Configurando Hive...${NC}"
docker exec curso-educacion-it-master-1 cp /opt/hive/conf/hive-site-working.xml /opt/hive/conf/hive-site.xml 2>/dev/null || echo "Archivo hive-site-working.xml no encontrado"

# 4. Inicializar schema
echo -e "${BLUE}📋 Paso 4: Inicializando schema...${NC}"
docker exec curso-educacion-it-master-1 /opt/hive/bin/schematool -dbType postgres -initSchema 2>/dev/null || echo "Schema ya existe"

# 5. Iniciar servicios
echo -e "${BLUE}🔄 Paso 5: Iniciando servicios...${NC}"
docker exec curso-educacion-it-master-1 bash -c "pkill -f MetaStore; pkill -f HiveServer2"
docker exec -d curso-educacion-it-master-1 /opt/hive/bin/hive --service metastore
sleep 10
docker exec -d curso-educacion-it-master-1 /opt/hive/bin/hive --service hiveserver2

# 6. Copiar datos
echo -e "${BLUE}📁 Paso 6: Copiando datos...${NC}"
docker cp data/etapa1/. curso-educacion-it-master-1:/tmp/etapa1/
docker exec curso-educacion-it-master-1 hdfs dfs -put /tmp/etapa1/*.csv /user/data/etapa1/ 2>/dev/null || echo "Archivos ya existen"

echo -e "${GREEN}✅ Configuración de Hive completada${NC}"
echo -e "${BLUE}🔌 Servicios disponibles:${NC}"
echo -e "${YELLOW}   • Hive CLI: docker exec -it curso-educacion-it-master-1 /opt/hive/bin/hive${NC}"
echo -e "${YELLOW}   • Beeline: docker exec -it curso-educacion-it-master-1 /opt/hive/bin/beeline -u jdbc:hive2://localhost:10000${NC}"
echo -e "${YELLOW}   • HDFS Web: http://localhost:9870${NC}"
```

### **9.2 Script de Verificación**

```bash
#!/bin/bash
# verify-hive.sh

echo "🔍 Verificación de Apache Hive"
echo "=============================="

# Verificar servicios
echo "📊 Servicios corriendo:"
docker exec curso-educacion-it-master-1 ps aux | grep -E "(metastore|hiveserver)" | grep -v grep

# Verificar HDFS
echo -e "\n🗄️ Directorios HDFS:"
docker exec curso-educacion-it-master-1 hdfs dfs -ls /user/hive/

# Verificar conectividad
echo -e "\n🔌 Conectividad:"
docker exec curso-educacion-it-master-1 /opt/hive/bin/hive --service cli -e "SHOW DATABASES;" 2>/dev/null && echo "✅ Hive CLI funcional" || echo "❌ Hive CLI no funcional"

# Verificar datos
echo -e "\n📊 Datos disponibles:"
docker exec curso-educacion-it-master-1 hdfs dfs -ls /user/data/etapa1/ | wc -l
echo "archivos CSV encontrados"
```

---

## 🎯 **PASO 10: Uso Avanzado**

### **10.1 Optimizaciones**

```sql
-- Habilitar compresión
SET hive.exec.compress.output=true;
SET mapred.output.compression.codec=org.apache.hadoop.io.compress.SnappyCodec;

-- Optimizar joins
SET hive.auto.convert.join=true;
SET hive.mapjoin.smalltable.filesize=25000000;

-- Particionamiento
CREATE TABLE ventas_partitioned (
    id_venta INT,
    fecha STRING,
    id_cliente INT,
    precio DECIMAL(10,2)
)
PARTITIONED BY (año INT, mes INT)
STORED AS PARQUET;
```

### **10.2 Consultas Avanzadas**

```sql
-- Window functions
SELECT 
    cliente_id,
    fecha,
    precio,
    ROW_NUMBER() OVER (PARTITION BY cliente_id ORDER BY fecha) as num_compra
FROM ventas;

-- CTEs (Common Table Expressions)
WITH ventas_mensuales AS (
    SELECT 
        YEAR(fecha) as año,
        MONTH(fecha) as mes,
        SUM(precio * cantidad) as total
    FROM ventas 
    GROUP BY YEAR(fecha), MONTH(fecha)
)
SELECT * FROM ventas_mensuales WHERE total > 100000;
```

---

## 📖 **Referencias y Recursos**

### **Documentación Oficial**
- [Apache Hive Documentation](https://hive.apache.org/)
- [Hadoop HDFS Guide](https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/HdfsUserGuide.html)
- [Spark SQL Guide](https://spark.apache.org/docs/latest/sql-programming-guide.html)

### **Comandos de Referencia Rápida**

```bash
# HDFS
hdfs dfs -ls /                    # Listar archivos
hdfs dfs -mkdir /directorio       # Crear directorio
hdfs dfs -put archivo.csv /ruta   # Subir archivo
hdfs dfs -get /ruta archivo.csv   # Descargar archivo

# Hive CLI
hive -e "SHOW DATABASES;"         # Ejecutar comando
hive -f script.sql                # Ejecutar script
hive --service cli                # Modo interactivo

# Beeline
beeline -u jdbc:hive2://localhost:10000 -e "SHOW TABLES;"
```

---

## 🎉 **¡Configuración Completa!**

Con esta guía tienes todo lo necesario para:

- ✅ **Configurar Hive** desde cero
- ✅ **Cargar datos** desde CSV
- ✅ **Integrar con Spark** para análisis
- ✅ **Resolver problemas** comunes
- ✅ **Automatizar** el proceso

**¡Tu entorno de Data Engineering con Hive está listo para usar!** 🚀

---

*Creado para el Curso de Data Engineering - EducacionIT*
*Versión: 1.0 | Fecha: Septiembre 2025*
