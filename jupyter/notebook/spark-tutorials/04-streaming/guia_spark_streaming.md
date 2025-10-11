# 📚 Guía Completa de Spark Streaming

## Índice

1. [Introducción a Spark Streaming](#introduccion)
2. [Conceptos Fundamentales](#conceptos)
3. [Comandos de Lectura](#lectura)
4. [Transformaciones](#transformaciones)
5. [Agregaciones con Ventanas](#ventanas)
6. [Comandos de Escritura](#escritura)
7. [Configuración Avanzada](#configuracion)
8. [Monitoreo y Debugging](#monitoreo)
9. [Patrones Comunes](#patrones)
10. [Best Practices](#best-practices)

---

## 1. Introducción a Spark Streaming {#introduccion}

### ¿Qué es Spark Structured Streaming?

Spark Structured Streaming es una API de procesamiento de streams escalable y tolerante a fallos, construida sobre Spark SQL. Trata los datos de streaming como una tabla que crece continuamente.

### Conceptos Clave

- **Micro-batching**: Procesa datos en pequeños lotes
- **Event Time**: Tiempo en que ocurrió el evento
- **Processing Time**: Tiempo en que se procesó el evento
- **Watermark**: Maneja datos tardíos
- **Checkpointing**: Recuperación ante fallos

---

## 2. Conceptos Fundamentales {#conceptos}

### Arquitectura del Streaming

```
Input Source → Streaming DataFrame → Transformations → Output Sink
```

### Tipos de Input Sources

1. **Kafka**: Sistema de mensajería distribuido
2. **File Sources**: Archivos CSV, JSON, Parquet
3. **Socket**: Conexiones TCP
4. **Rate Source**: Generador de datos para testing

### Tipos de Output Sinks

1. **Parquet**: Almacenamiento columnar eficiente
2. **Memory**: Tabla temporal en memoria
3. **Console**: Salida a consola para debugging
4. **Kafka**: Publicar a Kafka
5. **ForeachBatch**: Procesamiento personalizado

---

## 3. Comandos de Lectura {#lectura}

### 3.1. Leer desde Kafka

```python
# Básico
df = spark.readStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", "localhost:9092") \
    .option("subscribe", "topic_name") \
    .load()

# Con múltiples topics
df = spark.readStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", "localhost:9092") \
    .option("subscribe", "topic1,topic2,topic3") \
    .load()

# Con pattern de topics
df = spark.readStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", "localhost:9092") \
    .option("subscribePattern", "topic-.*") \
    .load()

# Con offset inicial
df = spark.readStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", "localhost:9092") \
    .option("subscribe", "topic_name") \
    .option("startingOffsets", "earliest")  # o "latest"
    .load()

# Con offset específico
df = spark.readStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", "localhost:9092") \
    .option("subscribe", "topic_name") \
    .option("startingOffsets", """{"topic_name":{"0":23,"1":-1}}""")
    .load()
```

### 3.2. Leer desde Archivos

```python
# CSV
df = spark.readStream \
    .schema(my_schema) \
    .option("header", "true") \
    .csv("/path/to/directory")

# JSON
df = spark.readStream \
    .schema(my_schema) \
    .json("/path/to/directory")

# Parquet
df = spark.readStream \
    .schema(my_schema) \
    .parquet("/path/to/directory")

# Con opciones de archivos
df = spark.readStream \
    .schema(my_schema) \
    .option("maxFilesPerTrigger", 10) \
    .option("latestFirst", "true") \
    .json("/path/to/directory")
```

### 3.3. Leer desde Socket (para testing)

```python
df = spark.readStream \
    .format("socket") \
    .option("host", "localhost") \
    .option("port", 9999) \
    .load()
```

### 3.4. Rate Source (para testing)

```python
# Genera datos sintéticos
df = spark.readStream \
    .format("rate") \
    .option("rowsPerSecond", 100) \
    .load()
```

---

## 4. Transformaciones {#transformaciones}

### 4.1. Parsear JSON desde Kafka

```python
from pyspark.sql.functions import col, from_json
from pyspark.sql.types import StructType, StructField, StringType, IntegerType

# Definir schema
schema = StructType([
    StructField("userId", IntegerType()),
    StructField("movieId", IntegerType()),
    StructField("rating", DoubleType()),
    StructField("timestamp", LongType())
])

# Parsear
parsed_df = df \
    .selectExpr("CAST(value AS STRING) as json") \
    .select(from_json(col("json"), schema).alias("data")) \
    .select("data.*")
```

### 4.2. Filtros

```python
# Filtrar por condición simple
filtered_df = df.filter(col("rating") > 3.0)

# Filtrar con múltiples condiciones
filtered_df = df.filter(
    (col("rating") > 3.0) & 
    (col("userId") > 100)
)

# Filtrar valores nulos
filtered_df = df.filter(col("movieId").isNotNull())
```

### 4.3. Seleccionar y Transformar Columnas

```python
# Seleccionar columnas
selected_df = df.select("userId", "movieId", "rating")

# Renombrar columnas
renamed_df = df.withColumnRenamed("userId", "user_id")

# Agregar columnas calculadas
from pyspark.sql.functions import current_timestamp, to_timestamp

transformed_df = df \
    .withColumn("processing_time", current_timestamp()) \
    .withColumn("event_time", to_timestamp(col("timestamp")))

# Cast de tipos
casted_df = df.withColumn("rating", col("rating").cast("double"))
```

### 4.4. Joins con Tablas Estáticas

```python
# Cargar tabla estática
movies_df = spark.read.csv("movies.csv", header=True)

# Stream-Static Join
enriched_df = streaming_df.join(
    movies_df,
    on="movieId",
    how="left"
)
```

### 4.5. Operaciones de String

```python
from pyspark.sql.functions import split, explode, lower, upper, trim

# Split y explode
genres_df = df \
    .withColumn("genre_array", split(col("genres"), "\\|")) \
    .withColumn("genre", explode(col("genre_array")))

# Transformaciones de texto
text_df = df \
    .withColumn("title_lower", lower(col("title"))) \
    .withColumn("title_upper", upper(col("title"))) \
    .withColumn("title_trimmed", trim(col("title")))
```

---

## 5. Agregaciones con Ventanas {#ventanas}

### 5.1. Watermarks

```python
from pyspark.sql.functions import window

# Agregar watermark (maneja datos tardíos)
watermarked_df = df \
    .withWatermark("event_time", "10 minutes")
```

**Watermark**: Especifica cuánto tiempo esperar por datos tardíos
- Eventos más antiguos que el watermark se descartan
- Balance entre latencia y completitud

### 5.2. Ventanas de Tiempo (Tumbling Windows)

```python
# Ventana de 5 minutos sin solapamiento
windowed_df = df \
    .withWatermark("event_time", "10 minutes") \
    .groupBy(
        window("event_time", "5 minutes"),
        "movieId"
    ) \
    .count()
```

### 5.3. Ventanas Deslizantes (Sliding Windows)

```python
# Ventana de 10 minutos que se desliza cada 5 minutos
sliding_df = df \
    .withWatermark("event_time", "10 minutes") \
    .groupBy(
        window("event_time", "10 minutes", "5 minutes"),
        "movieId"
    ) \
    .count()
```

### 5.4. Agregaciones Completas

```python
from pyspark.sql.functions import (
    avg, sum, count, max, min, stddev, 
    countDistinct, collect_list, approx_count_distinct
)

# Agregaciones múltiples
agg_df = df \
    .withWatermark("event_time", "10 minutes") \
    .groupBy(
        window("event_time", "5 minutes"),
        "movieId"
    ) \
    .agg(
        avg("rating").alias("avg_rating"),
        count("*").alias("rating_count"),
        max("rating").alias("max_rating"),
        min("rating").alias("min_rating"),
        stddev("rating").alias("stddev_rating"),
        countDistinct("userId").alias("unique_users"),
        collect_list("userId").alias("user_list"),
        approx_count_distinct("userId").alias("approx_unique_users")
    )
```

### 5.5. Agregaciones sin Ventanas de Tiempo

```python
# Agregación global (requiere outputMode="complete")
global_agg = df \
    .groupBy("movieId") \
    .agg(
        avg("rating").alias("avg_rating"),
        count("*").alias("total_ratings")
    )
```

### 5.6. Session Windows

```python
from pyspark.sql.functions import session_window

# Ventana de sesión (agrupa eventos cercanos en el tiempo)
session_df = df \
    .withWatermark("event_time", "10 minutes") \
    .groupBy(
        session_window("event_time", "5 minutes"),
        "userId"
    ) \
    .count()
```

---

## 6. Comandos de Escritura {#escritura}

### 6.1. Modos de Salida

1. **Append**: Solo nuevos registros (default)
2. **Complete**: Toda la tabla actualizada
3. **Update**: Solo registros actualizados

### 6.2. Escribir a Consola

```python
# Básico
query = df.writeStream \
    .outputMode("append") \
    .format("console") \
    .start()

# Con opciones
query = df.writeStream \
    .outputMode("append") \
    .format("console") \
    .option("truncate", "false") \
    .option("numRows", 20) \
    .start()
```

### 6.3. Escribir a Parquet

```python
query = df.writeStream \
    .outputMode("append") \
    .format("parquet") \
    .option("path", "/output/path") \
    .option("checkpointLocation", "/checkpoint/path") \
    .start()

# Con particionamiento
query = df.writeStream \
    .outputMode("append") \
    .format("parquet") \
    .option("path", "/output/path") \
    .option("checkpointLocation", "/checkpoint/path") \
    .partitionBy("year", "month", "day") \
    .start()
```

### 6.4. Escribir a Kafka

```python
# Preparar datos para Kafka
kafka_df = df \
    .selectExpr(
        "CAST(movieId AS STRING) AS key",
        "to_json(struct(*)) AS value"
    )

# Escribir a Kafka
query = kafka_df.writeStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", "localhost:9092") \
    .option("topic", "output-topic") \
    .option("checkpointLocation", "/checkpoint/path") \
    .start()
```

### 6.5. Escribir a Memoria (para queries interactivas)

```python
query = df.writeStream \
    .outputMode("complete") \
    .format("memory") \
    .queryName("my_table") \
    .start()

# Luego query la tabla
result = spark.sql("SELECT * FROM my_table")
result.show()
```

### 6.6. ForeachBatch (procesamiento personalizado)

```python
def process_batch(batch_df, batch_id):
    """Función personalizada para procesar cada batch"""
    print(f"Processing batch {batch_id}")
    
    # Puedes hacer múltiples escrituras
    batch_df.write.format("parquet").mode("append").save("/path1")
    batch_df.write.format("delta").mode("append").save("/path2")
    
    # O procesamiento complejo
    if batch_df.count() > 1000:
        print("High volume detected!")

query = df.writeStream \
    .foreachBatch(process_batch) \
    .start()
```

### 6.7. Foreach (procesamiento por registro)

```python
class MyForeachWriter:
    def open(self, partition_id, epoch_id):
        # Se llama al abrir cada partition
        return True
    
    def process(self, row):
        # Procesar cada fila
        print(f"Processing: {row}")
    
    def close(self, error):
        # Se llama al cerrar partition
        pass

query = df.writeStream \
    .foreach(MyForeachWriter()) \
    .start()
```

---

## 7. Configuración Avanzada {#configuracion}

### 7.1. Configuración de SparkSession

```python
spark = SparkSession.builder \
    .appName("StreamingApp") \
    .config("spark.jars.packages", "org.apache.spark:spark-sql-kafka-0-10_2.12:3.5.1") \
    .config("spark.sql.streaming.checkpointLocation", "/checkpoint") \
    .config("spark.sql.shuffle.partitions", "8") \
    .config("spark.sql.streaming.stateStore.maintenanceInterval", "60s") \
    .config("spark.sql.streaming.metricsEnabled", "true") \
    .getOrCreate()
```

### 7.2. Configuración de Triggers

```python
# Procesamiento continuo (máxima frecuencia)
query = df.writeStream \
    .trigger(processingTime='0 seconds') \
    .format("console") \
    .start()

# Micro-batch cada 10 segundos
query = df.writeStream \
    .trigger(processingTime='10 seconds') \
    .format("console") \
    .start()

# Trigger con intervalo específico
query = df.writeStream \
    .trigger(processingTime='5 minutes') \
    .format("console") \
    .start()

# Trigger once (procesar una vez y parar)
query = df.writeStream \
    .trigger(once=True) \
    .format("console") \
    .start()

# Continuous trigger (experimental, baja latencia)
query = df.writeStream \
    .trigger(continuous='1 second') \
    .format("console") \
    .start()
```

### 7.3. Configuración de Kafka

```python
df = spark.readStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", "host1:9092,host2:9092") \
    .option("subscribe", "topic") \
    .option("kafka.security.protocol", "SASL_SSL") \
    .option("kafka.sasl.mechanism", "PLAIN") \
    .option("kafka.sasl.jaas.config", "...") \
    .option("kafka.ssl.truststore.location", "/path/to/truststore") \
    .option("kafka.ssl.truststore.password", "password") \
    .option("maxOffsetsPerTrigger", 10000) \
    .option("failOnDataLoss", "false") \
    .load()
```

---

## 8. Monitoreo y Debugging {#monitoreo}

### 8.1. Información de la Query

```python
# Estado de la query
query.status

# Progreso reciente
query.recentProgress

# Último progreso
query.lastProgress

# ID de la query
query.id

# Nombre de la query
query.name

# Check si está activa
query.isActive

# Exception si hubo error
query.exception()
```

### 8.2. Esperar y Detener Queries

```python
# Esperar indefinidamente
query.awaitTermination()

# Esperar con timeout
query.awaitTermination(timeout=30)

# Detener query
query.stop()

# Detener todas las queries
for query in spark.streams.active:
    query.stop()
```

### 8.3. Métricas Detalladas

```python
progress = query.lastProgress

if progress:
    print(f"Batch ID: {progress['batchId']}")
    print(f"Input Rows: {progress['numInputRows']}")
    print(f"Processing Rate: {progress.get('processedRowsPerSecond', 0)} rows/sec")
    print(f"Duration: {progress['durationMs']['total']} ms")
    
    # Información de sources
    for source in progress.get('sources', []):
        print(f"Source: {source['description']}")
        print(f"  Start Offset: {source.get('startOffset', 'N/A')}")
        print(f"  End Offset: {source.get('endOffset', 'N/A')}")
    
    # Información de sink
    sink = progress.get('sink', {})
    print(f"Sink: {sink.get('description', 'N/A')}")
```

### 8.4. Logging

```python
# Configurar nivel de logging
spark.sparkContext.setLogLevel("WARN")  # WARN, INFO, DEBUG, ERROR

# En el código
import logging
logger = logging.getLogger(__name__)
logger.info("Processing batch")
```

---

## 9. Patrones Comunes {#patrones}

### 9.1. Deduplicación

```python
# Por columnas específicas dentro de una ventana
dedup_df = df \
    .withWatermark("event_time", "10 minutes") \
    .dropDuplicates(["userId", "movieId"])
```

### 9.2. Late Data Handling

```python
# Con watermark
handled_df = df \
    .withWatermark("event_time", "1 hour") \
    .groupBy(
        window("event_time", "10 minutes"),
        "movieId"
    ) \
    .count()

# Los eventos más antiguos que 1 hora se descartan
```

### 9.3. Stream-Stream Joins

```python
# Inner join
joined_df = stream1.join(
    stream2,
    expr("""
        stream1.userId = stream2.userId AND
        stream1.event_time BETWEEN stream2.event_time AND stream2.event_time + interval 1 hour
    """)
)

# Con watermarks
joined_df = stream1 \
    .withWatermark("event_time", "10 minutes") \
    .join(
        stream2.withWatermark("event_time", "20 minutes"),
        "userId"
    )
```

### 9.4. Stateful Operations

```python
from pyspark.sql.streaming import GroupState

def update_state(key, values, state: GroupState):
    """Mantiene estado entre batches"""
    if state.exists:
        old_state = state.get
    else:
        old_state = {"count": 0, "sum": 0.0}
    
    new_count = old_state["count"] + len(values)
    new_sum = old_state["sum"] + sum([v.rating for v in values])
    
    new_state = {"count": new_count, "sum": new_sum}
    state.update(new_state)
    
    return (key, new_state["sum"] / new_state["count"])

# Usar mapGroupsWithState
stateful_df = df \
    .groupByKey(lambda x: x.userId) \
    .mapGroupsWithState(update_state)
```

---

## 10. Best Practices {#best-practices}

### 10.1. Performance

1. **Particionamiento apropiado**
```python
# Configurar particiones según volumen
spark.conf.set("spark.sql.shuffle.partitions", "200")
```

2. **Usar watermarks siempre que sea posible**
```python
df.withWatermark("event_time", "10 minutes")
```

3. **Limitar datos con `maxFilesPerTrigger` o `maxOffsetsPerTrigger`**
```python
.option("maxOffsetsPerTrigger", 10000)
```

4. **Cache de tablas estáticas en joins**
```python
static_df.cache()
```

### 10.2. Confiabilidad

1. **Siempre especificar checkpointLocation**
```python
.option("checkpointLocation", "/reliable/path")
```

2. **Manejar failures**
```python
.option("failOnDataLoss", "false")  # Solo en desarrollo
```

3. **Monitorear métricas**
```python
query.lastProgress
```

### 10.3. Debugging

1. **Usar console sink para debugging**
```python
debug_query = df.writeStream \
    .format("console") \
    .option("truncate", "false") \
    .start()
```

2. **Escribir a memoria para queries interactivas**
```python
.format("memory").queryName("debug_table")
```

3. **Usar `explain()` para entender el plan**
```python
df.explain(True)
```

### 10.4. Schema Management

1. **Siempre definir schemas explícitos**
```python
schema = StructType([...])
df = spark.readStream.schema(schema).json("path")
```

2. **Schema evolution**
```python
.option("mergeSchema", "true")
```

### 10.5. Resource Management

1. **Configurar memoria apropiadamente**
```python
.config("spark.executor.memory", "4g")
.config("spark.driver.memory", "2g")
```

2. **Limitar recursos por query**
```python
.config("spark.sql.streaming.maxBatchSize", "1000000")
```

3. **Cleanup de checkpoints viejos**
```python
.config("spark.sql.streaming.minBatchesToRetain", "100")
```

---

## 📝 Ejemplos Completos

### Ejemplo 1: Pipeline Simple

```python
# Leer desde Kafka
df = spark.readStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", "localhost:9092") \
    .option("subscribe", "input-topic") \
    .load()

# Transformar
parsed_df = df \
    .selectExpr("CAST(value AS STRING) as json") \
    .select(from_json(col("json"), schema).alias("data")) \
    .select("data.*") \
    .filter(col("rating") > 3.0)

# Escribir a Parquet
query = parsed_df.writeStream \
    .outputMode("append") \
    .format("parquet") \
    .option("path", "/output") \
    .option("checkpointLocation", "/checkpoint") \
    .start()

query.awaitTermination()
```

### Ejemplo 2: Agregación con Ventanas

```python
# Leer y parsear
df = spark.readStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", "localhost:9092") \
    .option("subscribe", "ratings") \
    .load() \
    .selectExpr("CAST(value AS STRING) as json") \
    .select(from_json(col("json"), schema).alias("data")) \
    .select("data.*") \
    .withColumn("event_time", to_timestamp(col("timestamp")))

# Agregar con ventanas
windowed_df = df \
    .withWatermark("event_time", "10 minutes") \
    .groupBy(
        window("event_time", "5 minutes"),
        "movieId"
    ) \
    .agg(
        avg("rating").alias("avg_rating"),
        count("*").alias("count")
    )

# Escribir
query = windowed_df.writeStream \
    .outputMode("append") \
    .format("console") \
    .start()

query.awaitTermination()
```

### Ejemplo 3: Multi-Sink

```python
def write_to_multiple_sinks(df, batch_id):
    # Sink 1: Parquet
    df.write.format("parquet").mode("append").save("/parquet/output")
    
    # Sink 2: Console (filtrado)
    df.filter(col("rating") > 4.0).show(truncate=False)
    
    # Sink 3: Alertas (enviar a Kafka)
    alerts = df.filter(col("rating") < 2.0)
    if alerts.count() > 0:
        alerts.selectExpr("to_json(struct(*)) AS value") \
            .write \
            .format("kafka") \
            .option("kafka.bootstrap.servers", "localhost:9092") \
            .option("topic", "alerts") \
            .save()

query = df.writeStream \
    .foreachBatch(write_to_multiple_sinks) \
    .start()
```

---

## 🔧 Troubleshooting Common Issues

### Issue 1: "org.apache.spark.sql.AnalysisException: queries with streaming sources must be executed with writeStream"

**Solución**: No usar `.show()` o `.collect()` en streaming DataFrames. Usar `.writeStream` en su lugar.

### Issue 2: "java.lang.ClassNotFoundException: org.apache.spark.sql.kafka010.KafkaSourceProvider"

**Solución**: Agregar el package de Kafka:
```python
.config("spark.jars.packages", "org.apache.spark:spark-sql-kafka-0-10_2.12:3.5.1")
```

### Issue 3: Checkpoint incompatible

**Solución**: Cambiar el checkpoint location o eliminarlo:
```bash
rm -rf /path/to/checkpoint
```

### Issue 4: Out of Memory

**Solución**:
```python
.config("spark.executor.memory", "8g")
.config("spark.driver.memory", "4g")
.config("spark.sql.shuffle.partitions", "200")
```

### Issue 5: Slow Processing

**Solución**:
- Aumentar paralelismo: `.config("spark.default.parallelism", "100")`
- Usar watermarks apropiados
- Reducir `maxOffsetsPerTrigger`
- Optimizar transformaciones

---

## 📚 Referencias

- [Spark Structured Streaming Programming Guide](https://spark.apache.org/docs/latest/structured-streaming-programming-guide.html)
- [Spark SQL Guide](https://spark.apache.org/docs/latest/sql-programming-guide.html)
- [Kafka Integration Guide](https://spark.apache.org/docs/latest/structured-streaming-kafka-integration.html)

---

**¡Fin de la Guía!** 🎉

Esta guía cubre los conceptos y comandos más importantes de Spark Structured Streaming. Úsala como referencia rápida para tus proyectos de streaming.

