#!/bin/bash

echo "🔧 Configurando Hive con PostgreSQL..."
echo "======================================"

# Detener el contenedor actual
echo "📋 Deteniendo contenedor actual..."
sudo docker stop hive-server
sudo docker rm hive-server

# Crear configuración de Hive
echo "📋 Creando configuración de Hive..."
sudo docker run --rm -v $(pwd)/scripts/hive-config:/tmp/config bde2020/hive:2.3.2-postgresql-metastore bash -c "
cat > /opt/hive/conf/hive-site.xml << 'EOF'
<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<?xml-stylesheet type=\"text/xsl\" href=\"configuration.xsl\"?>
<configuration>
  <property>
    <name>javax.jdo.option.ConnectionURL</name>
    <value>jdbc:postgresql://postgres:5432/metastore</value>
  </property>
  <property>
    <name>javax.jdo.option.ConnectionDriverName</name>
    <value>org.postgresql.Driver</value>
  </property>
  <property>
    <name>javax.jdo.option.ConnectionUserName</name>
    <value>admin</value>
  </property>
  <property>
    <name>javax.jdo.option.ConnectionPassword</name>
    <value>admin</value>
  </property>
  <property>
    <name>hive.metastore.warehouse.dir</name>
    <value>/user/hive/warehouse</value>
  </property>
  <property>
    <name>hive.metastore.uris</name>
    <value>thrift://hive-server:9083</value>
  </property>
  <property>
    <name>hive.server2.enable.doAs</name>
    <value>false</value>
  </property>
  <property>
    <name>hive.server2.authentication</name>
    <value>NOSASL</value>
  </property>
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://hadoop-namenode:8020</value>
  </property>
</configuration>
EOF
"

# Iniciar Hive con configuración correcta
echo "📋 Iniciando Hive con configuración correcta..."
sudo docker run -d \
    --name hive-server \
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

# Verificar si Hive está funcionando
echo "📋 Verificando Hive..."
if sudo docker exec -it hive-server beeline -u jdbc:hive2://localhost:10000 -e "SHOW DATABASES;" > /dev/null 2>&1; then
    echo "✅ Hive funcionando correctamente"
    echo ""
    echo "🎉 ¡Hive está listo para usar!"
    echo "Para conectarte:"
    echo "  sudo docker exec -it hive-server beeline -u jdbc:hive2://localhost:10000"
else
    echo "❌ Hive aún no está funcionando"
    echo "Revisando logs..."
    sudo docker logs hive-server --tail 20
fi 