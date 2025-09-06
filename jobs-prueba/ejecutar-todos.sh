#!/bin/bash

# Script para ejecutar todos los jobs de prueba
# Este script ejecuta todos los jobs en secuencia para demostración

echo "=== EJECUTANDO TODOS LOS JOBS DE PRUEBA ==="
echo "Este script ejecutará todos los jobs de prueba en secuencia"
echo "Fecha de inicio: $(date)"
echo ""

# Hacer todos los scripts ejecutables
chmod +x jobs-prueba/*.sh

# Función para mostrar estado de YARN antes de cada job
mostrar_estado() {
    echo "=== ESTADO ACTUAL DE YARN ==="
    yarn application -list -appStates RUNNING
    echo ""
}

# Función para esperar a que termine un job
esperar_job() {
    echo "Esperando a que termine el job..."
    while [ $(yarn application -list -appStates RUNNING | wc -l) -gt 1 ]; do
        sleep 5
        echo "Jobs activos: $(($(yarn application -list -appStates RUNNING | wc -l) - 1))"
    done
    echo "Job completado."
    echo ""
}

# Job 1: WordCount
echo "=== EJECUTANDO JOB 1: WORDCOUNT ==="
mostrar_estado
./jobs-prueba/1-wordcount.sh
esperar_job

# Job 2: Pi Calculator
echo "=== EJECUTANDO JOB 2: PI CALCULATOR ==="
mostrar_estado
./jobs-prueba/2-pi-calculator.sh
esperar_job

# Job 3: Grep
echo "=== EJECUTANDO JOB 3: GREP ==="
mostrar_estado
./jobs-prueba/3-grep.sh
esperar_job

# Job 4: Terasort (comentado por ser más pesado)
echo "=== JOB 4: TERASORT (OPCIONAL) ==="
echo "Terasort es un benchmark pesado. ¿Desea ejecutarlo? (y/N)"
read -p "Respuesta: " ejecutar_terasort
if [[ $ejecutar_terasort == [yY] || $ejecutar_terasort == [yY][eE][sS] ]]; then
    mostrar_estado
    ./jobs-prueba/4-terasort.sh
    esperar_job
else
    echo "Terasort omitido."
fi

# Job 5: Spark Pi
echo "=== EJECUTANDO JOB 5: SPARK PI ==="
mostrar_estado
./jobs-prueba/5-spark-pi.sh
esperar_job

# Job 6: Spark WordCount
echo "=== EJECUTANDO JOB 6: SPARK WORDCOUNT ==="
mostrar_estado
./jobs-prueba/6-spark-wordcount.sh
esperar_job

echo "=== TODOS LOS JOBS COMPLETADOS ==="
echo "Fecha de finalización: $(date)"
echo ""

# Mostrar resumen final
echo "=== RESUMEN FINAL ==="
echo "Aplicaciones ejecutadas:"
yarn application -list -appStates FINISHED | tail -10

echo ""
echo "=== ESTADO FINAL DEL CLUSTER ==="
./jobs-prueba/monitoreo-yarn.sh todo

echo ""
echo "=== ARCHIVOS GENERADOS EN HDFS ==="
hdfs dfs -ls -R /jobs-prueba/

echo ""
echo "=== ESPACIO UTILIZADO ==="
hdfs dfs -du -h /jobs-prueba/
