#!/bin/bash

echo "🔧 Inicializando Hive Metastore con PostgreSQL..."

# Crear directorio de configuración de Hive
mkdir -p /opt/hive/conf

# Crear archivo hive-site.xml
cat > /opt/hive/conf/hive-site.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
  <!-- Configuración de la base de datos metastore -->
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
  
  <!-- Configuración del warehouse -->
  <property>
    <name>hive.metastore.warehouse.dir</name>
    <value>hdfs://hadoop-namenode:8020/user/hive/warehouse</value>
  </property>
  
  <!-- Configuración del metastore -->
  <property>
    <name>hive.metastore.uris</name>
    <value>thrift://hive-metastore:9083</value>
  </property>
  
  <!-- Configuración de HDFS -->
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://hadoop-namenode:8020</value>
  </property>
  
  <!-- Configuración de directorio temporal -->
  <property>
    <name>hive.exec.scratchdir</name>
    <value>hdfs://hadoop-namenode:8020/tmp/hive</value>
  </property>
  
  <!-- Configuración de autenticación -->
  <property>
    <name>hive.server2.enable.doAs</name>
    <value>false</value>
  </property>
  
  <property>
    <name>hive.server2.authentication</name>
    <value>NOSASL</value>
  </property>
</configuration>
EOF

# Inicializar el esquema de Hive con PostgreSQL
echo "Inicializando esquema de Hive..."
/opt/hive/bin/schematool -dbType postgres -initSchema

echo "✅ Hive Metastore inicializado correctamente" 