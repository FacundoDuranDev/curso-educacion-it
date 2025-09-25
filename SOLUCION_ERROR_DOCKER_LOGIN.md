# 🚨 SOLUCIÓN: Error "repository does not exist or may require docker login"

## 📋 PROBLEMA IDENTIFICADO

**Error típico que ve el alumno:**
```
ERROR: pull access denied for hadoop-hive-spark-master, repository does not exist or may require 'docker login'
```

## 🔍 CAUSA DEL PROBLEMA

Este error ocurre porque el archivo `docker-compose.yml` está intentando descargar imágenes Docker que **NO EXISTEN** en Docker Hub. Estas imágenes son **locales** y deben **construirse primero** en tu máquina usando el `Makefile`.

### ❌ IMÁGENES QUE NO EXISTEN EN DOCKER HUB:
- `hadoop-hive-spark-master`
- `hadoop-hive-spark-worker` 
- `hadoop-hive-spark-history`
- `hadoop-hive-spark-jupyter`
- `hadoop-hive-spark-jupyterlab`

Estas imágenes se crean **localmente** a partir de los `Dockerfile` en cada carpeta.

## ✅ SOLUCIÓN PASO A PASO

### **Paso 1: Verificar que tienes Docker instalado**
```bash
docker --version
docker-compose --version
```

**Salida esperada:**
```
Docker version 20.10.x o superior
Docker Compose version 2.x.x o superior
```

### **Paso 2: Navegar al directorio del proyecto**
```bash
cd /ruta/a/tu/proyecto/curso-educacion-it
```

### **Paso 3: CONSTRUIR las imágenes Docker PRIMERO** ⚠️ **MUY IMPORTANTE**
```bash
make build
```

**¿Qué hace este comando?**
- Construye la imagen base: `hadoop-hive-spark-base`
- Construye la imagen master: `hadoop-hive-spark-master`  
- Construye la imagen worker: `hadoop-hive-spark-worker`
- Construye la imagen history: `hadoop-hive-spark-history`
- Construye la imagen jupyter: `hadoop-hive-spark-jupyter`
- Construye la imagen jupyterlab: `hadoop-hive-spark-jupyterlab`

**⏰ TIEMPO ESTIMADO:** 15-20 minutos (primera vez)

### **Paso 4: Verificar que las imágenes se crearon**
```bash
docker images | grep hadoop-hive-spark
```

**Salida esperada:**
```
hadoop-hive-spark-jupyterlab    latest    abc123    5 minutes ago    2.1GB
hadoop-hive-spark-jupyter       latest    def456    6 minutes ago    2.0GB  
hadoop-hive-spark-history       latest    ghi789    7 minutes ago    1.8GB
hadoop-hive-spark-worker        latest    jkl012    8 minutes ago    1.8GB
hadoop-hive-spark-master        latest    mno345    9 minutes ago    1.8GB
hadoop-hive-spark-base          latest    pqr678    10 minutes ago   1.7GB
```

### **Paso 5: Ahora SÍ levantar los servicios**
```bash
docker-compose up -d
```

## 🚀 MÉTODO AUTOMÁTICO (RECOMENDADO)

**En lugar de hacer los pasos 3, 4 y 5 por separado, puedes usar:**

```bash
make
```

Este comando hace **TODO AUTOMÁTICAMENTE**:
1. ✅ Construye todas las imágenes (`make build`)
2. ✅ Levanta todos los servicios (`make up`)
3. ✅ Verifica el estado (`make status`)
4. ✅ Muestra las URLs de acceso

## 🔧 COMANDOS ÚTILES PARA GESTIONAR EL ENTORNO

```bash
# Ver estado de todos los servicios
make status

# Detener todos los servicios
make down

# Limpiar todas las imágenes (para empezar desde cero)
make clean

# Ver ayuda completa
make help
```

## ⚠️ ERRORES COMUNES Y SOLUCIONES

### **Error 1: "make: command not found"**
**En Windows:**
```bash
# Instalar make para Windows
choco install make
# O usar Git Bash que incluye make
```

**En macOS:**
```bash
# Instalar Xcode Command Line Tools
xcode-select --install
```

**En Linux (Ubuntu/Debian):**
```bash
sudo apt-get update
sudo apt-get install build-essential
```

### **Error 2: "docker: permission denied"**
```bash
# Agregar tu usuario al grupo docker
sudo usermod -aG docker $USER

# Reiniciar sesión o ejecutar:
newgrp docker
```

### **Error 3: "No space left on device"**
```bash
# Limpiar imágenes Docker no utilizadas
docker system prune -a

# Ver uso de espacio
docker system df
```

### **Error 4: Puerto ya en uso**
```bash
# Ver qué proceso está usando el puerto (ejemplo puerto 8888)
sudo netstat -tlnp | grep 8888

# Detener el proceso que usa el puerto
sudo kill -9 [PID]
```

## 📊 VERIFICACIÓN DE FUNCIONAMIENTO

### **Después de ejecutar `make`, deberías poder acceder a:**

- **🗄️ PostgreSQL**: `localhost:5432`
- **📊 HDFS Web UI**: http://localhost:9870
- **⚡ Spark Master**: http://localhost:8080  
- **📓 Jupyter Notebook**: http://localhost:8888
- **🔬 JupyterLab**: http://localhost:8890
- **📈 Spark History**: http://localhost:18080
- **🎯 YARN ResourceManager**: http://localhost:8088

### **Comando para verificar que todo funciona:**
```bash
make status
```

**Salida esperada (todos en estado "running"):**
```
📊 Estado de los servicios:
NAME                    COMMAND                  SERVICE       STATUS    PORTS
educacionit-master-1    "entrypoint.sh run.sh"   master       running   0.0.0.0:8020->8020/tcp
educacionit-worker1-1   "entrypoint.sh run.sh"   worker1      running   0.0.0.0:8042->8042/tcp
educacionit-metastore-1 "docker-entrypoint.s…"   metastore    running   0.0.0.0:5432->5432/tcp
```

## 🎯 RESUMEN PARA EL ALUMNO

**El problema NO es de autenticación en Docker Hub, sino que:**

1. ❌ **NUNCA** ejecutes `docker-compose up -d` directamente
2. ✅ **SIEMPRE** ejecuta `make` primero (o `make build` + `docker-compose up -d`)
3. ✅ Las imágenes se construyen **localmente**, no se descargan

**Comando mágico que soluciona todo:**
```bash
make
```

## 📞 ¿NECESITAS MÁS AYUDA?

Si después de seguir estos pasos sigues teniendo problemas:

1. **Ejecuta:** `make clean` (limpia todo)
2. **Ejecuta:** `make` (reconstruye todo)
3. **Comparte el error exacto** que aparece en la terminal

**¡Éxito garantizado siguiendo estos pasos!** 🎉



