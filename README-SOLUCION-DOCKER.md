# 🚨 SOLUCIÓN: Error "repository does not exist or may require docker login"

## 🔍 **Problema Identificado**

El error `pull access denied` ocurre porque el `docker-compose.yml` usa **imágenes Docker personalizadas** que deben **construirse localmente** usando nuestros Dockerfiles:

```yaml
# ⚠️ IMÁGENES PERSONALIZADAS (requieren construcción local)
image: hadoop-hive-spark-master
image: hadoop-hive-spark-worker  
image: hadoop-hive-spark-jupyter
image: hadoop-hive-spark-jupyterlab
```

## ✅ **SOLUCIÓN**

Las imágenes personalizadas **SÍ SE PUEDEN INSTALAR** usando nuestro sistema de construcción:

```bash
# 🚀 SOLUCIÓN RÁPIDA - Un solo comando
make

# O paso a paso:
make build    # Construye todas las imágenes
make up       # Levanta los servicios
```

**¿Por qué funciona?**
- ✅ Entorno **100% funcional** con todas las características
- ✅ Configuración **optimizada** para el curso
- ✅ Integración **completa** Hadoop + Hive + Spark
- ✅ **Jupyter** con PySpark preconfigurado

## 🚀 **INSTRUCCIONES PARA ALUMNOS**

```bash
# 1. Clonar el repositorio (si no lo has hecho)
git clone https://github.com/FacundoDuranDev/curso-educacion-it.git
cd curso-educacion-it

# 2. ¡Un solo comando hace todo!
make

# Esto ejecuta automáticamente:
# - make build (construye todas las imágenes)
# - make up (levanta todos los servicios)
# - make status (muestra el estado)
```

**⏱️ Tiempo estimado:** 15-20 minutos (primera vez)

## 🔍 **VERIFICAR QUE TODO FUNCIONA**

```bash
# Ver estado de todos los servicios
make status

# Ver logs si hay problemas
docker-compose logs

# Verificar imágenes construidas
docker images | grep hadoop-hive-spark
```

## 🌐 **ACCEDER A LOS SERVICIOS**

Una vez que todo esté funcionando, puedes acceder a:

- **🗄️ PostgreSQL**: `localhost:5432` (usuario: postgres, contraseña: jupyter)
- **📓 Jupyter Notebook**: http://localhost:8888 (sin token requerido)
- **📊 JupyterLab**: http://localhost:8890 (sin token requerido)
- **⚡ Spark Master**: http://localhost:8080
- **🔧 Spark Worker 1**: http://localhost:8081
- **🔧 Spark Worker 2**: http://localhost:8082
- **📁 HDFS Web UI**: http://localhost:9870
- **🧮 YARN ResourceManager**: http://localhost:8088
- **🐝 Hive**: `localhost:10000` (JDBC)
- **🔥 HBase Master**: http://localhost:16010
- **💎 Cassandra**: `localhost:9042`

## 🔧 **Configuración Spark en Notebooks**

Usar esta configuración en los notebooks de Jupyter:

```python
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("EducacionIT-Curso") \
    .master("spark://spark-master:7077") \
    .config("spark.executor.memory", "800m") \
    .config("spark.executor.cores", "1") \
    .config("spark.executor.instances", "2") \
    .config("spark.driver.memory", "1g") \
    .config("spark.sql.adaptive.enabled", "true") \
    .config("spark.serializer", "org.apache.spark.serializer.KryoSerializer") \
    .getOrCreate()
```

## 📋 **Requisitos del Sistema**

- **Docker**: Versión 20.10+
- **Docker Compose**: Versión 2.0+
- **RAM**: Mínimo 8GB recomendado
- **CPU**: Mínimo 4 cores recomendado
- **Disco**: 10GB de espacio libre

## 🆘 **Solución de Problemas Comunes**

### **Error: "No space left on device"**
```bash
docker system prune -a
docker volume prune
```

### **Error: "Port already in use"**
```bash
# Verificar qué usa el puerto
netstat -tulpn | grep :8888

# Detener servicios conflictivos
docker-compose -f docker-compose-public.yml down
```

### **Error: "Memory allocation failed"**
- Aumentar memoria asignada a Docker Desktop (mínimo 6GB)
- Cerrar aplicaciones que consuman mucha RAM

## 🎯 **Beneficios de Esta Solución**

✅ **Imágenes públicas** - Disponibles para todos los alumnos  
✅ **Sin autenticación** - No requiere login en Docker Hub  
✅ **Oficiales/Confiables** - Mantenidas por organizaciones reconocidas  
✅ **Actualizadas** - Versiones recientes de Spark 3.5.0  
✅ **Optimizadas** - Configuración de recursos balanceada  
✅ **Documentadas** - Instrucciones claras para uso

## 📞 **Soporte**

Si persisten los problemas:
1. Verificar conexión a Internet
2. Reiniciar Docker Desktop
3. Ejecutar `docker system prune -a` para limpiar cache
4. Contactar al instructor con los logs específicos

---
*Solución creada: Septiembre 2025*  
*Compatible con: Docker 20.10+, Spark 3.5.0, Python 3.11*



