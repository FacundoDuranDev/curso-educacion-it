#!/bin/bash
# Script para construir la imagen personalizada de JupyterLab

echo "🔨 Construyendo imagen JupyterLab personalizada..."

# Construir la imagen
docker build -t hadoop-hive-spark-jupyterlab ./jupyterlab/

if [ $? -eq 0 ]; then
    echo "✅ Imagen hadoop-hive-spark-jupyterlab construida exitosamente"
    echo "📋 Para usar esta imagen, actualiza el docker-compose.yml:"
    echo "   image: hadoop-hive-spark-jupyterlab"
else
    echo "❌ Error al construir la imagen"
    exit 1
fi
