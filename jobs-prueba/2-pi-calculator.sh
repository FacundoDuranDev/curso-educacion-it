#!/bin/bash

# Job 2: Pi Calculator - Calculadora de Pi usando Monte Carlo
# Este job calcula el valor de Pi usando el método Monte Carlo

echo "=== JOB 2: PI CALCULATOR ==="
echo "Ejecutando cálculo de Pi usando Monte Carlo..."

# Ejecutar Pi Calculator con diferentes números de mapas
echo "Ejecutando con 10 mapas y 100,000 muestras por mapa..."
hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar \
  pi \
  10 \
  100000

echo ""
echo "Ejecutando con 20 mapas y 1,000,000 muestras por mapa..."
hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar \
  pi \
  20 \
  1000000

echo ""
echo "=== EXPLICACIÓN ==="
echo "El algoritmo Monte Carlo para calcular Pi:"
echo "1. Genera puntos aleatorios en un cuadrado"
echo "2. Cuenta cuántos caen dentro de un círculo inscrito"
echo "3. La proporción aproxima Pi/4"
echo "4. Más muestras = mayor precisión"
