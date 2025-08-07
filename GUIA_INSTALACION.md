# 🚀 Guía de Instalación - Data Engineering

## 📋 Requisitos Previos

### 🖥️ Sistema Operativo
- **Windows 10/11** (recomendado con WSL2)
- **macOS** (10.14 o superior)
- **Linux** (Ubuntu 18.04+, CentOS 7+)

### 💾 Requisitos de Hardware
- **RAM**: Mínimo 8GB, recomendado 16GB
- **Almacenamiento**: Mínimo 10GB libres
- **Procesador**: Intel i5/AMD Ryzen 5 o superior

## 🛠️ Herramientas a Instalar

### 0. 🐧 WSL2 (Solo Windows 10/11)

#### Instalación automática (Recomendado):
```bash
# Abrir PowerShell como Administrador y ejecutar:
wsl --install

#### Configuración inicial de Ubuntu:
```bash
# Crear usuario y contraseña cuando se solicite
# Actualizar el sistema
sudo apt update && sudo apt upgrade -y

# Instalar herramientas básicas
sudo apt install curl wget git -y
```

### 1. 📦 Docker Desktop
**Descarga**: https://www.docker.com/products/docker-desktop

#### Windows:
1. Descargar Docker Desktop para Windows
2. Ejecutar el instalador
3. Reiniciar la computadora
4. Abrir Docker Desktop
5. Verificar instalación: `docker --version`

#### macOS:
1. Descargar Docker Desktop para Mac
2. Arrastrar Docker.app a Applications
3. Abrir Docker Desktop
4. Verificar instalación: `docker --version`

#### Linux (Ubuntu):
```bash
# Actualizar repositorios
sudo apt update

# Instalar docker-compose
sudo apt install docker-compose

# Agregar usuario al grupo docker
sudo usermod -aG docker $USER

# Iniciar Docker
sudo systemctl start docker
sudo systemctl enable docker

# Verificar instalación
docker --version
```

#### WSL2 (Windows):
```bash
# Instalar Docker en WS

sudo apt update
sudo apt install docker-compose

# Agregar usuario al grupo docker
sudo usermod -aG docker $USER

# Iniciar Docker (en WSL2)
sudo service docker start

# Verificar instalación
docker --version
```

### 2. 📝 Editor de Código
**Recomendado**: Visual Studio Code
- **Descarga**: https://code.visualstudio.com/
- **Extensiones recomendadas**:
  - Python
  - SQL Server (mssql)
  - Docker
  - GitLens
  - Jupyter

### 3. 🐍 Python (Opcional - ya incluido en Docker)
Si quieres instalar Python localmente:

#### Windows:
1. Descargar Python desde https://www.python.org/
2. Marcar "Add Python to PATH"
3. Instalar pip: `python -m ensurepip --upgrade`

#### macOS:
```bash
# Usar Homebrew
brew install python
```

#### Linux:
```bash
sudo apt update
sudo apt install python3 python3-pip
```

### 4. 🗄️ Cliente PostgreSQL (Opcional)
**pgAdmin 4**: https://www.pgadmin.org/download/

## 🚀 Configuración del Proyecto

### 1. 📥 Clonar el Repositorio
```bash
git clone https://github.com/FacundoDuranDev/curso-educacion-it.git
cd curso-educacion-it
```

### 2. 🐳 Levantar el Entorno Docker
```bash
# Verificar que Docker esté corriendo
docker --version

# Levantar todos los servicios
docker-compose up -d

# Verificar que todos los servicios estén corriendo
docker ps
```

### 3. 🔍 Verificar Servicios
Deberías ver los siguientes contenedores corriendo:
- **postgres** (Puerto 5432)
- **hadoop-namenode** (Puerto 9870)
- **hadoop-datanode**
- **spark-master** (Puerto 8080)
- **spark-worker** (Puerto 8081)
- **hive-server** (Puerto 10000)
- **jupyter** (Puerto 8888)

### 4. 📊 Acceder a las Interfaces Web

| Servicio | URL | Descripción |
|----------|-----|-------------|
| **Jupyter Lab** | http://localhost:8888 | Entorno de desarrollo Python |
| **Spark Master** | http://localhost:8080 | Interfaz de Spark |
| **Hadoop Namenode** | http://localhost:9870 | Interfaz de HDFS |
| **Spark Worker** | http://localhost:8081 | Interfaz del worker de Spark |

### 5. 🗄️ Configurar Base de Datos
```bash
# Ejecutar script de configuración
chmod +x scripts/setup_database.sh
./scripts/setup_database.sh
```

## 📚 Primeros Pasos

### 1. 🌐 Abrir Jupyter Lab
1. Abrir navegador
2. Ir a: http://localhost:8888
3. Abrir el notebook: `01_introduccion_data_engineering.ipynb`

### 2. 🗄️ Conectar a PostgreSQL
```bash
# Usando psql (si tienes cliente instalado)
psql -h localhost -p 5432 -U admin -d educacionit

# Credenciales:
# Host: localhost
# Puerto: 5432
# Usuario: admin
# Contraseña: admin
# Base de datos: educacionit
```

### 3. 📝 Ejecutar Ejercicios SQL
```bash
# Conectar a PostgreSQL y ejecutar ejercicios
psql -h localhost -p 5432 -U admin -d educacionit -f scripts/ejercicios_clase.sql
```

## 🔧 Solución de Problemas

### ❌ Docker no inicia
**Síntomas**: Error al ejecutar `docker-compose up -d`
**Solución**:
1. Verificar que Docker Desktop esté corriendo
2. Reiniciar Docker Desktop
3. Verificar permisos de usuario

### ❌ Puerto ocupado
**Síntomas**: Error "port already in use"
**Solución**:
```bash
# Ver qué está usando el puerto
netstat -tulpn | grep :5432

# Detener servicios que usen el puerto
sudo systemctl stop postgresql  # Si tienes PostgreSQL local
```

### ❌ Memoria insuficiente
**Síntomas**: Contenedores se cierran inesperadamente
**Solución**:
1. Aumentar memoria asignada a Docker (8GB mínimo)
2. Cerrar otras aplicaciones
3. Reiniciar Docker Desktop

### ❌ Error de permisos en Linux
**Síntomas**: "permission denied"
**Solución**:
```bash
# Agregar usuario al grupo docker
sudo usermod -aG docker $USER

# Reiniciar sesión o ejecutar
newgrp docker
```

### ❌ Problemas específicos de WSL2
**Síntomas**: Docker no inicia en WSL2
**Solución**:
```bash
# Iniciar Docker manualmente
sudo service docker start

# Verificar estado
sudo service docker status

# Configurar inicio automático
echo 'sudo service docker start' >> ~/.bashrc
```

**Síntomas**: Problemas de rendimiento en WSL2
**Solución**:
```bash
# Crear archivo de configuración
sudo nano /etc/wsl.conf

# Agregar estas líneas:
[automount]
enabled = true
root = /mnt/
options = "metadata,umask=22,fmask=11"

[boot]
command = service docker start
```

## 📞 Soporte

### 🆘 Antes de pedir ayuda:
1. ✅ Verificar que Docker esté corriendo
2. ✅ Verificar que todos los puertos estén libres
3. ✅ Verificar que tengas suficiente memoria RAM
4. ✅ Revisar los logs: `docker-compose logs`

### 📧 Contacto:
- **Profesor**: [Tu email]
- **GitHub Issues**: https://github.com/FacundoDuranDev/curso-educacion-it/issues

## 🎯 Checklist de Instalación

### **Windows:**
- [ ] WSL2 instalado y configurado
- [ ] Ubuntu instalado en WSL2
- [ ] Docker instalado en WSL2
- [ ] Docker Compose instalado

### **Todos los sistemas:**
- [ ] Docker funcionando (`docker --version`)
- [ ] Visual Studio Code instalado
- [ ] Repositorio clonado
- [ ] Servicios Docker corriendo (`docker ps`)
- [ ] Jupyter Lab accesible (http://localhost:8888)
- [ ] Base de datos configurada
- [ ] Notebook de introducción ejecutándose

## 🚀 ¡Listo para la Clase!

Una vez completado el checklist, estarás listo para:
- 📊 Explorar datos con Python
- 🗄️ Ejecutar consultas SQL
- 🔥 Trabajar con Apache Spark
- 📈 Crear visualizaciones
- 🛠️ Practicar Data Engineering

**¡Nos vemos en clase! 🎉** 