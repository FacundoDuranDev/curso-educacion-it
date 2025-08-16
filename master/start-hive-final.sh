#!/bin/bash

echo "🚀 INICIANDO HIVE COMPLETAMENTE..."

# Configurar variables de entorno
export HADOOP_HOME=/opt/hadoop
export HIVE_HOME=/opt/hive
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export HADOOP_USER_NAME=jupyter

# Crear directorios en HDFS si no existen
echo "📁 Creando directorios en HDFS..."
hdfs dfs -mkdir -p /user/hive/warehouse /tmp/hive 2>/dev/null || true
hdfs dfs -chmod -R 777 /user/hive/warehouse /tmp/hive 2>/dev/null || true

# Detener procesos existentes
echo "🛑 Deteniendo procesos existentes..."
pkill -f hiveserver2 2>/dev/null || true
pkill -f metastore 2>/dev/null || true
sleep 5

# Iniciar Metastore
echo "🔧 Iniciando Hive Metastore..."
hive --service metastore > /opt/hadoop/logs/hive-metastore.log 2>&1 &
METASTORE_PID=$!
echo "Metastore iniciado con PID: $METASTORE_PID"

# Esperar a que metastore esté listo
echo "⏳ Esperando a que metastore esté listo..."
for i in {1..30}; do
    if netstat -tlnp 2>/dev/null | grep ":9083" > /dev/null; then
        echo "✅ Metastore está escuchando en puerto 9083"
        break
    fi
    echo "Esperando... ($i/30)"
    sleep 2
done

# Iniciar HiveServer2
echo "🚀 Iniciando HiveServer2..."
hiveserver2 > /opt/hadoop/logs/hive-server2.log 2>&1 &
HIVESERVER2_PID=$!
echo "HiveServer2 iniciado con PID: $HIVESERVER2_PID"

# Esperar a que HiveServer2 esté listo
echo "⏳ Esperando a que HiveServer2 esté listo..."
for i in {1..45}; do
    if netstat -tlnp 2>/dev/null | grep ":10000" > /dev/null; then
        echo "✅ HiveServer2 está escuchando en puerto 10000"
        break
    fi
    echo "Esperando... ($i/45)"
    sleep 2
done

# Verificar estado final
echo "🔍 Verificando estado final..."
if netstat -tlnp 2>/dev/null | grep ":10000" > /dev/null; then
    echo "🎉 ¡HIVE ESTÁ FUNCIONANDO PERFECTAMENTE!"
    echo "📊 Metastore PID: $METASTORE_PID"
    echo "🚀 HiveServer2 PID: $HIVESERVER2_PID"
    echo "🌐 Puerto 10000: ACTIVO"
else
    echo "❌ HiveServer2 no está escuchando en puerto 10000"
    echo "📋 Revisando logs..."
    tail -10 /opt/hadoop/logs/hive-server2.log 2>/dev/null || echo "No se pueden leer los logs"
fi

echo "🏁 Script de inicio completado!"
