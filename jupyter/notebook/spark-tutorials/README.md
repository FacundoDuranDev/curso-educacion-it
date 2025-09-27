# 🚀 SPARK TUTORIALS - APRENDIZAJE PRÁCTICO

## 🎯 **OBJETIVO**
Tutoriales interactivos en Jupyter Notebooks para dominar Apache Spark desde lo básico hasta conceptos avanzados.

---

## 📚 **ESTRUCTURA DE TUTORIALES**

### **📖 [01-Basics](./01-basics/) - Fundamentos de Spark**
> **Para principiantes que quieren entender Spark desde cero**

**Archivos:**
- `01_spark_introduccion.ipynb` - Conceptos básicos y primera configuración (Notebook interactivo)

**Lo que aprenderás:**
- ✅ ¿Qué es Apache Spark?
- ✅ Configuración de SparkSession
- ✅ Conceptos: RDD, DataFrames, Datasets
- ✅ Operaciones básicas (transformaciones y acciones)
- ✅ Lazy Evaluation
- ✅ Trabajo con archivos

---

### **📊 [02-DataFrames](./02-dataframes/) - DataFrames Avanzados**
> **Para usuarios intermedios que quieren dominar DataFrames**

**Archivos:**
- `02_dataframes_avanzado.ipynb` - Operaciones avanzadas con DataFrames (Notebook interactivo)
- `03_guia_completa_dataframes.ipynb` - Guía completa de métodos de DataFrames (Notebook interactivo)

**Lo que aprenderás:**
- ✅ **Guía completa de métodos**: select, filter, joins, groupBy, etc.
- ✅ **Ejemplos prácticos** de cada método con datos reales
- ✅ **Transformaciones complejas** y funciones avanzadas
- ✅ **Joins y operaciones relacionales** (inner, left, right, full)
- ✅ **Agregaciones y Window Functions**
- ✅ **Optimización y caching** para mejor rendimiento
- ✅ **Métodos de salida** y manipulación de datos

---

### **🗄️ [03-SQL](./03-sql/) - Spark SQL**
> **Para usuarios que prefieren SQL para análisis de datos**

**Archivos:**
- `03_spark_sql.ipynb` - Consultas SQL complejas con Spark (Notebook interactivo)

**Lo que aprenderás:**
- ✅ Creación de vistas temporales
- ✅ Consultas SQL básicas y avanzadas
- ✅ Window Functions en SQL
- ✅ CTE (Common Table Expressions)
- ✅ Funciones SQL avanzadas
- ✅ Integración con Hive
- ✅ Optimización de consultas

---

## 🚀 **CÓMO EJECUTAR LOS TUTORIALES**

### **📋 Prerrequisitos:**
1. ✅ Entorno Spark funcionando (`make up`)
2. ✅ Jupyter Lab accesible (`http://localhost:8888`)
3. ✅ PySpark disponible en el entorno

### **✨ Ventajas de los Notebooks Interactivos:**
- 🎯 **Aprendizaje paso a paso**: Ejecuta y entiende cada concepto
- 📊 **Resultados visuales**: Ve los datos y gráficos inmediatamente  
- 🔧 **Experimentación**: Modifica código y ve resultados al instante
- 📝 **Documentación integrada**: Explicaciones entre el código
- 🚀 **Desarrollo rápido**: Ideal para prototipado y testing

### **⚡ Ejecución Paso a Paso:**

#### **1. Verificar que el entorno esté funcionando:**
```bash
# Verificar que Spark esté corriendo
make status

# Verificar conectividad
docker-compose exec master spark-submit --version
```

#### **2. Ejecutar tutoriales individuales:**
```bash
# Tutorial básico
python spark-tutorials/01-basics/01_spark_introduccion.py

# Tutorial de DataFrames
python spark-tutorials/02-dataframes/02_dataframes_avanzado.py

# Tutorial de SQL
python spark-tutorials/03-sql/03_spark_sql.py
```

#### **3. Ejecutar desde Jupyter (Recomendado):**
```bash
# Abrir Jupyter Lab
http://localhost:8888

# Navegar a spark-tutorials/
# Abrir los archivos .ipynb directamente
# Ejecutar celda por celda con Shift+Enter
```

---

## 🎯 **RUTA DE APRENDIZAJE RECOMENDADA**

### **👶 PRINCIPIANTE ABSOLUTO:**
```
1. 📖 01-basics/01_spark_introduccion.ipynb
   → Entender conceptos fundamentales
   → Configurar primera SparkSession
   → Operaciones básicas

2. 📊 02-dataframes/02_dataframes_avanzado.ipynb (parte básica)
   → DataFrames simples
   → Operaciones básicas
   → Filtros y agregaciones

3. 🗄️ 03-sql/03_spark_sql.ipynb (parte básica)
   → Vistas temporales
   → Consultas SQL simples
   → Integración básica
```

### **🔧 USUARIO INTERMEDIO:**
```
1. 📊 02-dataframes/02_dataframes_avanzado.ipynb (completo)
   → Transformaciones complejas
   → Joins y relaciones
   → Window Functions

2. 🗄️ 03-sql/03_spark_sql.ipynb (completo)
   → Consultas SQL avanzadas
   → CTE y subconsultas
   → Optimización

3. 🔄 Combinar ambos enfoques
   → DataFrames + SQL
   → Elegir la mejor herramienta para cada tarea
```

### **⚡ USUARIO AVANZADO:**
```
1. 🎯 Personalizar tutoriales
   → Modificar datos de ejemplo
   → Agregar casos de uso específicos
   → Crear nuevos tutoriales

2. 🔧 Optimización avanzada
   → Caching estratégico
   → Particionado de datos
   → Configuración de cluster

3. 🚀 Integración con ecosistema
   → Hive metastore
   → HDFS storage
   → Kafka streaming (futuro)
```

---

## 📊 **DATOS DE EJEMPLO**

### **🎯 Datasets Incluidos:**
- **Empleados:** Información de empleados con departamentos y salarios
- **Ventas:** Datos de ventas con productos y clientes
- **Productos:** Catálogo de productos con categorías y precios
- **Clientes:** Información de clientes con tipos y ubicaciones

### **📈 Casos de Uso Cubiertos:**
- Análisis de empleados por departamento
- Análisis de ventas por producto/categoría
- Análisis de clientes por tipo/ubicación
- Análisis temporal de datos
- Análisis de rendimiento y optimización

---

## 🛠️ **CONFIGURACIÓN RECOMENDADA**

### **💻 Para Desarrollo Local:**
```python
spark = SparkSession.builder \
    .appName("MiAplicacion") \
    .master("local[*]") \
    .config("spark.executor.memory", "2g") \
    .config("spark.driver.memory", "1g") \
    .getOrCreate()
```

### **🏢 Para Cluster (Curso):**
```python
spark = SparkSession.builder \
    .appName("EducacionIT-Spark") \
    .master("spark://spark-master:7077") \
    .config("spark.executor.memory", "800m") \
    .config("spark.executor.cores", "1") \
    .config("spark.executor.instances", "2") \
    .config("spark.driver.memory", "1g") \
    .enableHiveSupport() \
    .getOrCreate()
```

---

## 🎯 **OBJETIVOS DE APRENDIZAJE**

### **📚 Después de completar los tutoriales podrás:**
- ✅ **Configurar** SparkSession para diferentes entornos
- ✅ **Crear** y manipular DataFrames eficientemente
- ✅ **Escribir** consultas SQL complejas
- ✅ **Optimizar** el rendimiento de aplicaciones Spark
- ✅ **Integrar** Spark con Hive y HDFS
- ✅ **Aplicar** Window Functions para análisis avanzado
- ✅ **Usar** caching y persistencia estratégicamente

---

## 🚨 **SOLUCIÓN DE PROBLEMAS**

### **❌ Error: "Cannot connect to Spark Master"**
```bash
# Verificar que Spark esté corriendo
make status

# Reiniciar si es necesario
make down && make up
```

### **❌ Error: "OutOfMemoryError"**
```python
# Reducir memoria de ejecutores
.config("spark.executor.memory", "512m")
.config("spark.executor.instances", "1")
```

### **❌ Error: "Table not found"**
```python
# Verificar que las vistas estén creadas
spark.sql("SHOW TABLES").show()
```

---

## 📈 **PRÓXIMOS PASOS**

### **🚀 Tutoriales Futuros:**
- **04-Streaming:** Spark Streaming con Kafka
- **05-ML:** Machine Learning con Spark MLlib
- **06-GraphX:** Análisis de grafos
- **07-Examples:** Casos de uso reales

### **🔧 Mejoras Planeadas:**
- Datasets más realistas
- Ejercicios interactivos
- Métricas de rendimiento
- Integración con más fuentes de datos

---

## 💡 **CONSEJOS PARA EL ÉXITO**

### **🎯 Mejores Prácticas:**
1. **Ejecuta** los tutoriales en orden
2. **Modifica** el código para experimentar
3. **Observa** los planes de ejecución
4. **Mide** el rendimiento de tus consultas
5. **Usa** Jupyter para desarrollo interactivo

### **📚 Recursos Adicionales:**
- [Documentación oficial de Spark](https://spark.apache.org/docs/latest/)
- [Guías de optimización](https://spark.apache.org/docs/latest/sql-performance-tuning.html)
- [Ejemplos de PySpark](https://github.com/apache/spark/tree/master/examples/src/main/python)

---

**🎉 ¡Disfruta aprendiendo Spark con estos tutoriales prácticos!**
