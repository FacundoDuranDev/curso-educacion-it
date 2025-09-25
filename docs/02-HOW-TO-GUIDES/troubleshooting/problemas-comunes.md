# 🚨 TROUBLESHOOTING - PROBLEMAS COMUNES

## 🎯 **GUÍA RÁPIDA DE SOLUCIONES**

### **⚡ PROBLEMA MÁS COMÚN:**
```bash
# Error: "repository does not exist or may require docker login"
# SOLUCIÓN INMEDIATA:
make
```

---

## 🔧 **PROBLEMAS DE INSTALACIÓN**

### **❌ Error: "repository does not exist"**

**🔍 Síntomas:**
```
pull access denied for hadoop-hive-spark-master, repository does not exist or may require 'docker login'
```

**✅ SOLUCIÓN:**
```bash
# Las imágenes se construyen localmente, no se descargan
make build    # Construye todas las imágenes
make up       # Levanta los servicios
# O simplemente:
make          # Hace ambos pasos
```

**⏱️ Tiempo:** 15-20 minutos primera vez

---

### **❌ Error: "make: command not found"**

**🔍 En Windows:**
```bash
# Instalar make para Windows
# Opción 1: Chocolatey
choco install make

# Opción 2: Manual
docker build -t hadoop-hive-spark-base ./base
docker build -t hadoop-hive-spark-master ./master
docker build -t hadoop-hive-spark-worker ./worker
docker build -t hadoop-hive-spark-history ./history
docker build -t hadoop-hive-spark-jupyter ./jupyter
docker build -t hadoop-hive-spark-jupyterlab ./jupyterlab
docker-compose up -d
```

**🔍 En Linux/Mac:**
```bash
# Instalar make
sudo apt install make  # Ubuntu/Debian
brew install make      # macOS
```

---

### **❌ Error: "docker-compose: command not found"**

**✅ SOLUCIÓN:**
```bash
# Docker Compose v2 (recomendado)
docker compose up -d

# O instalar docker-compose clásico
pip install docker-compose
```

---

## 🐳 **PROBLEMAS DE DOCKER**

### **❌ Contenedores no inician**

**🔍 Verificar estado:**
```bash
docker-compose ps
```

**✅ SOLUCIONES:**

#### **1. Puertos ocupados:**
```bash
# Ver qué usa el puerto 5432
lsof -i :5432
netstat -tulpn | grep 5432

# Detener servicio que ocupa puerto
sudo systemctl stop postgresql  # Si PostgreSQL local está corriendo
```

#### **2. Falta de memoria:**
```bash
# Ver uso de memoria
docker system df
docker system prune  # Limpiar espacio

# Aumentar memoria Docker (Docker Desktop)
# Settings → Resources → Memory → 8GB+
```

#### **3. Permisos:**
```bash
# En Linux, agregar usuario a grupo docker
sudo usermod -aG docker $USER
# Cerrar sesión y volver a entrar
```

---

### **❌ Contenedor se reinicia constantemente**

**🔍 Ver logs:**
```bash
docker-compose logs [servicio]
# Ejemplos:
docker-compose logs master
docker-compose logs metastore
```

**✅ SOLUCIONES COMUNES:**

#### **1. PostgreSQL no inicia:**
```bash
# Limpiar datos corruptos
docker-compose down
docker volume rm curso-educacion-it_postgres_data
docker-compose up -d
```

#### **2. Hadoop/Spark problemas:**
```bash
# Recrear contenedores
docker-compose down
docker-compose up -d --force-recreate
```

---

## 🗄️ **PROBLEMAS DE BASE DE DATOS**

### **❌ "Connection refused" PostgreSQL**

**🔍 Verificar:**
```bash
# ¿Está corriendo el contenedor?
docker ps | grep metastore

# ¿Responde el puerto?
telnet localhost 5432
```

**✅ SOLUCIONES:**

#### **1. Contenedor no está corriendo:**
```bash
docker-compose up -d metastore
docker-compose logs metastore
```

#### **2. Base de datos no existe:**
```bash
# Crear base educacionit
docker exec -it educacionit-metastore-1 psql -U postgres -c "CREATE DATABASE educacionit;"

# Crear usuario admin
docker exec -it educacionit-metastore-1 psql -U postgres -c "
CREATE USER admin WITH PASSWORD 'admin123';
GRANT ALL PRIVILEGES ON DATABASE educacionit TO admin;
"
```

#### **3. Credenciales incorrectas:**
Ver: `docs/04-REFERENCE/credenciales.md`

---

### **❌ "Access denied" en PostgreSQL**

**🔍 Síntomas:**
```
FATAL: password authentication failed for user "admin"
```

**✅ SOLUCIÓN:**
```bash
# Recrear usuario admin
docker exec -it educacionit-metastore-1 psql -U postgres -c "
DROP USER IF EXISTS admin;
CREATE USER admin WITH PASSWORD 'admin123';
GRANT ALL PRIVILEGES ON DATABASE educacionit TO admin;
"

# Verificar conexión
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "SELECT 'OK' as test;"
```

---

## 📓 **PROBLEMAS DE JUPYTER**

### **❌ Jupyter no carga**

**🔍 Verificar:**
```bash
curl http://localhost:8888
docker-compose logs jupyter
```

**✅ SOLUCIONES:**

#### **1. Puerto ocupado:**
```bash
# Ver qué usa el puerto 8888
lsof -i :8888

# Cambiar puerto en docker-compose.yml si es necesario
# "8889:8888" en lugar de "8888:8888"
```

#### **2. Contenedor no inicia:**
```bash
docker-compose restart jupyter
docker-compose logs jupyter
```

#### **3. Sin token pero pide password:**
```bash
# Ver logs para encontrar token
docker-compose logs jupyter | grep token

# O acceder sin token (configurado así por defecto)
# http://localhost:8888
```

---

## ⚡ **PROBLEMAS DE SPARK**

### **❌ Spark Master no accesible**

**🔍 Verificar:**
```bash
curl http://localhost:8080
docker-compose logs master
```

**✅ SOLUCIONES:**

#### **1. Master no inicia:**
```bash
# Ver logs detallados
docker exec -it educacionit-master-1 cat /opt/spark/logs/spark-*.out

# Reiniciar servicios Hadoop/Spark
docker exec -it educacionit-master-1 /opt/hadoop/sbin/start-all.sh
docker exec -it educacionit-master-1 /opt/spark/sbin/start-master.sh
```

#### **2. Workers no se conectan:**
```bash
# Ver logs de workers
docker-compose logs worker1
docker-compose logs worker2

# Reiniciar workers
docker-compose restart worker1 worker2
```

---

### **❌ Jobs de Spark fallan**

**🔍 Síntomas:**
```bash
# Error común: executor memory
"Container killed on request. Exit code is 137"
```

**✅ SOLUCIONES:**

#### **1. Memoria insuficiente:**
```bash
# Verificar configuración actual
docker exec -it educacionit-master-1 cat /opt/spark/conf/spark-defaults.conf

# Los executors ya están configurados con 800m-1g
# Si sigue fallando, verificar memoria disponible:
docker stats
```

#### **2. HDFS no disponible:**
```bash
# Verificar HDFS
docker exec -it educacionit-master-1 hdfs dfsadmin -report

# Reiniciar HDFS si es necesario
docker exec -it educacionit-master-1 /opt/hadoop/sbin/stop-dfs.sh
docker exec -it educacionit-master-1 /opt/hadoop/sbin/start-dfs.sh
```

---

## 🔥 **PROBLEMAS DE HBASE/CASSANDRA**

### **❌ HBase no inicia**

**🔍 Verificar:**
```bash
curl http://localhost:16010
docker-compose logs hbase
```

**✅ SOLUCIÓN:**
```bash
# Reiniciar HBase
docker-compose restart hbase
docker-compose logs hbase
```

### **❌ Cassandra no responde**

**🔍 Verificar:**
```bash
docker exec -it educacionit-cassandra-1 cqlsh -e "DESCRIBE KEYSPACES;"
```

**✅ SOLUCIÓN:**
```bash
# Cassandra tarda en iniciar (2-3 minutos)
docker-compose logs cassandra

# Si no inicia, recrear
docker-compose restart cassandra
```

---

## 🛠️ **COMANDOS DE DIAGNÓSTICO**

### **🔍 Verificación Completa:**
```bash
# Estado de todos los servicios
docker-compose ps

# Uso de recursos
docker stats --no-stream

# Espacio en disco
docker system df

# Logs generales
docker-compose logs --tail=50

# Verificar puertos
netstat -tulpn | grep -E "(5432|8888|8080|9870|8088)"
```

### **🧹 Limpieza Completa:**
```bash
# ⚠️ CUIDADO: Esto borra TODOS los datos
docker-compose down
docker system prune -a
docker volume prune
make  # Reconstruir todo
```

---

## 🆘 **SCRIPT DE VERIFICACIÓN AUTOMÁTICA**

```bash
#!/bin/bash
# Guardar como verificar_sistema.sh

echo "🔍 VERIFICANDO SISTEMA..."

# 1. Docker
if docker --version > /dev/null 2>&1; then
    echo "✅ Docker instalado"
else
    echo "❌ Docker no instalado"
    exit 1
fi

# 2. Docker Compose
if docker-compose --version > /dev/null 2>&1; then
    echo "✅ Docker Compose instalado"
else
    echo "❌ Docker Compose no instalado"
fi

# 3. Servicios corriendo
echo "📊 Estado de servicios:"
docker-compose ps

# 4. Puertos
echo "🌐 Verificando puertos:"
for port in 5432 8888 8080 9870; do
    if curl -s localhost:$port > /dev/null; then
        echo "✅ Puerto $port OK"
    else
        echo "❌ Puerto $port no responde"
    fi
done

# 5. PostgreSQL
if docker exec educacionit-metastore-1 psql -U postgres -c "SELECT 1;" > /dev/null 2>&1; then
    echo "✅ PostgreSQL OK"
else
    echo "❌ PostgreSQL Error"
fi

echo "🎯 Verificación completada"
```

---

## 📞 **¿NECESITAS MÁS AYUDA?**

### **🎯 RECURSOS ADICIONALES:**
- **Credenciales**: `../04-REFERENCE/credenciales.md`
- **Instalación**: `../01-GETTING-STARTED/instalacion-rapida.md`
- **PostgreSQL**: `../postgresql/`
- **Hadoop/Spark**: `../hadoop-spark/`

### **🚨 SOPORTE DE EMERGENCIA:**
Si nada funciona, el "reset completo":
```bash
docker-compose down
docker system prune -a -f
docker volume prune -f
git pull  # Si hay actualizaciones
make      # Reconstruir todo
```

**⏱️ Tiempo:** 20-30 minutos
**✅ Resultado:** Sistema completamente limpio y funcional

---

**🎯 Con esta guía deberías poder resolver el 95% de los problemas comunes!**
