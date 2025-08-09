#!/bin/bash

echo "🚀 Inicializando HDFS para Hive..."
echo "=================================="

# Esperar a que HDFS esté completamente iniciado
echo "⏳ Esperando que HDFS esté listo..."
sleep 30

# Crear directorios necesarios en HDFS para Hive
echo "📁 Creando directorios en HDFS..."

# Crear directorio warehouse de Hive
sudo docker exec -it hadoop-namenode hdfs dfs -mkdir -p /user/hive/warehouse
sudo docker exec -it hadoop-namenode hdfs dfs -chmod -R 777 /user/hive/warehouse

# Crear directorio temporal de Hive
sudo docker exec -it hadoop-namenode hdfs dfs -mkdir -p /tmp/hive
sudo docker exec -it hadoop-namenode hdfs dfs -chmod -R 777 /tmp/hive

# Crear directorio para logs de operaciones
sudo docker exec -it hadoop-namenode hdfs dfs -mkdir -p /tmp/hive/operation_logs
sudo docker exec -it hadoop-namenode hdfs dfs -chmod -R 777 /tmp/hive/operation_logs

# Crear directorio para query logs
sudo docker exec -it hadoop-namenode hdfs dfs -mkdir -p /tmp/hive/querylog
sudo docker exec -it hadoop-namenode hdfs dfs -chmod -R 777 /tmp/hive/querylog

# Crear directorio para datos del proyecto
sudo docker exec -it hadoop-namenode hdfs dfs -mkdir -p /data
sudo docker exec -it hadoop-namenode hdfs dfs -chmod -R 777 /data

echo "✅ Directorios HDFS creados correctamente"

# Verificar que los directorios se crearon
echo "📋 Verificando directorios creados..."
sudo docker exec -it hadoop-namenode hdfs dfs -ls /user/hive/
sudo docker exec -it hadoop-namenode hdfs dfs -ls /tmp/hive/
sudo docker exec -it hadoop-namenode hdfs dfs -ls /data/

echo ""
echo "🎉 ¡HDFS inicializado correctamente para Hive!"
echo "==============================================" 