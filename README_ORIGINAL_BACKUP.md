# Clúster Hadoop-Hive-Spark con Jupyter Notebook en Docker

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

**🔧 Script de Detección Automática:**
```bash
./detect_container_names.sh
```
Este script detecta automáticamente tu versión de Docker Compose y muestra los nombres correctos.

## ⚠️ ADVERTENCIA DE SEGURIDAD
**Este clúster está diseñado exclusivamente para entornos de desarrollo, pruebas y aprendizaje. NO utilizar en entornos de producción.**

---

## 📋 REQUISITOS DEL SISTEMA

### Dependencias de Software
- Docker Engine 20.10+
- Docker Compose 2.0+
- Mínimo 8GB RAM disponible
- Puertos TCP disponibles: 8088, 9870, 10000, 8888, 18080, 19888

### Especificaciones Técnicas
- **Sistema Operativo**: Linux (recomendado), macOS, Windows con WSL2
- **Arquitectura**: x86_64
- **Almacenamiento**: Mínimo 20GB de espacio libre en disco

---

## 🚀 DESPLIEGUE DEL CLÚSTER

### Fase 1: Construcción de Imágenes Docker
```bash
make
```

**Nota:** El comando `make` ejecuta automáticamente `make build` seguido de `make up`, construyendo todas las imágenes y levantando el entorno completo.

**Descripción Técnica**: Este comando ejecuta el Makefile que construye secuencialmente las imágenes Docker base, master, worker, history y jupyter utilizando los Dockerfiles correspondientes en cada directorio.

### Fase 2: Inicialización del Clúster
```bash
docker-compose up -d
```

**Descripción Técnica**: Levanta todos los servicios definidos en docker-compose.yml en modo detached, creando la red personalizada `sparknet` (172.28.0.0/16) y estableciendo las dependencias entre servicios.

### Fase 3: Verificación del Estado del Clúster
```bash
make status
```

**Descripción Técnica**: Verifica el estado operativo de todos los contenedores del clúster. La salida esperada debe mostrar todos los servicios en estado `running`.

**Salida Esperada**:
```
NAME                    COMMAND                  SERVICE             STATUS              PORTS
hadoop-hive-spark-…    "/opt/hadoop/bin/ent…"   master             running             0.0.0.0:8088->8088/tcp
hadoop-hive-spark-…    "/opt/hadoop/bin/ent…"   worker1            running             0.0.0.0:8042->8042/tcp
hadoop-hive-spark-…    "/opt/hadoop/bin/ent…"   worker2            running             0.0.0.0:8043->8042/tcp
```

---

## 📚 **GUÍAS DISPONIBLES**

### **Para Estudiantes:**
- 🚀 **`GUIA_INSTALACION_RAPIDA.md`** - Instalación rápida del entorno
- 🗄️ **`GUIA_INSTALACION_POSTGRESQL.md`** - Configuración completa de PostgreSQL con datos
- 🔌 **`GUIA_DBEAVER_POSTGRESQL_WINDOWS.md`** - Conexión con DBeaver desde Windows
- 📊 **`GUIA_SQL.md`** - Guía básica de sintaxis SQL
- 🏗️ **`EJEMPLOS_NORMALIZACION.md`** - Ejemplos de normalización de bases de datos

### **Para Desarrolladores:**
- 🐳 **`COMANDOS_RAPIDOS_DOCKER.md`** - Comandos Docker útiles
- 🐧 **`COMANDOS_BASICOS_LINUX.md`** - Comandos Linux básicos
- 🧹 **`CLEANUP.md`** - Limpieza y mantenimiento del entorno

---

## 🔧 CONFIGURACIÓN DE HDFS PARA HIVE

### Contexto Técnico
HDFS (Hadoop Distributed File System) requiere la creación de directorios específicos para el funcionamiento correcto de Apache Hive. Estos directorios deben existir antes de iniciar los servicios de Hive.

### Paso 2.1: Acceso al Contenedor Master
```bash
docker exec -it master bash
```

**Parámetros del Comando**:
- `exec`: Ejecuta un comando en un contenedor en ejecución
- `-i`: Modo interactivo (mantiene STDIN abierto)
- `-t`: Asigna una pseudo-TTY
- `master`: Nombre del contenedor objetivo
- `bash`: Shell a ejecutar

**Indicador de Éxito**: El prompt cambiará a `root@master:/opt/hadoop#`

### Paso 2.2: Creación de Directorios HDFS
```bash
# Directorio principal del warehouse de Hive
hdfs dfs -mkdir -p /user/hive/warehouse

# Directorio temporal para operaciones
hdfs dfs -mkdir -p /tmp

# Directorio de usuario de Hive
hdfs dfs -mkdir -p /user/hive
```

**Comandos HDFS Utilizados**:
- `hdfs dfs -mkdir -p`: Crea directorios en HDFS con opción recursiva
- `-p`: Crea directorios padre si no existen

### Paso 2.3: Configuración de Permisos HDFS
```bash
# Asignar permisos de lectura, escritura y ejecución para todos los usuarios
hdfs dfs -chmod 777 /user/hive/warehouse
hdfs dfs -chmod 777 /tmp
hdfs dfs -chmod 777 /user/hive
```

**Especificación de Permisos 777**:
- Primer 7: Propietario (rwx = 4+2+1)
- Segundo 7: Grupo (rwx = 4+2+1)  
- Tercer 7: Otros (rwx = 4+2+1)

**Nota de Seguridad**: Los permisos 777 se utilizan únicamente en entornos de desarrollo.

### Paso 2.4: Verificación de Creación de Directorios
```bash
# Listar contenido del directorio warehouse
hdfs dfs -ls /user/hive/

# Listar contenido del directorio temporal
hdfs dfs -ls /tmp/
```

**Salida Esperada**: `drwxrwxrwx` seguido de los nombres de directorios, indicando permisos 777.

### Paso 2.5: Terminación de Sesión
```bash
exit
```

---

## 🐝 CONFIGURACIÓN DE APACHE HIVE

### Contexto Técnico
Apache Hive requiere una configuración específica del archivo `hive-site.xml` para funcionar correctamente con PostgreSQL como metastore y HDFS como almacenamiento.

### Paso 3.1: Reacceso al Contenedor Master
```bash
docker exec -it master bash
```

### Paso 3.2: Backup de Configuración Actual
```bash
# Crear respaldo de la configuración existente
cp /opt/hive/conf/hive-site.xml /opt/hive/conf/hive-site.xml.backup
```

**Propósito**: Mantener una copia de seguridad de la configuración original para recuperación en caso de fallos.

### Paso 3.3: Aplicación de Configuración Optimizada
```bash
# Aplicar configuración pre-validada
cp /opt/hive/conf/hive-site-working.xml /opt/hive/conf/hive-site.xml
```

**Descripción Técnica**: El archivo `hive-site-working.xml` contiene la configuración optimizada que incluye:
- Configuración del metastore PostgreSQL
- Parámetros de HiveServer2
- Configuración de HDFS
- Parámetros de ejecución

### Paso 3.4: Reinicio de Servicios de Hive
```bash
# Terminación de procesos Hive existentes
pkill -f HiveServer2
pkill -f MetaStore

# Inicialización del servicio metastore en background
/opt/hive/bin/hive --service metastore &

# Inicialización del servicio HiveServer2 en background
/opt/hive/bin/hive --service hiveserver2 &
```

**Comandos de Proceso**:
- `pkill -f`: Termina procesos basándose en coincidencia de patrones
- `&`: Ejecuta el comando en background

**Servicios Iniciados**:
- **Metastore**: Gestiona metadatos de tablas y particiones
- **HiveServer2**: Proporciona interfaz JDBC/ODBC para conexiones

### Paso 3.5: Terminación de Sesión
```bash
exit
```

---

## ✅ VERIFICACIÓN DE FUNCIONALIDAD

### Paso 4.1: Verificación de Estado de HiveServer2
```bash
# Verificar que HiveServer2 esté escuchando en el puerto 10000
docker exec master netstat -tlnp | grep 10000
```

**Salida Esperada**: `tcp 0 0 0.0.0.0:10000 0.0.0.0:* LISTEN`

**Interpretación**: El servicio HiveServer2 está activo y escuchando conexiones en todas las interfaces del puerto 10000.

### Paso 4.2: Conexión de Prueba a Hive
```bash
# Establecer conexión JDBC a Hive mediante beeline
docker exec -it master /opt/hive/bin/beeline -u jdbc:hive2://localhost:10000
```

**Componentes Técnicos**:
- **Beeline**: Cliente de línea de comandos para Hive basado en SQLLine
- **JDBC URL**: `jdbc:hive2://localhost:10000` - Conexión local al puerto 10000

**Indicadores de Conexión Exitosa**:
- Mensaje de versión: `Beeline version 3.1.3 by Apache Hive`
- Prompt de conexión: `0: jdbc:hive2://localhost:10000>`

### Paso 4.3: Prueba de Funcionalidad
```sql
-- Consulta de verificación de bases de datos
SHOW DATABASES;
```

**Propósito**: Verificar que Hive responda correctamente a consultas SQL básicas.

### Paso 4.4: Terminación de Sesión Beeline
```sql
!quit
```

---

## 🌐 INTERFACES DE ADMINISTRACIÓN WEB

### Hadoop Distributed File System (HDFS)
- **NameNode Web UI**: http://localhost:9870 - Administración de metadatos HDFS
- **ResourceManager Web UI**: http://localhost:8088 - Gestión de recursos YARN
- **HistoryServer Web UI**: http://localhost:19888 - Historial de trabajos MapReduce

### Apache Spark
- **Spark Master Web UI**: http://localhost:8080 - Estado del clúster Spark
- **Worker1 Web UI**: http://localhost:8081 - Estado del worker 1
- **Worker2 Web UI**: http://localhost:8082 - Estado del worker 2
- **Spark History Server**: http://localhost:18080 - Historial de aplicaciones Spark

### Apache Hive
- **JDBC Connection String**: `jdbc:hive2://localhost:10000`
- **Protocolo**: HiveServer2 Thrift

### Jupyter Notebook
- **Web Interface**: http://localhost:8888
- **Kernel Disponible**: PySpark
- **Ejemplo de Notebook**: [jupyter/notebook/pyspark.ipynb](jupyter/notebook/pyspark.ipynb)

---

## 🛠️ GESTIÓN OPERATIVA DEL CLÚSTER

### Monitoreo del Estado
```bash
# Estado de todos los contenedores
docker-compose ps

# Logs de todos los servicios
docker-compose logs

# Logs en tiempo real de servicios específicos
docker-compose logs -f master
docker-compose logs -f metastore
```

### Control de Servicios
```bash
# Detener todos los servicios
make down

# Iniciar todos los servicios
make up

# Verificar estado del clúster
make status

# Limpieza de imágenes Docker
make clean
```

---

## 🔍 RESOLUCIÓN DE PROBLEMAS

### Problema: Fallo de Conexión a Hive
**Síntomas**: Error de conexión JDBC o timeout en beeline

**Procedimiento de Diagnóstico**:
1. **Verificación de PostgreSQL**:
   ```bash
   docker-compose logs metastore
   ```

2. **Verificación de Directorios HDFS**:
   ```bash
   docker exec master hdfs dfs -ls /user/hive/
   ```

3. **Verificación de Configuración Hive**:
   ```bash
   docker exec master ls -la /opt/hive/conf/hive-site.xml
   ```

4. **Verificación de Estado de HiveServer2**:
   ```bash
   docker exec master netstat -tlnp | grep 10000
   ```

### Problema: HDFS No Accesible
**Síntomas**: Errores de permisos o directorios no encontrados

**Procedimiento de Diagnóstico**:
1. **Verificación de NameNode**:
   ```bash
   docker-compose logs master
   ```

2. **Verificación de DataNodes**:
   - Acceder a http://localhost:9870
   - Verificar que 2 DataNodes estén en estado "Active"

### Problema: Spark No Operativo
**Síntomas**: Interfaz web no accesible o workers desconectados

**Procedimiento de Diagnóstico**:
1. **Verificación de Spark Master**:
   - Acceder a http://localhost:8080
   - Verificar estado del master

2. **Verificación de Workers**:
   - En http://localhost:8080 verificar presencia de 2 workers
   - Estado de workers debe ser "ALIVE"

---

## 📚 STACK TECNOLÓGICO

### Componentes Core
- **Apache Hadoop 3.3.6**: Framework de procesamiento distribuido
- **Apache Hive 3.1.3**: Data warehouse para consultas SQL
- **Apache Spark 3.5.3**: Motor de procesamiento de datos en memoria
- **PostgreSQL 11**: Sistema de gestión de bases de datos relacional
- **Jupyter Notebook**: Entorno de desarrollo interactivo

### Versiones de Componentes
- **Java**: OpenJDK 8
- **Python**: Python 3.8+
- **Scala**: Scala 2.12

---

## 🏗️ ARQUITECTURA DEL CLÚSTER

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  Metastore │    │    Master   │    │   Worker1   │
│ (PostgreSQL)│    │ (NameNode,  │    │ (DataNode,  │
│             │    │ ResourceMgr)│    │  NodeMgr)   │
└─────────────┘    └─────────────┘    └─────────────┘
       │                   │                   │
       │                   │                   │
       └───────────────────┼───────────────────┘
                           │
                   ┌───────┼───────┐
                   │       │       │
              ┌─────────┐ ┌─────────┐
              │Worker2  │ │ History │
              │(DataNode│ │(History │
              │ NodeMgr)│ │ Server) │
              └─────────┘ └─────────┘
```

### Descripción de Componentes
- **Metastore (PostgreSQL)**: Almacena metadatos de tablas, particiones y esquemas de Hive
- **Master Node**: Coordina el clúster (NameNode + ResourceManager)
- **Worker Nodes**: Procesan datos y almacenan bloques HDFS
- **History Server**: Mantiene historial de trabajos Spark y MapReduce

---

## 🚀 PROCEDIMIENTO DE CONFIGURACIÓN COMPLETO

### Configuración Manual (Recomendado para Entornos de Desarrollo)
```bash
# 1. Despliegue del clúster
make
docker-compose up -d

# 2. Acceso al contenedor master
docker exec -it master bash

# 3. Configuración de HDFS
hdfs dfs -mkdir -p /user/hive/warehouse /tmp /user/hive
hdfs dfs -chmod 777 /user/hive/warehouse /tmp /user/hive

# 4. Configuración de Hive
cp /opt/hive/conf/hive-site-working.xml /opt/hive/conf/hive-site.xml

# 5. Reinicio de servicios Hive
pkill -f HiveServer2 && pkill -f MetaStore
/opt/hive/bin/hive --service metastore &
/opt/hive/bin/hive --service hiveserver2 &

# 6. Terminación de sesión
exit

# 7. Verificación de funcionalidad
docker exec master netstat -tlnp | grep 10000
```

### Configuración Automatizada (Para Entornos de Producción/Testing)
```bash
# Despliegue y configuración completa en una secuencia
make && docker-compose up -d
docker exec master hdfs dfs -mkdir -p /user/hive/warehouse /tmp /user/hive
docker exec master hdfs dfs -chmod 777 /user/hive/warehouse /tmp /user/hive
docker exec master cp /opt/hive/conf/hive-site-working.xml /opt/hive/conf/hive-site.xml
docker exec master bash -c "pkill -f HiveServer2; pkill -f MetaStore; /opt/hive/bin/hive --service metastore & /opt/hive/bin/hive --service hiveserver2 &"
```

---

## 📝 CONSIDERACIONES TÉCNICAS

### Configuración de Red
- **Subnet**: 172.28.0.0/16
- **IPs Estáticas**: Asignadas a cada servicio para comunicación interna
- **Port Mapping**: Mapeo de puertos internos a puertos del host

### Persistencia de Datos
- **Volúmenes Docker**: Mantienen datos entre reinicios del clúster
- **HDFS**: Almacenamiento distribuido con replicación
- **PostgreSQL**: Metadatos persistentes de Hive

### Configuración de Seguridad
- **Autenticación**: Configurada como NONE para desarrollo
- **Permisos HDFS**: 777 para facilitar operaciones de desarrollo
- **Red Aislada**: Comunicación interna a través de red Docker personalizada

---

## 🎯 OPERACIONES POST-CONFIGURACIÓN

### Verificación de Funcionalidad
1. **HDFS**: Acceder a http://localhost:9870 para explorar el sistema de archivos
2. **Hive**: Conectar via beeline y ejecutar consultas SQL de prueba
3. **Spark**: Verificar estado en http://localhost:8080
4. **Jupyter**: Desarrollar notebooks PySpark en http://localhost:8888

### Monitoreo Continuo
- **Logs de Servicios**: `docker-compose logs -f [servicio]`
- **Estado de Contenedores**: `docker-compose ps`
- **Métricas HDFS**: http://localhost:9870
- **Métricas YARN**: http://localhost:8088

---

## 🆘 SOPORTE TÉCNICO

### Procedimiento de Resolución de Problemas
1. **Análisis de Logs**: `docker-compose logs -f [servicio_afectado]`
2. **Verificación de Estado**: `docker-compose ps`
3. **Documentación**: Revisar este README para procedimientos específicos
4. **Reinicialización**: `make clean && make && docker-compose up -d`

### Recursos de Diagnóstico
- **Docker Logs**: Información detallada de servicios
- **Interfaces Web**: Monitoreo en tiempo real
- **Comandos de Verificación**: Scripts de diagnóstico incluidos

**Nota**: La primera inicialización puede requerir tiempo adicional para descarga de imágenes y configuración inicial.