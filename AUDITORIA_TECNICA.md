# 🔍 AUDITORÍA TÉCNICA - VALIDACIÓN DE CONFIGURACIONES

## 📊 **FASE 1: NOMBRES DE CONTENEDORES Y SERVICIOS**

### **🐳 SERVICIOS DEFINIDOS EN DOCKER-COMPOSE.YML:**

| **Servicio** | **Hostname** | **Imagen** | **Nombre de Contenedor Esperado** |
|--------------|--------------|------------|-----------------------------------|
| `metastore` | `metastore` | `postgres:11` | `educacionit-metastore-1` |
| `master` | `master` | `hadoop-hive-spark-master` | `educacionit-master-1` |
| `worker1` | `worker1` | `hadoop-hive-spark-worker` | `educacionit-worker1-1` |
| `worker2` | `worker2` | `hadoop-hive-spark-worker` | `educacionit-worker2-1` |
| `history` | `history` | `hadoop-hive-spark-history` | `educacionit-history-1` |
| `jupyter` | `jupyter` | `hadoop-hive-spark-jupyter` | `educacionit-jupyter-1` |
| `jupyterlab` | `jupyterlab` | `hadoop-hive-spark-jupyterlab` | `educacionit-jupyterlab-1` |
| `hbase` | `hbase` | `dajobe/hbase` | `educacionit-hbase-1` |
| `cassandra` | `cassandra` | `cassandra:4.1` | `educacionit-cassandra-1` |

### **🔍 CONVENCIÓN DE NOMBRES:**
- **Docker Compose v2**: `educacionit-[servicio]-1` (guiones medios)
- **Docker Compose v1**: `educacionit_[servicio]_1` (guiones bajos)

---

## 🔐 **FASE 2: CREDENCIALES Y CONFIGURACIONES**

### **📊 CREDENCIALES IDENTIFICADAS:**

#### **🗄️ PostgreSQL (Metastore):**
```yaml
# En docker-compose.yml
environment:
  POSTGRES_PASSWORD: jupyter
```
- **Usuario superusuario**: `postgres`
- **Contraseña**: `jupyter`
- **Puerto**: `5432`
- **Base de datos por defecto**: `postgres`

#### **👤 Usuario del Sistema (Contenedores):**
```yaml
# En base/Dockerfile
ARG USERNAME=jupyter
ARG UID=1001
ARG GID=1001
```
- **Usuario**: `jupyter`
- **UID/GID**: `1001`
- **Home**: `/home/jupyter`

#### **🌐 Jupyter Notebook/Lab:**
```bash
# En jupyter/run.sh
--NotebookApp.token=''
```
- **Token**: Vacío (sin autenticación)
- **Contraseña**: Vacía (sin autenticación)
- **Puerto Notebook**: `8888`
- **Puerto JupyterLab**: `8890`

#### **🏗️ Base de Datos EducacionIT (Manual):**
```sql
-- Debe crearse manualmente
CREATE USER admin WITH PASSWORD 'admin123';
CREATE DATABASE educacionit;
```
- **Usuario**: `admin`
- **Contraseña**: `admin123`
- **Base de datos**: `educacionit`

---

## 🌐 **FASE 3: PUERTOS Y SERVICIOS**

### **📡 MAPEO DE PUERTOS:**

| **Servicio** | **Puerto Interno** | **Puerto Externo** | **Descripción** |
|--------------|-------------------|-------------------|-----------------|
| **PostgreSQL** | `5432` | `5432` | Base de datos |
| **HDFS NameNode** | `9870` | `9870` | Web UI HDFS |
| **Spark Master** | `8080` | `8080` | Web UI Spark Master |
| **Spark Worker1** | `8081` | `8081` | Web UI Worker 1 |
| **Spark Worker2** | `8081` | `8082` | Web UI Worker 2 |
| **Jupyter Notebook** | `8888` | `8888` | Notebook Interface |
| **JupyterLab** | `8888` | `8890` | JupyterLab Interface |
| **Spark History** | `18080` | `18080` | Spark History Server |
| **YARN ResourceManager** | `8088` | `8088` | YARN Web UI |
| **Hadoop JobHistory** | `19888` | `19888` | Job History Server |
| **HiveServer2** | `10000` | `10000` | Hive JDBC |
| **HBase Master** | `16010` | `16010` | HBase Web UI |
| **Cassandra** | `9042` | `9042` | CQL Native Transport |

---

## ⚠️ **PROBLEMAS ENCONTRADOS**

### **🔴 INCONSISTENCIAS CRÍTICAS:**

#### **1. NOMBRES DE CONTENEDORES EN DOCUMENTACIÓN:**
- [ ] **PROBLEMA**: Algunos archivos usan nombres antiguos
- [ ] **SOLUCIÓN**: Actualizar a convención Docker Compose v2

#### **2. CREDENCIALES CONFUSAS:**
- [ ] **PROBLEMA**: Múltiples referencias a diferentes credenciales
- [ ] **SOLUCIÓN**: Centralizar y clarificar credenciales

#### **3. COMANDOS OBSOLETOS:**
- [ ] **PROBLEMA**: Algunos comandos pueden no funcionar
- [ ] **SOLUCIÓN**: Validar todos los comandos docker exec

---

## 📋 **PRÓXIMAS VALIDACIONES**

### **🔍 A VERIFICAR:**
1. [ ] Buscar todos los archivos MD que mencionen nombres de contenedores
2. [ ] Validar comandos `docker exec` en la documentación
3. [ ] Verificar credenciales en todas las guías
4. [ ] Probar secuencias de instalación
5. [ ] Validar URLs de acceso a servicios

### **📝 ARCHIVOS PRIORITARIOS PARA REVISAR:**
1. `README.md` - Documentación principal
2. `GUIA_INSTALACION_RAPIDA.md` - Primera experiencia
3. `COMANDOS_RAPIDOS_DOCKER.md` - Comandos frecuentes
4. `GUIA_INSTALACION_POSTGRESQL.md` - Configuración crítica

---

## ✅ **ESTADO ACTUAL:**
- ✅ **Servicios identificados**: 9 servicios
- ✅ **Credenciales mapeadas**: PostgreSQL, Jupyter, Admin
- ✅ **Puertos documentados**: 12 puertos principales
- 🔄 **En progreso**: Validación en archivos MD
