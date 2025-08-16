# ⚡ Comandos Rápidos - Data Engineering

## 🚀 **LEVANTAR TODO (UN SOLO COMANDO)**
```bash
./start.sh
```

## 📊 **Ver Estado de Servicios**
```bash
# Ver todos los contenedores corriendo
docker-compose ps

# Ver logs de un servicio específico
docker-compose logs postgres
docker-compose logs hive-server
docker-compose logs jupyter

# Ver logs en tiempo real
docker-compose logs -f
```

## 🔄 **Control de Servicios**
```bash
# Parar todo
docker-compose down

# Reiniciar todo
docker-compose restart

# Reiniciar un servicio específico
docker-compose restart hive-server

# Levantar solo algunos servicios
docker-compose up -d postgres hadoop-namenode
```

## 🌐 **Acceso a Interfaces Web**
```bash
# Jupyter Lab (Entorno de desarrollo)
http://localhost:8888

# Spark Master (Interfaz de Spark)
http://localhost:8080

# Hadoop HDFS (Sistema de archivos)
http://localhost:9870

# Spark Worker
http://localhost:8081
```

## 🗄️ **Base de Datos PostgreSQL**
```bash
# Conectar a PostgreSQL
psql -h localhost -p 5432 -U admin -d educacionit

# Credenciales:
# Host: localhost
# Puerto: 5432
# Usuario: admin
# Contraseña: admin
# Base de datos: educacionit

# Ejecutar script SQL
psql -h localhost -p 5432 -U admin -d educacionit -f scripts/ejercicios_clase.sql
```

## 🔍 **Diagnóstico y Troubleshooting**
```bash
# Ver uso de recursos
docker stats

# Ver espacio en disco
docker system df

# Limpiar recursos no utilizados
docker system prune -f

# Ver redes Docker
docker network ls

# Ver volúmenes
docker volume ls
```

## 📁 **Acceso a Contenedores**
```bash
# Entrar al contenedor de Jupyter
docker exec -it jupyter bash

# Entrar al contenedor de PostgreSQL
docker exec -it postgres psql -U admin -d educacionit

# Entrar al contenedor de Hive
docker exec -it hive-server /opt/hive/bin/beeline -u jdbc:hive2://localhost:10000 -n root

# Entrar al contenedor de Spark
docker exec -it spark-master bash
```

## 🐍 **Python y Jupyter**
```bash
# Instalar paquetes en Jupyter
pip install pandas numpy matplotlib seaborn

# Ejecutar notebook desde línea de comandos
jupyter nbconvert --to notebook --execute 01_introduccion_data_engineering.ipynb

# Ver kernels disponibles
jupyter kernelspec list
```

## 🔥 **Apache Spark**
```bash
# Conectar a Spark desde Python
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("DataEngineering") \
    .master("spark://spark-master:7077") \
    .getOrCreate()

# Ver aplicaciones Spark
http://localhost:8080

# Ver logs de Spark
docker-compose logs spark-master
docker-compose logs spark-worker
```

## 📊 **Hadoop HDFS**
```bash
# Ver estado de HDFS
http://localhost:9870

# Comandos HDFS (desde contenedor)
docker exec -it hadoop-namenode hdfs dfs -ls /

# Crear directorio en HDFS
docker exec -it hadoop-namenode hdfs dfs -mkdir /user/hive/warehouse

# Ver logs de HDFS
docker-compose logs hadoop-namenode
docker-compose logs hadoop-datanode
```

## 🐝 **Apache Hive**
```bash
# Conectar a Hive
docker exec -it hive-server /opt/hive/bin/beeline -u jdbc:hive2://localhost:10000 -n root

# Ejemplos de comandos Hive:
SHOW DATABASES;
CREATE DATABASE IF NOT EXISTS educacionit;
USE educacionit;
SHOW TABLES;
```

## 🧹 **Limpieza y Mantenimiento**
```bash
# Parar y limpiar todo
docker-compose down --volumes --remove-orphans

# Eliminar todas las imágenes
docker rmi $(docker images -q)

# Limpiar todo Docker
docker system prune -a -f

# Ver espacio liberado
docker system df
```

## 📝 **Scripts Útiles**
```bash
# Configurar base de datos
# Seguir la GUIA_INSTALACION_POSTGRESQL.md para configurar la base de datos

# Ejecutar ejercicios
./scripts/ejercicios_clase.sql

# Ver estructura del proyecto
tree -L 2
```

## 🆘 **Solución de Problemas Comunes**

### **❌ Puerto ocupado**
```bash
# Ver qué está usando el puerto
netstat -tulpn | grep :8888

# Matar proceso
sudo kill -9 <PID>
```

### **❌ Contenedor no inicia**
```bash
# Ver logs del contenedor
docker-compose logs <nombre-servicio>

# Verificar recursos
docker stats
```

### **❌ Error de memoria**
```bash
# Aumentar memoria en Docker Desktop
# Windows/macOS: Docker Desktop > Settings > Resources
# Linux: docker run --memory=8g
```

### **❌ Error de permisos**
```bash
# Dar permisos al script
chmod +x start.sh

# Verificar permisos de archivos
ls -la
```

---

## 🎯 **Para la Clase - Checklist Rápido**

1. ✅ **Docker Desktop** corriendo
2. ✅ **Repositorio** clonado
3. ✅ **Ejecutar**: `./start.sh`
4. ✅ **Esperar** 2-3 minutos
5. ✅ **Abrir**: http://localhost:8888
6. ✅ **¡Listo para programar!**

---

**💡 Tip**: Guarda este archivo como referencia rápida durante la clase! 