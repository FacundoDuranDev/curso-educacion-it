# ⚡ APACHE STORM - GUÍA BÁSICA

## 🎯 **¿QUÉ ES APACHE STORM?**

Apache Storm es un **sistema de procesamiento de streams distribuido** en tiempo real que permite procesar grandes volúmenes de datos continuos con latencia muy baja.

### **🔑 Características principales:**
- **Tiempo real**: Procesamiento con latencia sub-segundo
- **Escalabilidad**: Se escala horizontalmente
- **Tolerancia a fallos**: Garantiza procesamiento de mensajes
- **Integración**: Funciona con Kafka, HBase, Redis, etc.
- **Simplicidad**: API simple para crear topologías

---

## 🏗️ **ARQUITECTURA DE STORM**

### **📋 Componentes principales:**

#### **🌪️ Topology (Topología)**
- **Función**: Define el flujo de procesamiento de datos
- **Contiene**: Spouts y Bolts conectados
- **Ejemplo**: Topología para análisis de tweets

#### **🌊 Spout**
- **Función**: Fuente de datos en la topología
- **Responsabilidad**: Leer datos de fuentes externas
- **Ejemplo**: KafkaSpout, TwitterSpout, DatabaseSpout

#### **⚡ Bolt**
- **Función**: Procesador de datos en la topología
- **Responsabilidad**: Transformar, filtrar, agregar datos
- **Ejemplo**: ParseBolt, FilterBolt, AggregationBolt

#### **🎯 Stream**
- **Función**: Flujo de tuplas entre componentes
- **Contiene**: Datos estructurados (tuplas)
- **Ejemplo**: Stream de tweets, Stream de ventas

#### **📦 Tuple**
- **Función**: Unidad básica de datos en Storm
- **Contiene**: Valores nombrados
- **Ejemplo**: `{"usuario": "juan", "tweet": "Hola mundo"}`

---

## 🚀 **INSTALACIÓN BÁSICA**

### **📋 Prerequisitos:**
```bash
# Java 8 o superior
java -version

# Descargar Storm
wget https://archive.apache.org/dist/storm/apache-storm-2.4.0/apache-storm-2.4.0.tar.gz
tar -xzf apache-storm-2.4.0.tar.gz
cd apache-storm-2.4.0
```

### **🔧 Configuración básica:**
```bash
# Configurar Storm (conf/storm.yaml)
echo "storm.zookeeper.servers:" >> conf/storm.yaml
echo "  - \"localhost\"" >> conf/storm.yaml
echo "nimbus.seeds: [\"localhost\"]" >> conf/storm.yaml
echo "storm.local.dir: \"/tmp/storm\"" >> conf/storm.yaml

# Iniciar Nimbus (maestro)
bin/storm nimbus &

# Iniciar Supervisor (worker)
bin/storm supervisor &

# Iniciar UI web
bin/storm ui &
```

---

## 💻 **COMANDOS BÁSICOS**

### **📋 Gestión de topologías:**
```bash
# Enviar topología
bin/storm jar mi-topologia.jar com.ejemplo.TopologiaEjemplo

# Listar topologías
bin/storm list

# Activar topología
bin/storm activate TopologiaEjemplo

# Desactivar topología
bin/storm deactivate TopologiaEjemplo

# Eliminar topología
bin/storm kill TopologiaEjemplo
```

### **📊 Monitoreo:**
```bash
# Ver logs de topología
bin/storm log TopologiaEjemplo

# Ver UI web
# http://localhost:8080
```

---

## 🐍 **PROGRAMACIÓN EN PYTHON (PYPE)**

### **📦 Instalar Storm Python:**
```bash
pip install streamparse
```

### **🌊 Spout en Python:**
```python
from streamparse import Spout

class TweetSpout(Spout):
    """Spout que lee tweets de una fuente"""
    
    def initialize(self, stormconf, context):
        """Inicialización del spout"""
        self.tweets = [
            "Storm es genial para streaming",
            "Kafka + Storm = Potencia total",
            "Procesamiento en tiempo real rocks!"
        ]
        self.index = 0
    
    def next_tuple(self):
        """Emite la siguiente tupla"""
        if self.index < len(self.tweets):
            tweet = self.tweets[self.index]
            self.emit([tweet])
            self.index += 1
    
    def ack(self, tup_id):
        """Confirmación de procesamiento"""
        pass
    
    def fail(self, tup_id):
        """Manejo de fallos"""
        pass
```

### **⚡ Bolt en Python:**
```python
from streamparse import Bolt

class WordCountBolt(Bolt):
    """Bolt que cuenta palabras en tweets"""
    
    def initialize(self, stormconf, context):
        """Inicialización del bolt"""
        self.word_counts = {}
    
    def process(self, tup):
        """Procesa una tupla"""
        tweet = tup.values[0]
        words = tweet.lower().split()
        
        for word in words:
            # Limpiar palabra
            word = word.strip(".,!?")
            if word:
                # Contar palabra
                self.word_counts[word] = self.word_counts.get(word, 0) + 1
                
                # Emitir resultado
                self.emit([word, self.word_counts[word]])
        
        # Confirmar procesamiento
        self.ack(tup)
```

### **🏗️ Topología en Python:**
```python
from streamparse import Topology
from bolts import WordCountBolt
from spouts import TweetSpout

class TwitterTopology(Topology):
    """Topología para análisis de tweets"""
    
    # Definir spout
    tweet_spout = TweetSpout.spec(name="tweet-spout")
    
    # Definir bolt
    word_count_bolt = WordCountBolt.spec(
        name="word-count-bolt",
        inputs=[tweet_spout]
    )
```

---

## ☕ **PROGRAMACIÓN EN JAVA**

### **🌊 Spout en Java:**
```java
import org.apache.storm.topology.base.BaseRichSpout;
import org.apache.storm.topology.OutputFieldsDeclarer;
import org.apache.storm.tuple.Fields;
import org.apache.storm.tuple.Values;
import org.apache.storm.spout.SpoutOutputCollector;

public class SalesSpout extends BaseRichSpout {
    private SpoutOutputCollector collector;
    private String[] sales = {
        "usuario123,laptop,999.99",
        "usuario456,mouse,25.50",
        "usuario789,teclado,75.00"
    };
    private int index = 0;
    
    @Override
    public void open(Map conf, TopologyContext context, 
                    SpoutOutputCollector collector) {
        this.collector = collector;
    }
    
    @Override
    public void nextTuple() {
        if (index < sales.length) {
            String sale = sales[index];
            collector.emit(new Values(sale));
            index++;
        }
    }
    
    @Override
    public void declareOutputFields(OutputFieldsDeclarer declarer) {
        declarer.declare(new Fields("sale"));
    }
}
```

### **⚡ Bolt en Java:**
```java
import org.apache.storm.topology.base.BaseRichBolt;
import org.apache.storm.topology.OutputFieldsDeclarer;
import org.apache.storm.tuple.Tuple;
import org.apache.storm.tuple.Values;
import org.apache.storm.task.OutputCollector;

public class ParseSaleBolt extends BaseRichBolt {
    private OutputCollector collector;
    
    @Override
    public void prepare(Map stormConf, TopologyContext context, 
                       OutputCollector collector) {
        this.collector = collector;
    }
    
    @Override
    public void execute(Tuple tuple) {
        String sale = tuple.getStringByField("sale");
        String[] parts = sale.split(",");
        
        if (parts.length == 3) {
            String usuario = parts[0];
            String producto = parts[1];
            double precio = Double.parseDouble(parts[2]);
            
            // Emitir tupla parseada
            collector.emit(new Values(usuario, producto, precio));
        }
        
        collector.ack(tuple);
    }
    
    @Override
    public void declareOutputFields(OutputFieldsDeclarer declarer) {
        declarer.declare(new Fields("usuario", "producto", "precio"));
    }
}
```

---

## 🔗 **INTEGRACIÓN CON KAFKA**

### **📦 Dependencias Maven:**
```xml
<dependency>
    <groupId>org.apache.storm</groupId>
    <artifactId>storm-kafka</artifactId>
    <version>2.4.0</version>
</dependency>
```

### **🌊 KafkaSpout:**
```java
import org.apache.storm.kafka.spout.KafkaSpout;
import org.apache.storm.kafka.spout.KafkaSpoutConfig;

// Configurar KafkaSpout
KafkaSpoutConfig<String, String> kafkaConfig = 
    KafkaSpoutConfig.builder("localhost:9092", "mi-topic")
        .setGroupId("storm-group")
        .build();

KafkaSpout<String, String> kafkaSpout = new KafkaSpout<>(kafkaConfig);
```

### **🏗️ Topología con Kafka:**
```java
public class KafkaStormTopology {
    public static void main(String[] args) {
        TopologyBuilder builder = new TopologyBuilder();
        
        // Kafka Spout
        builder.setSpout("kafka-spout", kafkaSpout, 1);
        
        // Procesar datos
        builder.setBolt("process-bolt", new ProcessBolt(), 2)
               .shuffleGrouping("kafka-spout");
        
        // Configurar y enviar topología
        Config config = new Config();
        config.setDebug(true);
        
        LocalCluster cluster = new LocalCluster();
        cluster.submitTopology("kafka-storm-topology", config, 
                              builder.createTopology());
    }
}
```

---

## 📊 **CASOS DE USO COMUNES**

### **📱 Análisis de Redes Sociales:**
- **Trending topics**: Identificar temas populares
- **Sentiment analysis**: Análisis de sentimientos
- **Influencers**: Detectar usuarios influyentes

### **🏪 E-commerce:**
- **Recomendaciones**: Productos sugeridos en tiempo real
- **Fraude**: Detección de transacciones sospechosas
- **Inventario**: Actualizaciones de stock

### **🏭 IoT (Internet de las Cosas):**
- **Monitoreo**: Análisis de sensores en tiempo real
- **Alertas**: Notificaciones de anomalías
- **Telemetría**: Datos de vehículos y máquinas

### **🏦 Fintech:**
- **Trading**: Análisis de mercados financieros
- **Riesgo**: Evaluación crediticia en tiempo real
- **Fraude**: Detección de actividades sospechosas

---

## 🔧 **CONFIGURACIÓN AVANZADA**

### **⚙️ Configuración de workers:**
```yaml
# conf/storm.yaml
supervisor.slots.ports:
  - 6700
  - 6701
  - 6702
  - 6703

worker.heap.memory.mb: 768
topology.worker.max.heap.size.mb: 1024
```

### **📊 Configuración de paralelismo:**
```java
// En la topología
builder.setSpout("spout", new MySpout(), 4);  // 4 tareas
builder.setBolt("bolt", new MyBolt(), 8)      // 8 tareas
       .shuffleGrouping("spout");
```

### **🔄 Agrupaciones (Groupings):**
```java
// Shuffle grouping (distribución aleatoria)
.shuffleGrouping("spout")

// Fields grouping (por campo específico)
.fieldsGrouping("spout", new Fields("user_id"))

// All grouping (a todos los bolts)
.allGrouping("spout")

// Global grouping (a un solo bolt)
.globalGrouping("spout")
```

---

## 📈 **MONITOREO Y MÉTRICAS**

### **📊 Storm UI:**
- **URL**: `http://localhost:8080`
- **Información**: Topologías, workers, throughput
- **Métricas**: Latencia, throughput, errores

### **📋 Comandos de monitoreo:**
```bash
# Ver estado de topologías
bin/storm list

# Ver logs de topología
bin/storm log TopologiaEjemplo

# Ver logs de worker específico
bin/storm log TopologiaEjemplo -n worker-1
```

### **🔍 Métricas importantes:**
- **Throughput**: Tuplas procesadas por segundo
- **Latency**: Tiempo de procesamiento
- **Error rate**: Porcentaje de fallos
- **CPU/Memory**: Uso de recursos

---

## 💡 **MEJORES PRÁCTICAS**

### **🏗️ Diseño de topologías:**
- **Separación de responsabilidades**: Un bolt por transformación
- **Paralelismo apropiado**: Basado en throughput esperado
- **Agrupaciones eficientes**: Minimizar transferencia de datos

### **⚡ Performance:**
- **Batch processing**: Agrupar tuplas cuando sea posible
- **Serialización**: Usar Kryo para mejor performance
- **Buffering**: Configurar buffers apropiados

### **🔒 Confiabilidad:**
- **Acking**: Siempre confirmar tuplas procesadas
- **Retry**: Implementar lógica de reintento
- **Error handling**: Manejar excepciones apropiadamente

---

## 🚨 **SOLUCIÓN DE PROBLEMAS**

### **❌ Problemas comunes:**

#### **Topología no inicia:**
```bash
# Verificar logs de Nimbus
tail -f logs/nimbus.log

# Verificar conectividad con Zookeeper
telnet localhost 2181
```

#### **Alto uso de memoria:**
```bash
# Ajustar heap size
echo "worker.heap.memory.mb: 1024" >> conf/storm.yaml

# Reducir paralelismo
builder.setBolt("bolt", new MyBolt(), 2)  # Reducir de 8 a 2
```

#### **Bolt no procesa tuplas:**
```java
// Verificar que se está haciendo ack
@Override
public void execute(Tuple tuple) {
    try {
        // Procesar tupla
        processTuple(tuple);
        
        // Confirmar procesamiento
        collector.ack(tuple);
    } catch (Exception e) {
        collector.fail(tuple);
    }
}
```

---

## 🎯 **PRÓXIMOS PASOS**

1. **Experimentar** con topologías simples
2. **Integrar** con Kafka para datos reales
3. **Implementar** monitoreo avanzado
4. **Optimizar** performance y confiabilidad
5. **Explorar** Trident (API de alto nivel)

---

## 🔄 **STORM vs OTRAS TECNOLOGÍAS**

### **⚡ Storm vs Spark Streaming:**
- **Storm**: Latencia muy baja, procesamiento evento por evento
- **Spark Streaming**: Latencia más alta, procesamiento por micro-batches

### **⚡ Storm vs Flink:**
- **Storm**: Maduro, ampliamente adoptado
- **Flink**: Más moderno, mejor para análisis complejos

### **⚡ Storm vs Kafka Streams:**
- **Storm**: Framework completo, más complejo
- **Kafka Streams**: Más simple, solo para Kafka

---

**🎉 ¡Ahora conoces los fundamentos de Apache Storm para procesamiento en tiempo real!**
