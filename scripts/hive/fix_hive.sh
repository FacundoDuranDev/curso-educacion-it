#!/bin/bash

echo "🔧 Solucionando problemas de Hive..."
echo "=================================="

# 1. Verificar que PostgreSQL esté funcionando
echo "📋 Verificando PostgreSQL..."
if sudo docker exec -it postgres psql -U admin -d metastore -c "SELECT 1;" > /dev/null 2>&1; then
    echo "✅ PostgreSQL funcionando"
else
    echo "❌ Error en PostgreSQL"
    exit 1
fi

# 2. Verificar que HDFS esté funcionando
echo "📋 Verificando HDFS..."
if sudo docker exec -it hadoop-namenode hdfs dfsadmin -report > /dev/null 2>&1; then
    echo "✅ HDFS funcionando"
else
    echo "❌ Error en HDFS"
    exit 1
fi

# 3. Verificar que el metastore esté inicializado
echo "📋 Verificando metastore..."
TABLE_COUNT=$(sudo docker exec -it postgres psql -U admin -d metastore -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" | tr -d ' ')
if [ "$TABLE_COUNT" -gt 0 ]; then
    echo "✅ Metastore inicializado ($TABLE_COUNT tablas)"
else
    echo "❌ Metastore no inicializado"
    exit 1
fi

# 4. Intentar iniciar Hive con configuración manual
echo "📋 Iniciando Hive con configuración manual..."

# Detener contenedor actual si existe
sudo docker stop hive-server 2>/dev/null || true
sudo docker rm hive-server 2>/dev/null || true

# Crear directorio temporal para logs
mkdir -p /tmp/hive-logs

# Iniciar Hive con configuración manual
sudo docker run -d \
    --name hive-server-fixed \
    --network educacionit_hadoop-network \
    -p 10000:10000 \
    -p 10002:10002 \
    -e CORE_CONF_fs_defaultFS=hdfs://hadoop-namenode:8020 \
    -e HIVE_METASTORE_DB_TYPE=postgres \
    -e HIVE_DB=metastore \
    -e HIVE_DB_USERNAME=admin \
    -e HIVE_DB_PASSWORD=admin \
    -e HIVE_JDBC_URL=jdbc:postgresql://postgres:5432/metastore \
    -e HIVE_SERVER2_ENABLE_DOAS=false \
    -e HIVE_SERVER2_AUTHENTICATION=NOSASL \
    bde2020/hive:2.3.2-postgresql-metastore

echo "⏳ Esperando que Hive se inicie..."
sleep 120

# 5. Verificar si Hive está funcionando
echo "📋 Verificando Hive..."
if sudo docker exec -it hive-server-fixed beeline -u jdbc:hive2://localhost:10000 -e "SHOW DATABASES;" > /dev/null 2>&1; then
    echo "✅ Hive funcionando correctamente"
    echo ""
    echo "🎉 ¡Hive está listo para usar!"
    echo "Para conectarte:"
    echo "  sudo docker exec -it hive-server-fixed beeline -u jdbc:hive2://localhost:10000"
else
    echo "❌ Hive aún no está funcionando"
    echo "Revisando logs..."
    sudo docker logs hive-server-fixed --tail 20
fi 