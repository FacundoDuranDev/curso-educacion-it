#!/bin/bash

# Job 5: Spark Pi Calculator - Calculadora de Pi usando Spark
# Este job calcula Pi usando Spark en lugar de MapReduce

echo "=== JOB 5: SPARK PI CALCULATOR ==="
echo "Calculando Pi usando Spark en modo cluster..."

# Ejecutar Spark Pi en modo cluster
echo "Ejecutando Spark Pi con 10 particiones..."
spark-submit \
  --master yarn \
  --deploy-mode cluster \
  --num-executors 2 \
  --executor-memory 1g \
  --executor-cores 1 \
  --class org.apache.spark.examples.SparkPi \
  /opt/spark/examples/jars/spark-examples_2.12-*.jar \
  10

echo ""
echo "Ejecutando Spark Pi con 100 particiones..."
spark-submit \
  --master yarn \
  --deploy-mode cluster \
  --num-executors 4 \
  --executor-memory 1g \
  --executor-cores 1 \
  --class org.apache.spark.examples.SparkPi \
  /opt/spark/examples/jars/spark-examples_2.12-*.jar \
  100

echo ""
echo "=== EXPLICACIÓN ==="
echo "Spark Pi vs MapReduce Pi:"
echo "1. Spark mantiene datos en memoria"
echo "2. Menos overhead de I/O"
echo "3. Mejor rendimiento para trabajos iterativos"
echo "4. Interfaz más simple para programación"
