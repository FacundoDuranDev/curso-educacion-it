# 🚀 Entorno de Data Engineering - EducaciónIT

Este proyecto proporciona un entorno completo de Data Engineering con todas las herramientas necesarias para el curso.

## 📋 Servicios Incluidos

- **PostgreSQL 15** - Base de datos relacional
- **HDFS 3.2.1** - Sistema de archivos distribuido
- **Apache Hive 3.1.3** - Data warehouse sobre Hadoop
- **Apache Spark 3.1.1** - Motor de procesamiento distribuido
- **Jupyter Lab** - Entorno de desarrollo interactivo

## 🛠️ Instalación Rápida

### Prerrequisitos
- Docker y Docker Compose instalados
- Mínimo 8GB RAM (16GB recomendado)
- 20GB espacio libre en disco

### Configuración Automática (Recomendado)

```bash
# 1. Clonar el repositorio
git clone <URL_DEL_REPOSITORIO>
cd educacionit

# 2. Ejecutar configuración automática
./scripts/setup_complete.sh
```

### Configuración Manual

```bash
# 1. Iniciar todos los servicios
docker-compose up -d

# 2. Esperar a que se inicien (5-10 minutos)
# 3. Configurar base de datos
./scripts/setup_database.sh

# 4. Configurar HDFS
./scripts/init_hive_hdfs.sh

# 5. Configurar Hive (cuando esté listo)
./scripts/setup_hive_complete.sh
```

## 🌐 Acceso a los Servicios

| Servicio | URL/Puerto | Descripción |
|----------|------------|-------------|
| **Jupyter Lab** | http://localhost:8888 | Entorno de desarrollo principal |
| **HDFS Web UI** | http://localhost:9870 | Interfaz web de HDFS |
| **Spark Master** | http://localhost:8080 | Interfaz web de Spark |
| **Spark Worker** | http://localhost:8081 | Interfaz web del Worker |
| **PostgreSQL** | localhost:5432 | Base de datos |
| **HiveServer2** | localhost:10000 | Servidor de Hive |

## 🔗 Conexiones

### PostgreSQL
```bash
psql -h localhost -p 5432 -U admin -d educacionit
```

### Hive (Beeline)
```bash
docker exec -it hive-server beeline -u jdbc:hive2://localhost:10000
```

### HDFS
```bash
docker exec -it hadoop-namenode hdfs dfs -ls /
```

## 📊 Datos del Proyecto

El proyecto incluye datos de ejemplo en la carpeta `Etapa 1/`:

- **Clientes.csv** - 3,407 clientes con información geográfica
- **Ventas.csv** - 46,645 transacciones de ventas
- **Productos.csv** - 291 productos con categorías
- **Sucursales.csv** - 31 sucursales
- **Empleados.csv** - 249 empleados
- **CanalDeVenta.csv** - 3 canales de venta

## 🎯 Ejercicios del Curso

### PostgreSQL
```bash
# Ejecutar ejercicios de SQL
psql -h localhost -p 5432 -U admin -d educacionit -f scripts/ejercicios_clase.sql
```

### Hive
```bash
# Conectar a Hive
docker exec -it hive-server beeline -u jdbc:hive2://localhost:10000

# Usar base de datos retail
USE retail;

# Ver tablas disponibles
SHOW TABLES;

# Ejemplo de consulta
SELECT COUNT(*) FROM clientes;
```

### Spark en Jupyter
```python
# En Jupyter Lab, crear un nuevo notebook y ejecutar:
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("DataEngineering") \
    .config("spark.sql.warehouse.dir", "/user/hive/warehouse") \
    .enableHiveSupport() \
    .getOrCreate()

# Leer datos de Hive
df_ventas = spark.sql("SELECT * FROM retail.ventas LIMIT 10")
df_ventas.show()
```

## 🛠️ Comandos Útiles

### Gestión de Contenedores
```bash
# Ver estado de los servicios
docker-compose ps

# Ver logs de un servicio
docker logs <nombre-servicio>

# Reiniciar un servicio
docker-compose restart <nombre-servicio>

# Detener todos los servicios
docker-compose down

# Detener y eliminar volúmenes
docker-compose down -v
```

### Verificación de Servicios
```bash
# Verificar PostgreSQL
docker exec -it postgres psql -U admin -d educacionit -c "SELECT COUNT(*) FROM clientes;"

# Verificar HDFS
docker exec -it hadoop-namenode hdfs dfsadmin -report

# Verificar Hive
docker exec -it hive-server beeline -u jdbc:hive2://localhost:10000 -e "SHOW DATABASES;"
```

## 🔧 Solución de Problemas

### Hive no se conecta
```bash
# Verificar logs
docker logs hive-server

# Reiniciar Hive
docker-compose restart hive-server hive-metastore

# Verificar metastore
docker exec -it postgres psql -U admin -d metastore -c "SELECT COUNT(*) FROM \"VERSION\";"
```

### HDFS no funciona
```bash
# Verificar estado
docker exec -it hadoop-namenode hdfs dfsadmin -report

# Reiniciar HDFS
docker-compose restart hadoop-namenode hadoop-datanode-1 hadoop-datanode-2 hadoop-datanode-3
```

### Jupyter no carga
```bash
# Verificar logs
docker logs jupyter

# Reiniciar Jupyter
docker-compose restart jupyter
```

## 📚 Recursos Adicionales

- [Guía de Instalación Completa](GUIA_INSTALACION_COMPLETA.md)
- [Guía de Hive](GUIA_HIVE.md)
- [Guía de HDFS](GUIA_HDFS.md)
- [Guía de Spark](GUIA_OLAP.md)
- [Ejercicios de Calidad de Datos](EJERCICIOS_CALIDAD_DATOS.md)

## 🆘 Soporte

Si encuentras problemas:

1. Verifica que Docker esté ejecutándose
2. Asegúrate de tener suficiente memoria RAM (mínimo 8GB)
3. Revisa los logs del servicio problemático
4. Ejecuta `./scripts/setup_complete.sh` para reconfigurar todo

## 📝 Notas de Versión

- **Hive 3.1.3** - Versión estable con soporte completo para PostgreSQL
- **Spark 3.1.1** - Compatible con Hadoop 3.2.1
- **PostgreSQL 15** - Última versión estable
- **Jupyter Lab** - Entorno moderno para desarrollo

---

**¡Listo para comenzar el curso de Data Engineering! 🎉** 