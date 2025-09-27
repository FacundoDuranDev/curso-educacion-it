# 📨 APACHE KAFKA - GUÍA BÁSICA

## 🎯 **¿QUÉ ES KAFKA?**

Apache Kafka es un **sistema de mensajería distribuida** y **plataforma de streaming** que permite manejar grandes volúmenes de datos en tiempo real.

### **🔑 Características principales:**
- **Alto rendimiento**: Procesa millones de mensajes por segundo
- **Escalabilidad**: Se distribuye horizontalmente
- **Durabilidad**: Los mensajes se persisten en disco
- **Tolerancia a fallos**: Replicación automática
- **Tiempo real**: Latencia baja para streaming

---

## 🏗️ **ARQUITECTURA DE KAFKA**

### **📋 Componentes principales:**

#### **🎯 Broker**
- **Función**: Nodo individual en el cluster de Kafka
- **Responsabilidad**: Almacena y sirve datos
- **Ejemplo**: `kafka-broker-1`, `kafka-broker-2`, `kafka-broker-3`

#### **📝 Topic**
- **Función**: Categoría o canal donde se publican mensajes
- **Analogía**: Como un "canal de TV" para datos
- **Ejemplo**: `ventas`, `usuarios`, `logs-sistema`

#### **📊 Partition**
- **Función**: División de un topic para paralelismo
- **Beneficio**: Permite procesamiento paralelo
- **Ejemplo**: `ventas-partition-0`, `ventas-partition-1`

#### **✍️ Producer**
- **Función**: Aplicación que envía mensajes
- **Ejemplo**: Sensor IoT, aplicación web, base de datos

#### **👂 Consumer**
- **Función**: Aplicación que lee mensajes
- **Ejemplo**: Sistema de análisis, dashboard, base de datos

---

## 🚀 **INSTALACIÓN BÁSICA**

### **📋 Prerequisitos:**
```bash
# Java 8 o superior
java -version

# Descargar Kafka
wget https://downloads.apache.org/kafka/2.8.1/kafka_2.13-2.8.1.tgz
tar -xzf kafka_2.13-2.8.1.tgz
cd kafka_2.13-2.8.1
```

### **🔧 Configuración básica:**
```bash
# Configurar Zookeeper (requerido para Kafka)
bin/zookeeper-server-start.sh config/zookeeper.properties

# Iniciar Kafka Broker
bin/kafka-server-start.sh config/server.properties
```

---

## 💻 **COMANDOS BÁSICOS**

### **📝 Crear un Topic:**
```bash
bin/kafka-topics.sh --create \
  --bootstrap-server localhost:9092 \
  --replication-factor 1 \
  --partitions 3 \
  --topic ventas
```

### **📋 Listar Topics:**
```bash
bin/kafka-topics.sh --list \
  --bootstrap-server localhost:9092
```

### **📊 Ver detalles de un Topic:**
```bash
bin/kafka-topics.sh --describe \
  --bootstrap-server localhost:9092 \
  --topic ventas
```

### **✍️ Enviar mensajes (Producer):**
```bash
bin/kafka-console-producer.sh \
  --bootstrap-server localhost:9092 \
  --topic ventas
```

### **👂 Leer mensajes (Consumer):**
```bash
bin/kafka-console-consumer.sh \
  --bootstrap-server localhost:9092 \
  --topic ventas \
  --from-beginning
```

---

## 🐍 **INTEGRACIÓN CON PYTHON**

### **📦 Instalar librería:**
```bash
pip install kafka-python
```

### **✍️ Producer en Python:**
```python
from kafka import KafkaProducer
import json

# Configurar producer
producer = KafkaProducer(
    bootstrap_servers=['localhost:9092'],
    value_serializer=lambda x: json.dumps(x).encode('utf-8')
)

# Enviar mensaje
mensaje = {
    'usuario': 'juan123',
    'producto': 'laptop',
    'precio': 999.99,
    'timestamp': '2024-01-15T10:30:00Z'
}

producer.send('ventas', mensaje)
producer.flush()  # Asegurar que se envíe
```

### **👂 Consumer en Python:**
```python
from kafka import KafkaConsumer
import json

# Configurar consumer
consumer = KafkaConsumer(
    'ventas',
    bootstrap_servers=['localhost:9092'],
    value_deserializer=lambda m: json.loads(m.decode('utf-8'))
)

# Leer mensajes
for mensaje in consumer:
    print(f"Recibido: {mensaje.value}")
    print(f"Partición: {mensaje.partition}")
    print(f"Offset: {mensaje.offset}")
```

---

## ⚡ **INTEGRACIÓN CON SPARK STREAMING**

### **📦 Configuración en Spark:**
```python
from pyspark.sql import SparkSession
from pyspark.sql.functions import *

# Crear SparkSession con Kafka
spark = SparkSession.builder \
    .appName("KafkaSparkStreaming") \
    .config("spark.jars.packages", "org.apache.spark:spark-sql-kafka-0-10_2.12:3.3.0") \
    .getOrCreate()

# Leer desde Kafka
df_kafka = spark \
    .readStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", "localhost:9092") \
    .option("subscribe", "ventas") \
    .load()

# Procesar datos
df_procesado = df_kafka.select(
    col("key").cast("string"),
    col("value").cast("string"),
    col("timestamp")
).select(
    from_json(col("value"), "usuario string, producto string, precio double").alias("data"),
    col("timestamp")
)

# Mostrar resultados
query = df_procesado.writeStream \
    .outputMode("append") \
    .format("console") \
    .start()

query.awaitTermination()
```

---

## 📊 **CASOS DE USO COMUNES**

### **🏪 E-commerce:**
- **Tracking de eventos**: Clicks, compras, navegación
- **Recomendaciones**: Análisis en tiempo real
- **Inventario**: Actualizaciones de stock

### **📱 Aplicaciones móviles:**
- **Analytics**: Eventos de usuario
- **Notificaciones**: Push notifications
- **Logs**: Errores y métricas

### **🏭 IoT (Internet de las Cosas):**
- **Sensores**: Datos de temperatura, presión, etc.
- **Telemetría**: Datos de vehículos, máquinas
- **Alertas**: Detección de anomalías

### **🏦 Fintech:**
- **Transacciones**: Procesamiento de pagos
- **Fraude**: Detección en tiempo real
- **Riesgo**: Evaluación crediticia

---

## 🔧 **CONFIGURACIÓN AVANZADA**

### **📊 Configuración de particiones:**
```bash
# Aumentar particiones para mejor paralelismo
bin/kafka-topics.sh --alter \
  --bootstrap-server localhost:9092 \
  --topic ventas \
  --partitions 6
```

### **🔄 Configuración de replicación:**
```bash
# Crear topic con replicación
bin/kafka-topics.sh --create \
  --bootstrap-server localhost:9092 \
  --replication-factor 3 \
  --partitions 3 \
  --topic datos-criticos
```

### **⏰ Configuración de retención:**
```bash
# Configurar retención de 7 días
bin/kafka-configs.sh --alter \
  --bootstrap-server localhost:9092 \
  --entity-type topics \
  --entity-name ventas \
  --add-config retention.ms=604800000
```

---

## 📈 **MONITOREO Y MÉTRICAS**

### **📊 Comandos de monitoreo:**
```bash
# Ver métricas del cluster
bin/kafka-consumer-groups.sh \
  --bootstrap-server localhost:9092 \
  --list

# Ver lag de consumidores
bin/kafka-consumer-groups.sh \
  --bootstrap-server localhost:9092 \
  --group mi-grupo \
  --describe
```

### **🔍 Logs importantes:**
- **server.log**: Logs del broker
- **controller.log**: Logs del controlador
- **state-change.log**: Cambios de estado

---

## 💡 **MEJORES PRÁCTICAS**

### **🎯 Diseño de Topics:**
- **Nombres descriptivos**: `ventas-online`, `logs-error`
- **Particiones apropiadas**: Basado en throughput esperado
- **Replicación**: Mínimo 3 para producción

### **⚡ Performance:**
- **Batch size**: Configurar para throughput óptimo
- **Compresión**: Habilitar para ahorrar ancho de banda
- **Ack**: Usar `acks=1` para balance entre performance y durabilidad

### **🔒 Seguridad:**
- **Autenticación**: SASL/PLAIN o SASL/SCRAM
- **Autorización**: ACLs para control de acceso
- **Encriptación**: TLS para datos en tránsito

---

## 🚨 **SOLUCIÓN DE PROBLEMAS**

### **❌ Problemas comunes:**

#### **Consumer no recibe mensajes:**
```bash
# Verificar que el topic existe
bin/kafka-topics.sh --list --bootstrap-server localhost:9092

# Verificar que hay mensajes
bin/kafka-console-consumer.sh \
  --bootstrap-server localhost:9092 \
  --topic mi-topic \
  --from-beginning
```

#### **Producer no puede enviar:**
```bash
# Verificar conectividad
telnet localhost 9092

# Verificar configuración del broker
grep "listeners" config/server.properties
```

#### **Alto lag de consumidores:**
```bash
# Ver lag por grupo de consumidores
bin/kafka-consumer-groups.sh \
  --bootstrap-server localhost:9092 \
  --describe --all-groups
```

---

## 🎯 **PRÓXIMOS PASOS**

1. **Experimentar** con casos de uso simples
2. **Integrar** con Spark Streaming
3. **Configurar** un cluster multi-broker
4. **Implementar** monitoreo avanzado
5. **Explorar** Kafka Connect para integración

---

**🎉 ¡Ahora conoces los fundamentos de Apache Kafka para streaming de datos!**
