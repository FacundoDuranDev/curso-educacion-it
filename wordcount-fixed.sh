#!/bin/bash

# Job 1: WordCount - Contador de palabras
# Este es el ejemplo clásico de MapReduce

echo "=== JOB 1: WORDCOUNT ==="
echo "Preparando datos de entrada..."

# Crear directorio de entrada
hdfs dfs -mkdir -p /jobs-prueba/wordcount/input

# Limpiar directorio de salida si existe
hdfs dfs -rm -r -f /jobs-prueba/wordcount/output

# Crear archivo de texto de ejemplo en el directorio home del usuario
cat > /home/jupyter/texto-ejemplo.txt << EOF
Hadoop es un framework de software de código abierto
Hadoop permite el procesamiento distribuido de grandes conjuntos de datos
Hadoop utiliza el modelo de programación MapReduce
Hadoop incluye HDFS para el almacenamiento distribuido
Hadoop es escalable y tolerante a fallos
Hadoop se ejecuta en clusters de computadoras
Hadoop es ampliamente utilizado en big data
Hadoop fue desarrollado por Apache Software Foundation
Hadoop soporta múltiples lenguajes de programación
Hadoop es una herramienta esencial para el análisis de datos
YARN es el gestor de recursos de Hadoop
YARN permite la ejecución de múltiples aplicaciones
MapReduce es un modelo de programación para procesar big data
HDFS es el sistema de archivos distribuido de Hadoop
Apache Spark puede ejecutarse sobre YARN
Hive proporciona un interfaz SQL para Hadoop
HBase es una base de datos NoSQL que funciona sobre HDFS
Pig es un lenguaje de alto nivel para análisis de datos
Sqoop permite importar datos desde bases de datos relacionales
Flume es una herramienta para la ingesta de datos en tiempo real
EOF

# Subir archivo a HDFS
hdfs dfs -put /home/jupyter/texto-ejemplo.txt /jobs-prueba/wordcount/input/

echo "Datos preparados. Ejecutando WordCount..."

# Ejecutar WordCount
hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar \
  wordcount \
  /jobs-prueba/wordcount/input \
  /jobs-prueba/wordcount/output

echo "WordCount completado. Verificando resultados..."

# Ver resultados
echo "=== RESULTADOS (Top 20 palabras más frecuentes) ==="
hdfs dfs -cat /jobs-prueba/wordcount/output/part-r-00000 | sort -k2 -nr | head -20

echo ""
echo "=== RESUMEN ==="
echo "Archivos de entrada:"
hdfs dfs -ls /jobs-prueba/wordcount/input/
echo ""
echo "Archivos de salida:"
hdfs dfs -ls /jobs-prueba/wordcount/output/
echo ""
echo "Tamaño total de salida:"
hdfs dfs -du -h /jobs-prueba/wordcount/output/

# Limpiar archivo temporal
rm -f /home/jupyter/texto-ejemplo.txt

echo ""
echo "✅ Job WordCount completado exitosamente!"
