#!/bin/bash

# Job 1: WordCount - Contador de palabras
# Este es el ejemplo clásico de MapReduce

echo "=== JOB 1: WORDCOUNT ==="
echo "Preparando datos de entrada..."

# Crear directorio de entrada
hdfs dfs -mkdir -p /jobs-prueba/wordcount/input

# Crear archivo de texto de ejemplo
cat > texto-ejemplo.txt << EOF
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
EOF

# Subir archivo a HDFS
hdfs dfs -put texto-ejemplo.txt /jobs-prueba/wordcount/input/

echo "Datos preparados. Ejecutando WordCount..."

# Ejecutar WordCount
hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar \
  wordcount \
  /jobs-prueba/wordcount/input \
  /jobs-prueba/wordcount/output

echo "WordCount completado. Verificando resultados..."

# Ver resultados
echo "=== RESULTADOS ==="
hdfs dfs -cat /jobs-prueba/wordcount/output/part-r-00000 | head -10

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
