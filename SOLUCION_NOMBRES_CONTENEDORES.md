# 🚨 **SOLUCIÓN UNIVERSAL: Nombres de Contenedores Docker Compose**

## 🔍 **PROBLEMA IDENTIFICADO**

**Docker Compose v1** y **Docker Compose v2** generan nombres de contenedores **DIFERENTES**:

### **Docker Compose v2 (actual):**
- ✅ **Guiones medios**: `educacionit-metastore-1`
- ✅ **Guiones medios**: `educacionit-master-1`
- ✅ **Guiones medios**: `educacionit-worker1-1`

### **Docker Compose v1 (anterior):**
- ❌ **Guiones bajos**: `educacionit_metastore_1`
- ❌ **Guiones bajos**: `educacionit_master_1`
- ❌ **Guiones bajos**: `educacionit_worker1_1`

---

## 🔧 **SOLUCIONES DISPONIBLES**

### **Solución 1: Verificar y Actualizar Docker Compose**

```bash
# Verificar versión actual
docker-compose --version

# Si es v1, actualizar a v2
# En Ubuntu/Debian:
sudo apt update
sudo apt install docker-compose-plugin

# En CentOS/RHEL:
sudo yum install docker-compose-plugin

# En macOS con Homebrew:
brew install docker-compose

# En Windows: Actualizar Docker Desktop
```

### **Solución 2: Usar Nombres de Servicios (Recomendado)**

**En lugar de usar nombres de contenedores, usa nombres de servicios:**

```bash
# ❌ NO usar (puede fallar):
docker exec -it educacionit-metastore-1 psql -U postgres

# ✅ SÍ usar (siempre funciona):
docker-compose exec metastore psql -U postgres
```

**Ventajas:**
- ✅ **Funciona en ambas versiones**
- ✅ **Más corto y legible**
- ✅ **No depende de nombres de contenedores**

### **Solución 3: Script de Detección Automática**

Crear un script que detecte automáticamente la versión:

```bash
#!/bin/bash
# detect_container_names.sh

# Verificar versión de Docker Compose
COMPOSE_VERSION=$(docker-compose --version | grep -oE '[0-9]+\.[0-9]+' | head -1)

if [[ $(echo "$COMPOSE_VERSION >= 2.0" | bc -l) -eq 1 ]]; then
    echo "Docker Compose v2 detectado - usando guiones medios"
    METASTORE_CONTAINER="educacionit-metastore-1"
    MASTER_CONTAINER="educacionit-master-1"
    WORKER1_CONTAINER="educacionit-worker1-1"
else
    echo "Docker Compose v1 detectado - usando guiones bajos"
    METASTORE_CONTAINER="educacionit_metastore_1"
    MASTER_CONTAINER="educacionit_master_1"
    WORKER1_CONTAINER="educacionit_worker1_1"
fi

echo "Contenedor metastore: $METASTORE_CONTAINER"
echo "Contenedor master: $MASTER_CONTAINER"
echo "Contenedor worker1: $WORKER1_CONTAINER"
```

---

## 📋 **COMANDOS UNIVERSALES (Funcionan en ambas versiones)**

### **Base de Datos PostgreSQL:**
```bash
# Conectar a PostgreSQL
docker-compose exec metastore psql -U postgres

# Ver logs
docker-compose logs metastore

# Ejecutar script SQL
docker-compose exec -T metastore psql -U postgres -d educacionit < script.sql
```

### **Hadoop/Spark Master:**
```bash
# Entrar al contenedor
docker-compose exec master bash

# Ver logs
docker-compose logs master

# Comandos HDFS
docker-compose exec master hdfs dfs -ls /
```

### **Workers:**
```bash
# Ver logs de workers
docker-compose logs worker1
docker-compose logs worker2

# Entrar a worker1
docker-compose exec worker1 bash
```

### **Jupyter:**
```bash
# Ver logs
docker-compose logs jupyter

# Entrar al contenedor
docker-compose exec jupyter bash
```

---

## 🎯 **RECOMENDACIONES PARA ALUMNOS**

### **1. Siempre verificar la versión:**
```bash
docker-compose --version
```

### **2. Usar nombres de servicios en lugar de contenedores:**
```bash
# ✅ CORRECTO:
docker-compose exec metastore psql -U postgres

# ❌ INCORRECTO (puede fallar):
docker exec -it educacionit-metastore-1 psql -U postgres
```

### **3. Si algo falla, verificar nombres exactos:**
```bash
docker-compose ps
```

### **4. Para scripts, usar detección automática:**
```bash
# El script detect_container_names.sh maneja ambas versiones
./detect_container_names.sh
```

---

## 🆘 **TROUBLESHOOTING**

### **Error: "No such container"**
```bash
# Verificar nombres exactos
docker-compose ps

# Usar nombres de servicios en su lugar
docker-compose exec metastore psql -U postgres
```

### **Error: "Connection refused"**
```bash
# Verificar que los servicios estén corriendo
docker-compose ps

# Ver logs del servicio
docker-compose logs metastore
```

### **Error: "Permission denied"**
```bash
# Verificar permisos del directorio
ls -la

# Dar permisos de ejecución
chmod +x script.sh
```

---

## 📚 **REFERENCIAS**

- [Docker Compose v2 Migration Guide](https://docs.docker.com/compose/migrate/)
- [Docker Compose Command Reference](https://docs.docker.com/compose/reference/)
- [Docker Compose v1 vs v2 Differences](https://docs.docker.com/compose/compose-file/)

---

**💡 Tip**: La **Solución 2** (usar nombres de servicios) es la más robusta y recomendada para todos los casos.
