# 🔧 Guía de Variables de Entorno - Data Engineering

## 📋 ¿Qué son las Variables de Entorno?

Las **variables de entorno** son configuraciones del sistema que definen cómo funcionan los programas y herramientas. Son esenciales para:
- 🐍 **Python** y sus librerías
- 🗄️ **Bases de datos** y conexiones
- 🐳 **Docker** y contenedores
- 🛠️ **Herramientas de desarrollo**

## 🚨 Problemas Comunes sin Variables de Entorno

### ❌ Errores típicos:
- `python: command not found`
- `pip: command not found`
- `Permission denied`
- `ModuleNotFoundError`
- `Connection refused`
- `Environment variable not set`

---

## 🐧 Variables de Entorno en Linux

### 📍 Ubicaciones de configuración:
```bash
# Archivos de configuración (en orden de prioridad)
~/.bashrc                    # Usuario específico
~/.bash_profile             # Login shell
~/.profile                  # Shell genérico
/etc/environment            # Sistema completo
/etc/profile                # Sistema (login)
```

### 🔧 Configuración básica en Linux:

#### 1. **PATH - Rutas de ejecutables**
```bash
# Agregar al ~/.bashrc
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/anaconda3/bin:$PATH"  # Si usas Anaconda
```

#### 2. **PYTHONPATH - Rutas de Python**
```bash
# Agregar al ~/.bashrc
export PYTHONPATH="${PYTHONPATH}:/usr/local/lib/python3.9/site-packages"
export PYTHONPATH="${PYTHONPATH}:$HOME/proyectos"
```

#### 3. **Variables para Data Engineering**
```bash
# Agregar al ~/.bashrc
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
export SPARK_HOME="/opt/spark"
export HADOOP_HOME="/opt/hadoop"
export PYSPARK_PYTHON="/usr/bin/python3"
export PYSPARK_DRIVER_PYTHON="/usr/bin/python3"
```

#### 4. **Variables de base de datos**
```bash
# PostgreSQL
export PGHOST="localhost"
export PGPORT="5432"
export PGUSER="admin"
export PGPASSWORD="admin"
export PGDATABASE="educacionit"

# MySQL
export MYSQL_HOST="localhost"
export MYSQL_PORT="3306"
export MYSQL_USER="root"
export MYSQL_PASSWORD="password"
export MYSQL_DATABASE="test"
```

### 🛠️ Comandos útiles en Linux:

#### **Ver variables actuales:**
```bash
# Ver todas las variables
env

# Ver variable específica
echo $PATH
echo $PYTHONPATH
echo $JAVA_HOME
```

#### **Agregar variable temporal:**
```bash
# Solo para la sesión actual
export VARIABLE="valor"

# Ejemplo
export PYTHONPATH="/nueva/ruta:$PYTHONPATH"
```

#### **Agregar variable permanente:**
```bash
# Editar ~/.bashrc
nano ~/.bashrc

# Agregar al final:
export VARIABLE="valor"

# Recargar configuración
source ~/.bashrc
```

---

## 🪟 Variables de Entorno en Windows

### 📍 Ubicaciones de configuración:
- **Panel de Control** → Sistema → Configuración avanzada del sistema
- **Variables de entorno** → Variables del sistema / Variables de usuario
- **Archivos**: `%USERPROFILE%\.bashrc` (si usas WSL)

### 🔧 Configuración en Windows:

#### 1. **PATH - Rutas de ejecutables**
```cmd
# Agregar al PATH del sistema
C:\Python39\
C:\Python39\Scripts\
C:\Users\%USERNAME%\AppData\Local\Programs\Python\Python39\
C:\Users\%USERNAME%\AppData\Local\Programs\Python\Python39\Scripts\
```

#### 2. **Variables para Python**
```cmd
# Variables del sistema
PYTHONPATH=C:\Python39\Lib\site-packages
PYTHONHOME=C:\Python39
```

#### 3. **Variables para Data Engineering**
```cmd
# Java
JAVA_HOME=C:\Program Files\Java\jdk-11.0.12

# Spark
SPARK_HOME=C:\spark
HADOOP_HOME=C:\hadoop

# Python para Spark
PYSPARK_PYTHON=python
PYSPARK_DRIVER_PYTHON=python
```

### 🛠️ Comandos útiles en Windows:

#### **Ver variables actuales:**
```cmd
# Ver todas las variables
set

# Ver variable específica
echo %PATH%
echo %PYTHONPATH%
echo %JAVA_HOME%
```

#### **Agregar variable temporal:**
```cmd
# Solo para la sesión actual
set VARIABLE=valor

# Ejemplo
set PYTHONPATH=C:\nueva\ruta;%PYTHONPATH%
```

#### **Agregar variable permanente (PowerShell):**
```powershell
# Agregar al PATH del usuario
[Environment]::SetEnvironmentVariable("PATH", $env:PATH + ";C:\nueva\ruta", "User")

# Agregar variable nueva
[Environment]::SetEnvironmentVariable("VARIABLE", "valor", "User")
```

---

## 🐧 WSL (Windows Subsystem for Linux)

### 🔧 Configuración específica para WSL:

#### 1. **Archivo de configuración WSL**
```bash
# Crear/editar ~/.bashrc en WSL
nano ~/.bashrc

# Agregar configuración
export PATH="$HOME/.local/bin:$PATH"
export PYTHONPATH="$HOME/.local/lib/python3.9/site-packages:$PYTHONPATH"
```

#### 2. **Variables para Docker en WSL**
```bash
# Agregar al ~/.bashrc
export DOCKER_HOST="tcp://localhost:2375"
export COMPOSE_CONVERT_WINDOWS_PATHS=1
```

#### 3. **Acceso a archivos de Windows**
```bash
# Los archivos de Windows están en /mnt/c/
export WINDOWS_PROJECTS="/mnt/c/Users/$USER/Documents/Proyectos"
```

---

## 🐍 Variables específicas para Python

### 🔧 Configuración esencial:

#### 1. **PYTHONPATH**
```bash
# Linux/Mac
export PYTHONPATH="${PYTHONPATH}:/usr/local/lib/python3.9/site-packages"
export PYTHONPATH="${PYTHONPATH}:$HOME/proyectos"

# Windows
set PYTHONPATH=C:\Python39\Lib\site-packages;%PYTHONPATH%
```

#### 2. **PYTHONHOME**
```bash
# Linux/Mac
export PYTHONHOME="/usr/local"

# Windows
set PYTHONHOME=C:\Python39
```

#### 3. **PYTHONUNBUFFERED**
```bash
# Para evitar problemas de buffering
export PYTHONUNBUFFERED=1
```

#### 4. **PYTHONDONTWRITEBYTECODE**
```bash
# Evitar archivos .pyc
export PYTHONDONTWRITEBYTECODE=1
```

### 🛠️ Configuración para entornos virtuales:

#### **Crear y activar entorno virtual:**
```bash
# Crear entorno
python3 -m venv mi_entorno

# Activar en Linux/Mac
source mi_entorno/bin/activate

# Activar en Windows
mi_entorno\Scripts\activate

# Variables automáticas del entorno virtual
export VIRTUAL_ENV="/ruta/al/entorno"
export PATH="$VIRTUAL_ENV/bin:$PATH"
```

---

## 🗄️ Variables para Bases de Datos

### 🔧 PostgreSQL:
```bash
# Linux/Mac
export PGHOST="localhost"
export PGPORT="5432"
export PGUSER="admin"
export PGPASSWORD="admin"
export PGDATABASE="educacionit"
export PGPASSFILE="$HOME/.pgpass"

# Windows
set PGHOST=localhost
set PGPORT=5432
set PGUSER=admin
set PGPASSWORD=admin
set PGDATABASE=educacionit
```

### 🔧 MySQL:
```bash
# Linux/Mac
export MYSQL_HOST="localhost"
export MYSQL_PORT="3306"
export MYSQL_USER="root"
export MYSQL_PASSWORD="password"
export MYSQL_DATABASE="test"

# Windows
set MYSQL_HOST=localhost
set MYSQL_PORT=3306
set MYSQL_USER=root
set MYSQL_PASSWORD=password
set MYSQL_DATABASE=test
```

### 🔧 MongoDB:
```bash
# Linux/Mac
export MONGO_URI="mongodb://localhost:27017"
export MONGO_DATABASE="test"

# Windows
set MONGO_URI=mongodb://localhost:27017
set MONGO_DATABASE=test
```

---

## 🔥 Variables para Apache Spark

### 🔧 Configuración esencial:
```bash
# Linux/Mac
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
export SPARK_HOME="/opt/spark"
export HADOOP_HOME="/opt/hadoop"
export PYSPARK_PYTHON="/usr/bin/python3"
export PYSPARK_DRIVER_PYTHON="/usr/bin/python3"
export SPARK_LOCAL_IP="127.0.0.1"

# Windows
set JAVA_HOME=C:\Program Files\Java\jdk-11.0.12
set SPARK_HOME=C:\spark
set HADOOP_HOME=C:\hadoop
set PYSPARK_PYTHON=python
set PYSPARK_DRIVER_PYTHON=python
set SPARK_LOCAL_IP=127.0.0.1
```

### 🔧 Variables adicionales:
```bash
# Configuración de memoria
export SPARK_DRIVER_MEMORY="2g"
export SPARK_EXECUTOR_MEMORY="2g"

# Configuración de logs
export SPARK_LOG_DIR="/tmp/spark-logs"
export SPARK_WORKER_DIR="/tmp/spark-worker"
```

---

## 🐳 Variables para Docker

### 🔧 Configuración básica:
```bash
# Linux/Mac
export DOCKER_HOST="unix:///var/run/docker.sock"
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# Windows
set DOCKER_HOST=npipe:////./pipe/docker_engine
set DOCKER_BUILDKIT=1
set COMPOSE_DOCKER_CLI_BUILD=1
```

### 🔧 Variables para desarrollo:
```bash
# Evitar problemas de permisos
export DOCKER_UID=$(id -u)
export DOCKER_GID=$(id -g)

# Configuración de red
export DOCKER_NETWORK="bridge"
```

---

## 🛠️ Scripts de configuración automática

### 📝 Script para Linux/Mac:
```bash
#!/bin/bash
# config_env.sh

echo "🔧 Configurando variables de entorno..."

# Python
export PYTHONPATH="${PYTHONPATH}:/usr/local/lib/python3.9/site-packages"
export PYTHONUNBUFFERED=1
export PYTHONDONTWRITEBYTECODE=1

# Java y Spark
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
export SPARK_HOME="/opt/spark"
export HADOOP_HOME="/opt/hadoop"
export PYSPARK_PYTHON="/usr/bin/python3"
export PYSPARK_DRIVER_PYTHON="/usr/bin/python3"

# PostgreSQL
export PGHOST="localhost"
export PGPORT="5432"
export PGUSER="admin"
export PGPASSWORD="admin"
export PGDATABASE="educacionit"

# Docker
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

echo "✅ Variables configuradas"
echo "📋 Variables actuales:"
env | grep -E "(PYTHON|JAVA|SPARK|PG|DOCKER)"
```

### 📝 Script para Windows (PowerShell):
```powershell
# config_env.ps1

Write-Host "🔧 Configurando variables de entorno..." -ForegroundColor Green

# Python
[Environment]::SetEnvironmentVariable("PYTHONPATH", "C:\Python39\Lib\site-packages", "User")
[Environment]::SetEnvironmentVariable("PYTHONUNBUFFERED", "1", "User")

# Java y Spark
[Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\Program Files\Java\jdk-11.0.12", "User")
[Environment]::SetEnvironmentVariable("SPARK_HOME", "C:\spark", "User")
[Environment]::SetEnvironmentVariable("PYSPARK_PYTHON", "python", "User")

# PostgreSQL
[Environment]::SetEnvironmentVariable("PGHOST", "localhost", "User")
[Environment]::SetEnvironmentVariable("PGPORT", "5432", "User")
[Environment]::SetEnvironmentVariable("PGUSER", "admin", "User")
[Environment]::SetEnvironmentVariable("PGPASSWORD", "admin", "User")
[Environment]::SetEnvironmentVariable("PGDATABASE", "educacionit", "User")

Write-Host "✅ Variables configuradas" -ForegroundColor Green
```

---

## 🔍 Diagnóstico de problemas

### 🚨 Verificar configuración:

#### **1. Verificar Python:**
```bash
# Verificar instalación
python3 --version
pip3 --version

# Verificar PATH
which python3
which pip3

# Verificar PYTHONPATH
echo $PYTHONPATH
python3 -c "import sys; print(sys.path)"
```

#### **2. Verificar Java:**
```bash
# Verificar instalación
java -version
javac -version

# Verificar JAVA_HOME
echo $JAVA_HOME
ls -la $JAVA_HOME
```

#### **3. Verificar Spark:**
```bash
# Verificar instalación
spark-shell --version

# Verificar variables
echo $SPARK_HOME
echo $HADOOP_HOME
echo $PYSPARK_PYTHON
```

#### **4. Verificar PostgreSQL:**
```bash
# Verificar conexión
psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE -c "SELECT version();"
```

### 🛠️ Solución de problemas comunes:

#### **Problema: `python: command not found`**
```bash
# Solución: Agregar Python al PATH
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
```

#### **Problema: `ModuleNotFoundError`**
```bash
# Solución: Configurar PYTHONPATH
export PYTHONPATH="${PYTHONPATH}:/ruta/a/librerias"
pip3 install --user nombre_libreria
```

#### **Problema: `Permission denied`**
```bash
# Solución: Verificar permisos
sudo chown -R $USER:$USER ~/.local
chmod +x ~/.local/bin/*
```

#### **Problema: `Connection refused`**
```bash
# Solución: Verificar variables de base de datos
echo $PGHOST
echo $PGPORT
echo $PGUSER
```

---

## 📋 Checklist de configuración

### ✅ Para Linux/Mac:
- [ ] PATH incluye Python y pip
- [ ] PYTHONPATH configurado
- [ ] JAVA_HOME configurado
- [ ] Variables de base de datos configuradas
- [ ] Variables de Spark configuradas
- [ ] Variables de Docker configuradas
- [ ] Archivo ~/.bashrc actualizado
- [ ] Configuración recargada (`source ~/.bashrc`)

### ✅ Para Windows:
- [ ] PATH incluye Python y pip
- [ ] PYTHONPATH configurado
- [ ] JAVA_HOME configurado
- [ ] Variables de base de datos configuradas
- [ ] Variables de Spark configuradas
- [ ] Variables de Docker configuradas
- [ ] Variables del sistema configuradas
- [ ] Sistema reiniciado o sesión recargada

### ✅ Para WSL:
- [ ] ~/.bashrc configurado
- [ ] Variables de Windows accesibles
- [ ] Docker configurado para WSL
- [ ] Permisos de archivos correctos

---

## 🎯 Mejores prácticas

### ✅ **Hacer:**
- Usar archivos `.env` para proyectos específicos
- Documentar variables necesarias
- Usar rutas absolutas cuando sea necesario
- Verificar configuración antes de ejecutar
- Usar entornos virtuales para Python

### ❌ **No hacer:**
- Modificar variables del sistema sin respaldo
- Usar rutas hardcodeadas
- Ignorar mensajes de error de variables
- Configurar variables en múltiples lugares
- Usar variables temporales para configuraciones permanentes

---

## 📚 Recursos adicionales

### 🔗 Enlaces útiles:
- [Python Environment Variables](https://docs.python.org/3/using/cmdline.html#environment-variables)
- [Apache Spark Configuration](https://spark.apache.org/docs/latest/configuration.html)
- [PostgreSQL Environment Variables](https://www.postgresql.org/docs/current/libpq-envars.html)
- [Docker Environment Variables](https://docs.docker.com/compose/environment-variables/)

### 📖 Documentación:
- [Linux Environment Variables](https://www.gnu.org/software/bash/manual/html_node/Environment.html)
- [Windows Environment Variables](https://docs.microsoft.com/en-us/windows/environment-variables)
- [WSL Environment Variables](https://docs.microsoft.com/en-us/windows/wsl/wsl-config)

---

## 🚀 ¡Listo para usar!

Con esta configuración tendrás:
- ✅ **Python** funcionando correctamente
- ✅ **Bases de datos** conectadas
- ✅ **Spark** configurado
- ✅ **Docker** funcionando
- ✅ **Sin errores** de variables de entorno

**¡Ahora puedes enfocarte en Data Engineering sin problemas de configuración! 🎉** 