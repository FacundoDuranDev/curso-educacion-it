# 🐳 COMANDOS RÁPIDOS DOCKER

## 🚨 **IMPORTANTE: Diferencia en Nombres de Contenedores**

**Docker Compose v2 (actual - guiones medios):**
- `educacionit-metastore-1`
- `educacionit-master-1` 
- `educacionit-worker1-1`

**Docker Compose v1 (anterior - guiones bajos):**
- `educacionit_metastore_1`
- `educacionit_master_1` 
- `educacionit_worker1_1`

**🔍 Verificar tu versión:**
```bash
docker-compose --version
```

**💡 Tip**: Siempre usa `docker-compose ps` para ver los nombres exactos.

---

## 🚀 **LEVANTAR TODO (UN SOLO COMANDO)**
```bash
make
```

---

## 📊 **VER ESTADO DE SERVICIOS**
```bash
# Ver todos los contenedores corriendo
docker-compose ps

# Ver estado detallado
docker-compose ps --format table
```

---

## 🔧 **GESTIÓN DE CONTENEDORES**

### **Iniciar Servicios:**
```bash
# Levantar todo el entorno
make up

# Levantar servicios específicos
docker-compose up -d metastore    # Solo PostgreSQL
docker-compose up -d master       # Solo Hadoop/Spark Master
docker-compose up -d jupyter      # Solo Jupyter
```

### **Detener Servicios:**
```bash
# Detener todo
make down

# Detener servicios específicos
docker-compose stop metastore
docker-compose stop master
```

### **Reiniciar Servicios:**
```bash
# Reiniciar todo
docker-compose restart

# Reiniciar servicio específico
docker-compose restart metastore
```

---

## 📝 **VER LOGS**

### **Logs Generales:**
```bash
# Ver logs de todos los servicios
docker-compose logs

# Ver logs en tiempo real
docker-compose logs -f

# Ver logs de servicio específico
docker-compose logs metastore
docker-compose logs master
docker-compose logs jupyter
```

### **Logs Detallados:**
```bash
# Ver logs con timestamps
docker-compose logs -t

# Ver últimas 100 líneas
docker-compose logs --tail=100

# Ver logs de los últimos 10 minutos
docker-compose logs --since=10m
```

---

## 🔍 **DIAGNÓSTICO Y DEBUGGING**

### **Acceder a Contenedores:**
```bash
# Acceder al shell del contenedor
docker-compose exec metastore bash
docker-compose exec master bash
docker-compose exec jupyter bash

# Ejecutar comando específico
docker-compose exec metastore psql -U postgres -d educacionit
```

### **Ver Recursos:**
```bash
# Ver uso de recursos
docker stats

# Ver información detallada del contenedor
docker-compose exec metastore cat /etc/os-release
```

---

## 🗄️ **BASE DE DATOS POSTGRESQL**

### **Conectar a PostgreSQL:**
```bash
# Conectar desde contenedor
docker-compose exec metastore psql -U postgres -d educacionit

# Conectar desde host (si tienes psql instalado)
psql -h localhost -p 5432 -U postgres -d educacionit
```

### **Comandos Útiles PostgreSQL:**
```sql
-- Ver bases de datos
\l

-- Conectar a base específica
\c educacionit

-- Ver tablas
\dt

-- Ver estructura de tabla
\d clientes

-- Salir
\q
```

---

## ⚡ **SPARK Y HADOOP**

### **Verificar Spark:**
```bash
# Ver estado del cluster
docker-compose exec master spark-submit --version

# Ejecutar job de prueba
docker-compose exec master spark-submit --class org.apache.spark.examples.SparkPi /opt/spark/examples/jars/spark-examples_2.12-3.5.3.jar 10
```

### **Verificar HDFS:**
```bash
# Ver estado de HDFS
docker-compose exec master hdfs dfsadmin -report

# Listar archivos en HDFS
docker-compose exec master hdfs dfs -ls /

# Ver espacio disponible
docker-compose exec master hdfs dfs -df -h
```

---

## 🧹 **LIMPIEZA**

### **Limpieza Básica:**
```bash
# Detener y eliminar contenedores
docker-compose down

# Detener, eliminar contenedores y volúmenes
docker-compose down -v

# Eliminar imágenes no utilizadas
docker image prune
```

### **Limpieza Completa:**
```bash
# ⚠️ CUIDADO: Elimina TODO de Docker
docker system prune -a --volumes --force
```

---

## 🔧 **CONSTRUCCIÓN DE IMÁGENES**

### **Construir Imágenes:**
```bash
# Construir todas las imágenes
make build

# Construir imagen específica
docker-compose build master
docker-compose build worker
docker-compose build jupyter
```

### **Ver Imágenes:**
```bash
# Ver imágenes construidas
docker images | grep hadoop-hive-spark

# Ver tamaño de imágenes
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"
```

---

## 🌐 **ACCESO A SERVICIOS WEB**

### **URLs Importantes:**
- **Jupyter Notebook**: http://localhost:8888
- **JupyterLab**: http://localhost:8890
- **Spark Master**: http://localhost:8080
- **HDFS Web UI**: http://localhost:9870
- **YARN ResourceManager**: http://localhost:8088

### **Verificar Servicios:**
```bash
# Verificar que los puertos están abiertos
netstat -tulpn | grep :8888
netstat -tulpn | grep :8080
netstat -tulpn | grep :5432
```

---

## 🚨 **SOLUCIÓN DE PROBLEMAS COMUNES**

### **Problema: Puerto en uso**
```bash
# Ver qué usa el puerto
sudo lsof -i :8080

# Matar proceso que usa el puerto
sudo kill -9 PID
```

### **Problema: Contenedor no inicia**
```bash
# Ver logs detallados
docker-compose logs servicio

# Reconstruir imagen
docker-compose build servicio
docker-compose up -d servicio
```

### **Problema: Permisos**
```bash
# Cambiar permisos de archivos
sudo chown -R $USER:$USER .

# Cambiar permisos de Docker
sudo usermod -aG docker $USER
```

---

## 💡 **COMANDOS ÚTILES RÁPIDOS**

```bash
# Estado rápido
alias status='docker-compose ps'

# Logs rápidos
alias logs='docker-compose logs -f'

# Reinicio rápido
alias restart='docker-compose restart'

# Limpieza rápida
alias clean='docker-compose down && docker image prune -f'
```

---

**🎯 ¡Estos comandos te ayudarán a gestionar el entorno Docker del curso de manera eficiente!**
