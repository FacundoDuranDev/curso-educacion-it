#!/bin/bash

# Job 6: Spark WordCount - Contador de palabras usando Spark
# Este job hace lo mismo que WordCount pero usando Spark

echo "=== JOB 6: SPARK WORDCOUNT ==="
echo "Preparando datos para Spark WordCount..."

# Crear directorio de entrada
hdfs dfs -mkdir -p /jobs-prueba/spark-wordcount/input

# Crear archivo de texto más grande
cat > texto-spark.txt << EOF
Apache Spark es un motor de procesamiento de datos unificado
Spark es rápido y fácil de usar
Spark incluye soporte para SQL, streaming, machine learning y graph processing
Spark puede ejecutarse en Hadoop, Apache Mesos, Kubernetes o en modo standalone
Spark utiliza RDDs (Resilient Distributed Datasets) para el procesamiento
Spark tiene APIs en Scala, Java, Python y R
Spark es más rápido que MapReduce para la mayoría de trabajos
Spark mantiene datos en memoria para mejor rendimiento
Spark incluye Spark SQL para consultas estructuradas
Spark incluye MLlib para machine learning
Spark incluye GraphX para procesamiento de grafos
Spark incluye Spark Streaming para procesamiento en tiempo real
Spark es desarrollado por Apache Software Foundation
Spark es ampliamente utilizado en big data y analytics
Spark tiene una comunidad activa y documentación extensa
EOF

# Subir archivo a HDFS
hdfs dfs -put texto-spark.txt /jobs-prueba/spark-wordcount/input/

echo "Datos preparados. Ejecutando Spark WordCount..."

# Ejecutar Spark WordCount
spark-submit \
  --master yarn \
  --deploy-mode cluster \
  --num-executors 2 \
  --executor-memory 1g \
  --executor-cores 1 \
  --class org.apache.spark.examples.JavaWordCount \
  /opt/spark/examples/jars/spark-examples_2.12-*.jar \
  hdfs://master:8020/jobs-prueba/spark-wordcount/input \
  hdfs://master:8020/jobs-prueba/spark-wordcount/output

echo "Spark WordCount completado. Verificando resultados..."

# Esperar un momento para que se complete
sleep 5

# Ver resultados
echo "=== RESULTADOS ==="
hdfs dfs -cat /jobs-prueba/spark-wordcount/output/part-00000 | head -10

echo ""
echo "=== COMPARACIÓN CON MAPREDUCE ==="
echo "Diferencias principales:"
echo "1. Spark mantiene datos en memoria"
echo "2. Menos overhead de escritura a disco"
echo "3. Mejor rendimiento para trabajos iterativos"
echo "4. APIs más expresivas"
echo "5. Soporte para múltiples lenguajes"
