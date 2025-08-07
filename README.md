# 🚀 Data Engineering Course - EducaciónIT

Repositorio completo para el curso de **Ingeniería de Datos** con PostgreSQL, Docker y Big Data.

## 📋 Descripción

Este proyecto contiene todo el material necesario para el curso de Data Engineering, incluyendo:
- Base de datos PostgreSQL con datos reales
- Scripts de configuración y carga de datos
- Ejercicios prácticos de SQL
- Configuración de Docker para Big Data
- Datasets de ejemplo para análisis

## 🏗️ Arquitectura del Proyecto

```
educacionit/
├── docker-compose.yaml          # Configuración de servicios Docker
├── Etapa 1/                     # Datasets CSV originales
│   ├── Clientes.csv
│   ├── Sucursales.csv
│   ├── Gastos.csv
│   ├── Compras.csv
│   ├── Productos.csv
│   ├── Proveedores.csv
│   ├── Empleados.csv
│   ├── CanalDeVenta.csv
│   └── Venta.csv
├── scripts/                      # Scripts de configuración
│   ├── create_tables.sql        # Creación de tablas
│   ├── load_data.sql            # Carga de datos
│   └── ejercicios_clase.sql     # Ejercicios prácticos
└── README.md                    # Este archivo
```

## 🛠️ Tecnologías Utilizadas

- **PostgreSQL 15** - Base de datos relacional
- **Apache Hadoop 3.2.1** - Framework de Big Data
- **Apache Spark 3.1.1** - Procesamiento distribuido
- **Apache Hive 2.3.2** - Data warehouse
- **Python 3.9+** - Análisis de datos y ETL
- **Jupyter Lab** - Entorno de desarrollo interactivo
- **Docker & Docker Compose** - Containerización

## 📊 Datasets Incluidos

| Tabla | Registros | Descripción |
|-------|-----------|-------------|
| Clientes | 3,407 | Información de clientes |
| Sucursales | 31 | Ubicaciones de sucursales |
| Gastos | 8,640 | Gastos por sucursal |
| Compras | 11,539 | Compras a proveedores |
| Productos | 291 | Catálogo de productos |
| Proveedores | 14 | Información de proveedores |
| Empleados | 249 | Datos de empleados |
| Canal de Venta | 3 | Canales de venta |
| Ventas | 46,645 | Transacciones de venta |

**Total: 70,823 registros**

## 🚀 Instalación y Configuración

### Prerrequisitos
- Docker y Docker Compose instalados
- Git

> 📖 **Guía completa de instalación**: Ver [GUIA_INSTALACION.md](GUIA_INSTALACION.md) para instrucciones detalladas paso a paso.
> 🔧 **Variables de entorno**: Ver [GUIA_VARIABLES_ENTORNO.md](GUIA_VARIABLES_ENTORNO.md) para evitar problemas de configuración.

### 🐧 Instalación de WSL (Windows Subsystem for Linux)

Si usas **Windows 10/11**, es altamente recomendado instalar WSL para una mejor experiencia:

#### **Método 1: Instalación automática (Recomendado)**
```bash
# Abrir PowerShell como Administrador y ejecutar:
wsl --install
```

#### **Método 2: Instalación manual**
1. **Habilitar características de Windows:**
   ```bash
   # En PowerShell como Administrador:
   dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
   dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
   ```

2. **Reiniciar la computadora**

3. **Descargar e instalar WSL2:**
   - Descargar: https://aka.ms/wsl2kernel
   - Instalar el paquete descargado

4. **Establecer WSL2 como predeterminado:**
   ```bash
   wsl --set-default-version 2
   ```

5. **Instalar Ubuntu:**
   ```bash
   wsl --install -d Ubuntu
   ```

#### **Configuración inicial de Ubuntu:**
```bash
# Crear usuario y contraseña cuando se solicite
# Actualizar el sistema
sudo apt update && sudo apt upgrade -y

# Instalar herramientas básicas
sudo apt install curl wget git -y
```

#### **Instalar Docker en WSL:**
```bash
# Instalar Docker
sudo apt update
sudo apt install docker-compose

# Agregar usuario al grupo docker
sudo usermod -aG docker $USER

# Iniciar Docker
sudo service docker start
# Verificar instalación
docker-compose --version

```

#### **Configurar acceso a archivos de Windows:**
```bash
# Los archivos de Windows están disponibles en /mnt/c/
# Ejemplo: /mnt/c/Users/TuUsuario/Documents/
```

#### **Solución de problemas comunes en WSL:**

**❌ Error: "WSL is not installed"**
```bash
# Verificar si WSL está habilitado
wsl --list --verbose
```

**❌ Error: "Docker daemon not running"**
```bash
# Iniciar Docker en WSL
sudo service docker start

# Verificar estado
sudo service docker status
```

**❌ Error: "Permission denied"**
```bash
# Agregar usuario al grupo docker
sudo usermod -aG docker $USER

# Reiniciar sesión o ejecutar
newgrp docker
```

**❌ Problemas de rendimiento en WSL2:**
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

### Pasos de Instalación

1. **Clonar el repositorio:**
```bash
git clone https://github.com/FacundoDuranDev/curso-educacion-it.git
cd curso-educacion-it
```

2. **Levantar todos los servicios Docker:**
```bash
docker-compose up -d
```

3. **Crear y cargar la base de datos:**
```bash
chmod +x scripts/setup_database.sh
./scripts/setup_database.sh
```

4. **Acceder a Jupyter Lab:**
   - Abrir navegador en: http://localhost:8888
   - Abrir notebook: `01_introduccion_data_engineering.ipynb`

5. **Conectar a PostgreSQL:**
```bash
psql -h localhost -p 5432 -U admin -d educacionit
```

### 🌐 Interfaces Web Disponibles

| Servicio | URL | Descripción |
|----------|-----|-------------|
| **Jupyter Lab** | http://localhost:8888 | Entorno de desarrollo Python |
| **Spark Master** | http://localhost:8080 | Interfaz de Spark |
| **Hadoop Namenode** | http://localhost:9870 | Interfaz de HDFS |
| **Spark Worker** | http://localhost:8081 | Interfaz del worker de Spark |

## 📚 Ejercicios y Prácticas

### Ejercicios Incluidos
- Exploración de datos
- Análisis de calidad de datos
- Consultas SQL complejas
- Normalización de datos
- Análisis de relaciones entre tablas
- ETL y transformaciones

### Ejecutar Ejercicios
```bash
psql -h localhost -p 5432 -U admin -d educacionit -f scripts/ejercicios_clase.sql
```

## 🐳 Servicios Docker Disponibles

- **PostgreSQL** (puerto 5432) - Base de datos principal
- **Hadoop Namenode** (puerto 9870) - Sistema de archivos distribuido
- **Hadoop Datanode** - Almacenamiento de datos
- **Spark Master** (puerto 8080) - Procesamiento de datos
- **Spark Worker** (puerto 8081) - Nodos de procesamiento
- **Hive Server** - Data warehouse



## 🤝 Contribuciones

Este repositorio está diseñado para el curso de Data Engineering. Las contribuciones son bienvenidas para mejorar el material educativo.

## 📄 Licencia

Este proyecto está bajo la licencia de Educacion IT.

## 📞 Contacto

Para preguntas sobre el curso o el material, contactar al instructor.

---

**Desarrollado para EducaciónIT** 🎓 