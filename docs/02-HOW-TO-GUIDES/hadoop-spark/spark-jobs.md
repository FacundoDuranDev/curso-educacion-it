# ⚡ SPARK JOBS - EJEMPLOS PRÁCTICOS

> **🎯 Objetivo:** Ejecutar jobs de Spark y MapReduce para probar el cluster

## 🚀 **CONFIGURACIÓN INICIAL**

### **⚡ Verificar Cluster Activo:**
```bash
# Verificar que todos los servicios estén corriendo
docker-compose ps

# Verificar nodos YARN
docker exec educacionit-master-1 bash -c "yarn node -list"

# Deberías ver algo como:
# Total Nodes:2
#          Node-Id             Node-State Node-Http-Address       Number-of-Running-Containers
#    worker1:42787                RUNNING      worker1:8042                                  0
#    worker2:38363                RUNNING      worker2:8042                                  0
```

### **🔧 Si los nodos no aparecen:**
```bash
# Reiniciar NodeManager en workers
docker exec educacionit-worker-1 bash -c "yarn nodemanager" &
docker exec educacionit-worker-2 bash -c "yarn nodemanager" &

# Esperar y verificar
sleep 10
docker exec educacionit-master-1 bash -c "yarn node -list"
```

---

## 📊 **JOBS DISPONIBLES**

### **🔥 1. SPARK PI CALCULATOR**
**🎯 Objetivo:** Calcular Pi usando Monte Carlo con Spark

#### **⚡ Ejecutar:**
```bash
# Ejecutar desde el master
docker exec educacionit-master-1 bash -c "
spark-submit \
  --master yarn \
  --deploy-mode cluster \
  --driver-memory 1g \
  --driver-cores 1 \
  --executor-memory 800m \
  --executor-cores 1 \
  --num-executors 2 \
  --conf spark.dynamicAllocation.enabled=false \
  --conf spark.shuffle.service.enabled=false \
  --class org.apache.spark.examples.SparkPi \
  /opt/spark/examples/jars/spark-examples_2.12-3.5.3.jar 100
"
```

#### **📊 Verificar Resultado:**
```bash
# Ver aplicaciones en YARN
yarn application -list

# Ver logs de la aplicación
yarn logs -applicationId application_1234567890_0001 | grep "Pi is roughly"
```

#### **🎯 Resultado Esperado:**
```
Pi is roughly 3.141592653589793
```

---

### **📝 2. SPARK WORDCOUNT**
**🎯 Objetivo:** Contar palabras en un archivo usando Spark

#### **📁 Preparar Datos:**
```bash
# Crear archivo de texto de ejemplo
docker exec educacionit-master-1 bash -c "
echo 'Hello World Hello Spark Hello Hadoop' > /tmp/input.txt
hdfs dfs -put /tmp/input.txt /tmp/
"
```

#### **⚡ Ejecutar:**
```bash
# Ejecutar WordCount con Spark
docker exec educacionit-master-1 bash -c "
spark-submit \
  --master yarn \
  --deploy-mode cluster \
  --driver-memory 1g \
  --driver-cores 1 \
  --executor-memory 800m \
  --executor-cores 1 \
  --num-executors 2 \
  --conf spark.dynamicAllocation.enabled=false \
  --conf spark.shuffle.service.enabled=false \
  --class org.apache.spark.examples.JavaWordCount \
  /opt/spark/examples/jars/spark-examples_2.12-3.5.3.jar \
  hdfs://master:9000/tmp/input.txt \
  hdfs://master:9000/tmp/output
"
```

#### **📊 Verificar Resultado:**
```bash
# Ver archivo de salida
hdfs dfs -cat /tmp/output/part-00000

# Resultado esperado:
# Hello: 3
# World: 1
# Spark: 1
# Hadoop: 1
```

---

### **🔢 3. MAPREDUCE PI CALCULATOR**
**🎯 Objetivo:** Calcular Pi usando MapReduce clásico

#### **⚡ Ejecutar:**
```bash
# Ejecutar Pi Calculator con MapReduce
docker exec educacionit-master-1 bash -c "
hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar pi 10 1000000
"
```

#### **📊 Verificar Resultado:**
```bash
# El resultado se muestra en la consola
# Debería mostrar algo como:
# Job finished in X seconds
# Estimated value of Pi is 3.141592653589793
```

---

### **📝 4. MAPREDUCE WORDCOUNT**
**🎯 Objetivo:** Contar palabras usando MapReduce clásico

#### **📁 Preparar Datos:**
```bash
# Crear archivo de texto más grande
docker exec educacionit-master-1 bash -c "
cat > /tmp/input.txt << 'EOF'
Hello World Hello Spark Hello Hadoop
Big Data Analytics with Spark and Hadoop
Machine Learning and Data Science
Apache Spark for Data Processing
Hadoop Distributed File System HDFS
EOF

hdfs dfs -put /tmp/input.txt /tmp/wordcount-input/
"
```

#### **⚡ Ejecutar:**
```bash
# Ejecutar WordCount con MapReduce
docker exec educacionit-master-1 bash -c "
hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar wordcount /tmp/wordcount-input /tmp/wordcount-output
"
```

#### **📊 Verificar Resultado:**
```bash
# Ver archivos de salida
hdfs dfs -ls /tmp/wordcount-output/

# Ver contenido del resultado
hdfs dfs -cat /tmp/wordcount-output/part-r-00000

# Resultado esperado:
# Apache: 1
# Data: 2
# Hadoop: 2
# Hello: 3
# Spark: 2
# World: 1
# ...
```

---

### **🔍 5. MAPREDUCE GREP**
**🎯 Objetivo:** Buscar patrones en texto usando MapReduce

#### **📁 Preparar Datos:**
```bash
# Crear archivo de log de ejemplo
docker exec educacionit-master-1 bash -c "
cat > /tmp/logs.txt << 'EOF'
2024-01-15 10:30:15 INFO Application started
2024-01-15 10:30:16 ERROR Connection failed
2024-01-15 10:30:17 INFO Processing data
2024-01-15 10:30:18 WARN Memory usage high
2024-01-15 10:30:19 ERROR Database timeout
2024-01-15 10:30:20 INFO Job completed
EOF

hdfs dfs -put /tmp/logs.txt /tmp/grep-input/
"
```

#### **⚡ Ejecutar:**
```bash
# Buscar líneas que contengan "ERROR"
docker exec educacionit-master-1 bash -c "
hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar grep /tmp/grep-input /tmp/grep-output 'ERROR'
"
```

#### **📊 Verificar Resultado:**
```bash
# Ver resultado
hdfs dfs -cat /tmp/grep-output/part-r-00000

# Resultado esperado:
# 2024-01-15 10:30:16 ERROR Connection failed
# 2024-01-15 10:30:19 ERROR Database timeout
```

---

### **📊 6. TERAGEN/TERASORT**
**🎯 Objetivo:** Generar y ordenar grandes volúmenes de datos

#### **⚡ Generar Datos:**
```bash
# Generar 1GB de datos (10,000,000 registros)
docker exec educacionit-master-1 bash -c "
hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar teragen 10000000 /tmp/teragen-output
"
```

#### **📊 Verificar Generación:**
```bash
# Ver información del directorio generado
hdfs dfs -ls /tmp/teragen-output/

# Ver tamaño total
hdfs dfs -du -h /tmp/teragen-output/
```

#### **⚡ Ordenar Datos:**
```bash
# Ordenar los datos generados
docker exec educacionit-master-1 bash -c "
hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar terasort /tmp/teragen-output /tmp/terasort-output
"
```

#### **📊 Verificar Ordenamiento:**
```bash
# Verificar que el ordenamiento fue exitoso
docker exec educacionit-master-1 bash -c "
hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar teravalidate /tmp/terasort-output /tmp/teravalidate-output
"

# Ver resultado de validación
hdfs dfs -cat /tmp/teravalidate-output/part-r-00000
```

---

## 🔧 **CONFIGURACIONES AVANZADAS**

### **⚡ Spark con Configuración Personalizada**

#### **🎯 Configuración Optimizada:**
```bash
# Spark con configuración personalizada
docker exec educacionit-master-1 bash -c "
spark-submit \
  --master yarn \
  --deploy-mode cluster \
  --driver-memory 2g \
  --driver-cores 2 \
  --executor-memory 1g \
  --executor-cores 2 \
  --num-executors 4 \
  --conf spark.dynamicAllocation.enabled=true \
  --conf spark.dynamicAllocation.minExecutors=2 \
  --conf spark.dynamicAllocation.maxExecutors=8 \
  --conf spark.shuffle.service.enabled=true \
  --conf spark.sql.adaptive.enabled=true \
  --conf spark.serializer=org.apache.spark.serializer.KryoSerializer \
  --class org.apache.spark.examples.SparkPi \
  /opt/spark/examples/jars/spark-examples_2.12-3.5.3.jar 1000
"
```

### **📊 Monitoreo de Jobs**

#### **🔍 Ver Estado de Aplicaciones:**
```bash
# Listar todas las aplicaciones
yarn application -list

# Ver aplicaciones en ejecución
yarn application -list -appStates RUNNING

# Ver aplicaciones terminadas
yarn application -list -appStates FINISHED

# Ver aplicaciones fallidas
yarn application -list -appStates FAILED
```

#### **📋 Ver Logs Detallados:**
```bash
# Ver logs de aplicación específica
yarn logs -applicationId application_1234567890_0001

# Ver logs de contenedor específico
yarn logs -applicationId application_1234567890_0001 -containerId container_1234567890_0001_01_000001

# Ver logs en tiempo real
yarn logs -applicationId application_1234567890_0001 -follow
```

---

## 🚨 **TROUBLESHOOTING**

### **❌ Problemas Comunes**

#### **🔌 "Application failed"**
```bash
# Ver logs de la aplicación fallida
yarn logs -applicationId application_1234567890_0001

# Verificar recursos disponibles
yarn node -list

# Verificar configuración de memoria
yarn node -list -showDetails
```

#### **💾 "Out of memory"**
```bash
# Reducir memoria por executor
spark-submit \
  --executor-memory 512m \
  --driver-memory 512m \
  --num-executors 1 \
  --class org.apache.spark.examples.SparkPi \
  /opt/spark/examples/jars/spark-examples_2.12-3.5.3.jar 100
```

#### **⏱️ "Job timeout"**
```bash
# Aumentar timeout de aplicación
spark-submit \
  --conf spark.yarn.executor.memoryFraction=0.8 \
  --conf spark.yarn.driver.memoryFraction=0.8 \
  --class org.apache.spark.examples.SparkPi \
  /opt/spark/examples/jars/spark-examples_2.12-3.5.3.jar 100
```

### **🔧 Comandos de Diagnóstico**

#### **📊 Análisis de Rendimiento:**
```bash
# Ver uso de recursos por nodo
yarn node -list -showDetails

# Ver aplicaciones por usuario
yarn application -list -appStates ALL | awk '{print $2}' | sort | uniq -c

# Ver tiempo de ejecución de aplicaciones
yarn application -list -appStates FINISHED | awk '{print $1, $7, $8}'
```

---

## 💡 **MEJORES PRÁCTICAS**

### **✅ Recomendaciones Generales:**

1. **Configuración de Memoria:**
   ```bash
   # Regla general: 75% de RAM para YARN
   # Driver: 1-2GB para jobs pequeños
   # Executor: 800MB-1GB para jobs medianos
   ```

2. **Número de Executors:**
   ```bash
   # Para cluster pequeño (2 workers):
   # - 2-4 executors máximo
   # - 1-2 cores por executor
   # - 800MB-1GB memoria por executor
   ```

3. **Limpieza de Datos:**
   ```bash
   # Limpiar archivos temporales después de cada job
   hdfs dfs -rm -r /tmp/wordcount-output
   hdfs dfs -rm -r /tmp/grep-output
   hdfs dfs -rm -r /tmp/teragen-output
   ```

### **⚡ Optimización de Rendimiento:**

1. **Para Jobs Pequeños:**
   ```bash
   # Usar configuración mínima
   spark-submit \
     --executor-memory 512m \
     --num-executors 1 \
     --executor-cores 1
   ```

2. **Para Jobs Grandes:**
   ```bash
   # Usar configuración optimizada
   spark-submit \
     --executor-memory 1g \
     --num-executors 4 \
     --executor-cores 2 \
     --conf spark.dynamicAllocation.enabled=true
   ```

---

## 🔗 **RECURSOS ADICIONALES**

### **📚 Guías Relacionadas:**
- **Hive Setup:** `hive-setup.md`
- **HDFS Management:** `hdfs-management.md`
- **YARN Monitoring:** `yarn-monitoring.md`

### **🛠️ Herramientas Útiles:**
- **Spark Master UI:** http://localhost:8080
- **YARN Web UI:** http://localhost:8088
- **HDFS Web UI:** http://localhost:9870

### **📖 Documentación:**
- Spark Programming Guide
- MapReduce Tutorial
- YARN Application Development

---

## 🆘 **¿NECESITAS AYUDA?**

### **🚨 Problemas Comunes:**
- **Jobs lentos:** Optimizar configuración de memoria
- **Aplicaciones fallidas:** Verificar logs y recursos
- **Timeout:** Ajustar configuración de tiempo

### **📞 Soporte:**
- **Instructor:** Consulta en clase
- **Logs:** `yarn logs -applicationId <ID>`
- **Documentación:** Spark official docs

**🎯 ¡Con estos jobs de prueba, ya puedes validar que tu cluster funciona correctamente!**
