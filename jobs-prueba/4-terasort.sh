#!/bin/bash

# Job 4: Teragen/Terasort - Generación y ordenamiento de datos
# Este job genera datos aleatorios y los ordena (benchmark clásico)

echo "=== JOB 4: TERAGEN/TERASORT - BENCHMARK DE ORDENAMIENTO ==="
echo "Este es un benchmark clásico de Hadoop para probar el rendimiento"

# Verificar espacio disponible
echo "Verificando espacio disponible en HDFS..."
hdfs dfs -df -h

echo ""
echo "=== GENERANDO DATOS (TERAGEN) ==="
echo "Generando 100MB de datos aleatorios..."

# Generar datos (100MB = 100,000,000 bytes / 100 bytes por registro = 1,000,000 registros)
hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar \
  teragen \
  1000000 \
  /jobs-prueba/terasort/input

echo "Datos generados. Verificando..."

# Verificar datos generados
echo "Archivos generados:"
hdfs dfs -ls /jobs-prueba/terasort/input/
echo ""
echo "Tamaño total:"
hdfs dfs -du -h /jobs-prueba/terasort/input/

echo ""
echo "=== ORDENANDO DATOS (TERASORT) ==="
echo "Ejecutando ordenamiento..."

# Ordenar los datos
hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar \
  terasort \
  /jobs-prueba/terasort/input \
  /jobs-prueba/terasort/output

echo "Ordenamiento completado. Verificando resultados..."

# Verificar resultados
echo "Archivos de salida:"
hdfs dfs -ls /jobs-prueba/terasort/output/
echo ""
echo "Tamaño total de salida:"
hdfs dfs -du -h /jobs-prueba/terasort/output/

echo ""
echo "=== VERIFICANDO ORDENAMIENTO (TERAVALIDATE) ==="
echo "Verificando que el ordenamiento sea correcto..."

# Verificar ordenamiento
hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar \
  teravalidate \
  /jobs-prueba/terasort/output \
  /jobs-prueba/terasort/validate

echo "Verificación completada. Resultados:"
hdfs dfs -cat /jobs-prueba/terasort/validate/part-r-00000

echo ""
echo "=== RESUMEN ==="
echo "Este benchmark prueba:"
echo "1. Generación de datos aleatorios"
echo "2. Ordenamiento distribuido"
echo "3. Verificación de integridad"
echo "4. Rendimiento del cluster"
