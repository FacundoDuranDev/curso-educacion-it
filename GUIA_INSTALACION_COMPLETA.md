# 🚀 Guía Completa de Instalación - Cluster Hadoop con Hive, Spark y Jupyter

## 📋 Prerrequisitos

### Sistema Operativo
- **Linux** (Ubuntu 20.04+ recomendado)
- **Windows**: WSL2 con Ubuntu
- **macOS**: Docker Desktop

### Requisitos Mínimos
- **RAM**: 8GB mínimo (16GB recomendado)
- **CPU**: 4 cores mínimo
- **Disco**: 20GB espacio libre
- **Docker**: Versión 20.10+
- **Docker Compose**: Versión 2.0+

## 🔧 Instalación de Prerrequisitos

### 1. Instalar Docker

```bash
# Actualizar repositorios
sudo apt update

# Instalar dependencias
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

# Agregar clave GPG oficial de Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Agregar repositorio de Docker
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instalar Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Agregar usuario al grupo docker
sudo usermod -aG docker $USER

# Habilitar Docker al inicio
sudo systemctl enable docker
sudo systemctl start docker
```

### 2. Instalar Docker Compose

```bash
# Instalar Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Dar permisos de ejecución
sudo chmod +x /usr/local/bin/docker-compose

# Verificar instalación
docker-compose --version
```

### 3. Configurar Límites del Sistema

```bash
# Editar límites del sistema
sudo nano /etc/security/limits.conf

# Agregar estas líneas al final del archivo:
* soft nofile 65536
* hard nofile 65536
* soft nproc 32768
* hard nproc 32768

# Reiniciar sesión para aplicar cambios
# O ejecutar: newgrp docker
```

## 📁 Preparación del Proyecto

### 1. Crear Estructura de Directorios

```bash
# Crear directorio del proyecto
mkdir -p ~/educacionit
cd ~/educacionit

# Crear subdirectorios
mkdir -p notebooks scripts/hive data
```

### 2. Descargar Archivos del Proyecto

```bash
# Clonar repositorio (si está en GitHub)
git clone <URL_DEL_REPOSITORIO> .

# O crear manualmente los archivos necesarios
```

### 3. Verificar Estructura

```bash
# La estructura debe ser:
educacionit/
├── docker-compose.yaml
├── notebooks/
├── scripts/
│   └── hive/
├── data/
└── Etapa 1/
    ├── Clientes.csv
    ├── PRODUCTOS.csv
    ├── Venta.csv
    └── ... (otros archivos CSV)
```

## 🐳 Configuración del Docker Compose

### 1. Crear docker-compose.yaml

Crear el archivo `docker-compose.yaml` con el siguiente contenido:

```yaml
services:
  postgres:
    image: postgres:15
    container_name: postgres
    restart: always
    environment:
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: admin
      POSTGRES_DB: educacionit
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data
    networks:
      - hadoop-network

  hadoop-namenode:
    image: bde2020/hadoop-namenode:2.0.0-hadoop3.2.1-java8
    container_name: hadoop-namenode
    environment:
      - CLUSTER_NAME=test
      - CORE_CONF_fs_defaultFS=hdfs://hadoop-namenode:8020
    ports:
      - "9870:9870"
    volumes:
      - hadoop_namenode:/hadoop/dfs/name
    ulimits:
      nofile:
        soft: 65536
        hard: 65536
    networks:
      - hadoop-network

  hadoop-datanode-1:
    image: bde2020/hadoop-datanode:2.0.0-hadoop3.2.1-java8
    container_name: hadoop-datanode-1
    environment:
      - SERVICE_PRECONDITION=hadoop-namenode:9870
      - CORE_CONF_fs_defaultFS=hdfs://hadoop-namenode:8020
    volumes:
      - hadoop_datanode_1:/hadoop/dfs/data
    ulimits:
      nofile:
        soft: 65536
        hard: 65536
    depends_on:
      - hadoop-namenode
    networks:
      - hadoop-network

  hadoop-datanode-2:
    image: bde2020/hadoop-datanode:2.0.0-hadoop3.2.1-java8
    container_name: hadoop-datanode-2
    environment:
      - SERVICE_PRECONDITION=hadoop-namenode:9870
      - CORE_CONF_fs_defaultFS=hdfs://hadoop-namenode:8020
    volumes:
      - hadoop_datanode_2:/hadoop/dfs/data
    ulimits:
      nofile:
        soft: 65536
        hard: 65536
    depends_on:
      - hadoop-namenode
    networks:
      - hadoop-network

  hadoop-datanode-3:
    image: bde2020/hadoop-datanode:2.0.0-hadoop3.2.1-java8
    container_name: hadoop-datanode-3
    environment:
      - SERVICE_PRECONDITION=hadoop-namenode:9870
      - CORE_CONF_fs_defaultFS=hdfs://hadoop-namenode:8020
    volumes:
      - hadoop_datanode_3:/hadoop/dfs/data
    ulimits:
      nofile:
        soft: 65536
        hard: 65536
    depends_on:
      - hadoop-namenode
    networks:
      - hadoop-network

  spark-master:
    image: bde2020/spark-master:3.1.1-hadoop3.2
    container_name: spark-master
    ports:
      - "7077:7077"
      - "8080:8080"
    environment:
      - INIT_DAEMON_STEP=setup_spark
      - CORE_CONF_fs_defaultFS=hdfs://hadoop-namenode:8020
    depends_on:
      - hadoop-namenode
    networks:
      - hadoop-network

  spark-worker:
    image: bde2020/spark-worker:3.1.1-hadoop3.2
    container_name: spark-worker
    depends_on:
      - spark-master
      - hadoop-namenode
    environment:
      - SPARK_MASTER=spark://spark-master:7077
      - CORE_CONF_fs_defaultFS=hdfs://hadoop-namenode:8020
    ports:
      - "8081:8081"
    networks:
      - hadoop-network

  hive-server:
    image: bde2020/hive:2.3.2-postgresql-metastore
    container_name: hive-server
    depends_on:
      - hadoop-namenode
      - hadoop-datanode-1
      - hadoop-datanode-2
      - hadoop-datanode-3
      - postgres
    ports:
      - "10000:10000"
      - "10002:10002"
    environment:
      - CORE_CONF_fs_defaultFS=hdfs://hadoop-namenode:8020
      - HIVE_METASTORE_DB_TYPE=postgres
      - HIVE_DB=metastore
      - HIVE_DB_USERNAME=admin
      - HIVE_DB_PASSWORD=admin
      - HIVE_JDBC_URL=jdbc:postgresql://postgres:5432/metastore
    ulimits:
      nofile:
        soft: 65536
        hard: 65536
    networks:
      - hadoop-network

  jupyter:
    image: jupyter/pyspark-notebook:latest
    container_name: jupyter
    restart: always
    ports:
      - "8888:8888"
      - "4040:4040"
    environment:
      - JUPYTER_ENABLE_LAB=yes
      - SPARK_OPTS=--driver-java-options=-Xms1024M --driver-java-options=-Xmx4096M --driver-java-options=-Dlog4j.log4j.configuration=file:/usr/local/spark/conf/log4j.properties
    volumes:
      - ./notebooks:/home/jovyan/work
      - ./Etapa 1:/home/jovyan/work/data
    depends_on:
      - postgres
      - spark-master
      - spark-worker
      - hadoop-namenode
    command: start.sh jupyter lab --LabApp.token='' --LabApp.password='' --ip=0.0.0.0 --port=8888 --allow-root --no-browser
    networks:
      - hadoop-network

networks:
  hadoop-network:
    driver: bridge

volumes:
  pgdata:
  hadoop_namenode:
  hadoop_datanode_1:
  hadoop_datanode_2:
  hadoop_datanode_3:
```

## 🚀 Despliegue del Cluster

### 1. Limpiar Instalaciones Previas (si existen)

```bash
# Detener y eliminar contenedores existentes
sudo docker-compose down --volumes --remove-orphans

# Eliminar imágenes (opcional, para limpiar completamente)
sudo docker system prune -a --volumes
```

### 2. Descargar Imágenes

```bash
# Descargar todas las imágenes necesarias
sudo docker-compose pull

# Verificar que las imágenes se descargaron
sudo docker images | grep -E "(hadoop|spark|hive|jupyter|postgres)"
```

### 3. Levantar el Cluster

```bash
# Levantar todos los servicios
sudo docker-compose up -d

# Verificar que todos los contenedores estén corriendo
sudo docker-compose ps
```

### 4. Verificar Estado de los Servicios

```bash
# Esperar 2-3 minutos para que todos los servicios se inicialicen
sleep 180

# Verificar estado de todos los contenedores
sudo docker-compose ps

# Todos deben mostrar "Up" y "healthy" (excepto hive-server que puede tardar más)
```

## ✅ Verificación del Cluster

### 1. Verificar Hadoop Cluster

```bash
# Verificar que el namenode esté funcionando
sudo docker exec hadoop-namenode hdfs dfsadmin -report | grep -E "Live datanodes|Dead datanodes"

# Debe mostrar: "Live datanodes (3):"

# Verificar que el namenode no esté en modo seguro
sudo docker exec hadoop-namenode hdfs dfsadmin -safemode get

# Debe mostrar: "Safe mode is OFF"
```

### 2. Verificar HDFS

```bash
# Crear directorio para Hive
sudo docker exec hadoop-namenode hdfs dfs -mkdir -p /user/hive/warehouse

# Dar permisos
sudo docker exec hadoop-namenode hdfs dfs -chmod -R 777 /user/hive/warehouse

# Verificar que se creó correctamente
sudo docker exec hadoop-namenode hdfs dfs -ls /user/hive/
```

### 3. Verificar PostgreSQL

```bash
# Verificar que PostgreSQL esté funcionando
sudo docker exec postgres pg_isready -U admin

# Crear base de datos metastore para Hive
sudo docker exec postgres psql -U admin -d educacionit -c "CREATE DATABASE metastore;"

# Verificar que se creó
sudo docker exec postgres psql -U admin -l | grep metastore
```

### 4. Verificar Hive

```bash
# Esperar 2-3 minutos adicionales para que Hive se inicialice completamente
sleep 180

# Verificar que HiveServer2 esté ejecutándose
sudo docker exec hive-server ps aux | grep -i hiveserver2

# Verificar conectividad a HDFS desde Hive
sudo docker exec hive-server hdfs dfs -ls /

# Verificar que Hive pueda conectarse a PostgreSQL
sudo docker exec hive-server ping -c 1 postgres
```

### 5. Verificar Spark

```bash
# Verificar que Spark Master esté funcionando
curl -s http://localhost:8080 | grep -i "Spark" || echo "Spark Master funcionando"

# Verificar que Spark Worker esté conectado
curl -s http://localhost:8081 | grep -i "Worker" || echo "Spark Worker funcionando"
```

### 6. Verificar Jupyter

```bash
# Verificar que Jupyter esté funcionando
curl -s http://localhost:8888 | grep -i "jupyter" || echo "Jupyter funcionando"
```

## 🌐 Acceso a las Interfaces Web

### URLs de Acceso

1. **Hadoop Namenode UI**: http://localhost:9870
2. **Spark Master UI**: http://localhost:8080
3. **Spark Worker UI**: http://localhost:8081
4. **Jupyter Lab**: http://localhost:8888

### Conexiones de Base de Datos

#### PostgreSQL (DBeaver)
- **Host**: localhost
- **Puerto**: 5432
- **Base de datos**: educacionit
- **Usuario**: admin
- **Contraseña**: admin

#### Hive (DBeaver)
- **Tipo**: Apache Hive
- **Host**: localhost
- **Puerto**: 10000
- **Base de datos**: default
- **Sin autenticación**

## 🔧 Scripts de Configuración

### 1. Script de Creación de Tablas Hive

Crear archivo `scripts/hive/create_tables.hql`:

```sql
-- Crear base de datos
CREATE DATABASE IF NOT EXISTS retail;
USE retail;

-- Tabla de Clientes
CREATE TABLE IF NOT EXISTS clientes (
    id_cliente INT,
    nombre STRING,
    email STRING,
    telefono STRING,
    direccion STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- Tabla de Productos
CREATE TABLE IF NOT EXISTS productos (
    id_producto INT,
    nombre STRING,
    precio DECIMAL(10,2),
    categoria STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- Tabla de Ventas
CREATE TABLE IF NOT EXISTS ventas (
    id_venta INT,
    id_cliente INT,
    id_producto INT,
    cantidad INT,
    monto_total DECIMAL(10,2),
    fecha_venta DATE
)
PARTITIONED BY (anio INT, mes INT)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',';
```

### 2. Script de Carga de Datos

Crear archivo `scripts/hive/load_data.hql`:

```sql
-- Usar la base de datos
USE retail;

-- Habilitar particiones dinámicas
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;

-- Cargar datos de clientes
LOAD DATA LOCAL INPATH '/data/Clientes.csv' 
OVERWRITE INTO TABLE clientes;

-- Cargar datos de productos
LOAD DATA LOCAL INPATH '/data/PRODUCTOS.csv' 
OVERWRITE INTO TABLE productos;

-- Crear tabla temporal para ventas
CREATE TABLE IF NOT EXISTS temp_ventas (
    id_venta INT,
    id_cliente INT,
    id_producto INT,
    cantidad INT,
    monto_total DECIMAL(10,2),
    fecha_venta DATE
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
    id_cliente,
    id_producto,
    cantidad,
    monto_total,
    fecha_venta,
    YEAR(fecha_venta) as anio,
    MONTH(fecha_venta) as mes
FROM temp_ventas;

-- Limpiar tabla temporal
DROP TABLE temp_ventas;
```

## 🧪 Pruebas de Funcionamiento

### 1. Probar HDFS

```bash
# Crear archivo de prueba
echo "Hello Hadoop" > test.txt

# Subir archivo a HDFS
sudo docker exec hadoop-namenode hdfs dfs -put test.txt /

# Verificar que se subió
sudo docker exec hadoop-namenode hdfs dfs -ls /

# Leer archivo
sudo docker exec hadoop-namenode hdfs dfs -cat /test.txt
```

### 2. Probar Hive

```bash
# Conectar a Hive y crear tabla de prueba
sudo docker exec hive-server beeline -u jdbc:hive2://localhost:10000 -e "
CREATE TABLE test_table (id INT, name STRING);
INSERT INTO test_table VALUES (1, 'test');
SELECT * FROM test_table;
"
```

### 3. Probar Spark

```bash
# Conectar a Spark y ejecutar job de prueba
sudo docker exec spark-master spark-submit --class org.apache.spark.examples.SparkPi \
  --master spark://spark-master:7077 \
  /opt/spark/examples/jars/spark-examples_2.12-3.1.1.jar 10
```

## 🚨 Solución de Problemas Comunes

### 1. Error: "Connection refused" en Hive

```bash
# Verificar que el namenode esté funcionando
sudo docker exec hadoop-namenode hdfs dfsadmin -report

# Verificar conectividad desde Hive
sudo docker exec hive-server ping -c 1 hadoop-namenode

# Reiniciar Hive
sudo docker-compose restart hive-server
```

### 2. Error: "Port already in use"

```bash
# Verificar qué está usando el puerto
sudo netstat -tlnp | grep :5432  # Para PostgreSQL
sudo netstat -tlnp | grep :9870  # Para Hadoop

# Detener servicios que puedan estar usando los puertos
sudo systemctl stop postgresql  # Si está instalado localmente
```

### 3. Error: "Out of memory"

```bash
# Verificar uso de memoria
free -h

# Reducir memoria asignada a Jupyter en docker-compose.yaml
# Cambiar -Xmx4096M por -Xmx2048M
```

### 4. Error: "Permission denied"

```bash
# Verificar permisos de Docker
sudo usermod -aG docker $USER
newgrp docker

# Verificar permisos de archivos
ls -la docker-compose.yaml
```

### 5. Error: "Container health check failed"

```bash
# Verificar logs del contenedor
sudo docker logs <container_name>

# Reiniciar el contenedor específico
sudo docker-compose restart <service_name>
```

## 📊 Monitoreo del Cluster

### 1. Comandos Útiles

```bash
# Ver estado de todos los servicios
sudo docker-compose ps

# Ver logs de un servicio específico
sudo docker-compose logs <service_name>

# Ver uso de recursos
sudo docker stats

# Ver redes Docker
sudo docker network ls
```

### 2. Verificación Periódica

```bash
# Script de verificación rápida
#!/bin/bash
echo "=== Estado del Cluster ==="
sudo docker-compose ps
echo ""
echo "=== Hadoop Cluster ==="
sudo docker exec hadoop-namenode hdfs dfsadmin -report | grep "Live datanodes"
echo ""
echo "=== Hive Status ==="
sudo docker exec hive-server ps aux | grep -i hiveserver2
echo ""
echo "=== Spark Status ==="
curl -s http://localhost:8080 | grep -i "Spark" || echo "Spark Master OK"
```

## 🔄 Mantenimiento

### 1. Reiniciar Servicios

```bash
# Reiniciar todo el cluster
sudo docker-compose restart

# Reiniciar servicio específico
sudo docker-compose restart <service_name>
```

### 2. Actualizar Configuración

```bash
# Detener servicios
sudo docker-compose down

# Editar docker-compose.yaml
nano docker-compose.yaml

# Levantar servicios
sudo docker-compose up -d
```

### 3. Limpiar Datos

```bash
# Detener y eliminar volúmenes
sudo docker-compose down --volumes

# Eliminar imágenes
sudo docker system prune -a

# Levantar de nuevo
sudo docker-compose up -d
```

## 📝 Notas Importantes

1. **Primera ejecución**: La primera vez que se ejecute, puede tardar 10-15 minutos en descargar todas las imágenes.

2. **Memoria**: Asegúrate de tener suficiente RAM disponible (mínimo 8GB).

3. **Puertos**: Verifica que los puertos 5432, 9870, 7077, 8080, 8081, 8888, 10000 no estén en uso.

4. **Red**: Todos los servicios están en la red `hadoop-network` para comunicación interna.

5. **Persistencia**: Los datos se mantienen en volúmenes Docker, por lo que sobreviven a reinicios.

6. **Logs**: Siempre revisa los logs si algo no funciona: `sudo docker-compose logs <service_name>`.

## ✅ Checklist de Verificación

- [ ] Docker instalado y funcionando
- [ ] Docker Compose instalado
- [ ] Límites del sistema configurados
- [ ] Estructura de directorios creada
- [ ] docker-compose.yaml creado
- [ ] Todos los contenedores corriendo
- [ ] Hadoop cluster con 3 datanodes activos
- [ ] PostgreSQL funcionando
- [ ] Base de datos metastore creada
- [ ] Hive conectado a HDFS y PostgreSQL
- [ ] Spark Master y Worker funcionando
- [ ] Jupyter Lab accesible
- [ ] Todas las interfaces web funcionando
- [ ] Conexiones de base de datos probadas

## 🎯 Próximos Pasos

Una vez que el cluster esté funcionando correctamente:

1. **Cargar datos**: Usar los scripts HQL para cargar los datos CSV
2. **Crear notebooks**: Desarrollar análisis en Jupyter
3. **Configurar DBeaver**: Conectar a PostgreSQL y Hive
4. **Realizar consultas**: Probar consultas SQL en ambos sistemas
5. **Análisis de datos**: Comenzar con los ejercicios de calidad de datos

---

**¡El cluster está listo para usar! 🎉** 