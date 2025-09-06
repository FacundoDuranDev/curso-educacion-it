#!/bin/bash

# Script para limpiar todos los datos generados por los jobs de prueba
# Este script elimina todos los archivos y directorios creados durante las demostraciones

echo "=== LIMPIANDO DATOS DE JOBS DE PRUEBA ==="
echo "Este script eliminará todos los datos generados por los jobs de prueba"
echo ""

# Confirmar antes de eliminar
read -p "¿Está seguro de que desea eliminar todos los datos? (y/N): " confirm
if [[ $confirm != [yY] && $confirm != [yY][eE][sS] ]]; then
    echo "Operación cancelada."
    exit 0
fi

echo "Eliminando datos de HDFS..."

# Eliminar directorio completo de jobs de prueba
hdfs dfs -rm -r /jobs-prueba/

echo "Eliminando archivos locales temporales..."

# Eliminar archivos temporales locales
rm -f texto-ejemplo.txt
rm -f datos-log.txt
rm -f datos-ventas.csv
rm -f texto-spark.txt

echo "Limpiando aplicaciones terminadas..."

# Listar aplicaciones terminadas
echo "Aplicaciones terminadas:"
yarn application -list -appStates FINISHED,FAILED,KILLED | tail -10

echo ""
read -p "¿Desea eliminar todas las aplicaciones terminadas? (y/N): " limpiar_apps
if [[ $limpiar_apps == [yY] || $limpiar_apps == [yY][eE][sS] ]]; then
    echo "Eliminando aplicaciones terminadas..."
    yarn application -list -appStates FINISHED,FAILED,KILLED | grep -v "Total" | awk '{print $1}' | grep -v "ApplicationId" | while read app_id; do
        if [ ! -z "$app_id" ]; then
            echo "Eliminando aplicación: $app_id"
            yarn application -kill $app_id 2>/dev/null || true
        fi
    done
fi

echo ""
echo "=== LIMPIEZA COMPLETADA ==="
echo "Todos los datos de prueba han sido eliminados."
echo ""

# Mostrar estado final
echo "=== ESTADO FINAL ==="
echo "Espacio disponible en HDFS:"
hdfs dfs -df -h

echo ""
echo "Aplicaciones activas:"
yarn application -list -appStates RUNNING

echo ""
echo "El cluster está listo para nuevas demostraciones."
