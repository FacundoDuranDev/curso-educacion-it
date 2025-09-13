# Jobs de Prueba para YARN

Este directorio contiene varios jobs de ejemplo que puedes ejecutar en YARN para demostrar el funcionamiento del sistema.

## 🚀 Configuración Inicial

Antes de ejecutar cualquier job, asegúrate de que el clúster esté funcionando correctamente:

### 1. Verificar que YARN esté activo
```bash
# Verificar nodos YARN
docker exec curso-educacion-it-master-1 bash -c "yarn node -list"

# Deberías ver algo como:
# Total Nodes:2
#          Node-Id             Node-State Node-Http-Address       Number-of-Running-Containers
#    worker1:42787                RUNNING      worker1:8042                                  0
#    worker2:38363                RUNNING      worker2:8042                                  0
```

### 2. Si los nodos no aparecen, reiniciar NodeManagers
```bash
# Reiniciar NodeManager en worker1
docker exec curso-educacion-it-worker1-1 bash -c "yarn nodemanager" &

# Reiniciar NodeManager en worker2
docker exec curso-educacion-it-worker2-1 bash -c "yarn nodemanager" &

# Esperar 10 segundos y verificar
sleep 10
docker exec curso-educacion-it-master-1 bash -c "yarn node -list"
```

## 📊 Jobs Disponibles

1. **WordCount** - Contador de palabras (MapReduce) ✅ **PROBADO**
2. **Pi Calculator** - Calculadora de Pi (MapReduce)
3. **Grep** - Búsqueda de patrones en texto (MapReduce)
4. **Teragen/Terasort** - Generación y ordenamiento de datos (MapReduce)
5. **Spark Pi** - Calculadora de Pi con Spark
6. **Spark WordCount** - Contador de palabras con Spark

---

## 🔥 JOB 1: WordCount (PASO A PASO)

### Qué hace este job:
- Cuenta la frecuencia de palabras en un texto
- Utiliza MapReduce para procesar el texto de forma distribuida
- Muestra las palabras más frecuentes ordenadas

### Paso 1: Preparar el script
```bash
# Crear el script mejorado de WordCount
cat > /home/fissure/oyreb/curso-educacion-it/wordcount-yarn.sh << 'EOF'
#!/bin/bash

echo "=== JOB 1: WORDCOUNT ==="
echo "Preparando datos de entrada..."

# Crear directorio de entrada
hdfs dfs -mkdir -p /jobs-prueba/wordcount/input

# Limpiar directorio de salida si existe
hdfs dfs -rm -r -f /jobs-prueba/wordcount/output

# Crear archivo de texto de ejemplo
cat > /home/jupyter/texto-ejemplo.txt << 'EOT'
Hadoop es un framework de software de código abierto
Hadoop permite el procesamiento distribuido de grandes conjuntos de datos
Hadoop utiliza el modelo de programación MapReduce
Hadoop incluye HDFS para el almacenamiento distribuido
Hadoop es escalable y tolerante a fallos
Hadoop se ejecuta en clusters de computadoras
Hadoop es ampliamente utilizado en big data
Hadoop fue desarrollado por Apache Software Foundation
Hadoop soporta múltiples lenguajes de programación
Hadoop es una herramienta esencial para el análisis de datos
YARN es el gestor de recursos de Hadoop
YARN permite la ejecución de múltiples aplicaciones
MapReduce es un modelo de programación para procesar big data
HDFS es el sistema de archivos distribuido de Hadoop
Apache Spark puede ejecutarse sobre YARN
Hive proporciona un interfaz SQL para Hadoop
HBase es una base de datos NoSQL que funciona sobre HDFS
Pig es un lenguaje de alto nivel para análisis de datos
Sqoop permite importar datos desde bases de datos relacionales
Flume es una herramienta para la ingesta de datos en tiempo real
EOT

# Subir archivo a HDFS
hdfs dfs -put /home/jupyter/texto-ejemplo.txt /jobs-prueba/wordcount/input/

echo "Datos preparados. Ejecutando WordCount..."

# Ejecutar WordCount
hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar \
  wordcount \
  /jobs-prueba/wordcount/input \
  /jobs-prueba/wordcount/output

echo "WordCount completado. Verificando resultados..."

# Ver resultados
echo "=== RESULTADOS (Top 20 palabras más frecuentes) ==="
hdfs dfs -cat /jobs-prueba/wordcount/output/part-r-00000 | sort -k2 -nr | head -20

echo ""
echo "=== RESUMEN ==="
echo "Archivos de entrada:"
hdfs dfs -ls /jobs-prueba/wordcount/input/
echo ""
echo "Archivos de salida:"
hdfs dfs -ls /jobs-prueba/wordcount/output/
echo ""
echo "Tamaño total de salida:"
hdfs dfs -du -h /jobs-prueba/wordcount/output/

# Limpiar archivo temporal
rm -f /home/jupyter/texto-ejemplo.txt

echo ""
echo "✅ Job WordCount completado exitosamente!"
EOF
```

### Paso 2: Copiar el script al contenedor
```bash
# Copiar script al contenedor master
docker cp wordcount-yarn.sh curso-educacion-it-master-1:/home/jupyter/
```

### Paso 3: Ejecutar el job
```bash
# Ejecutar WordCount
docker exec curso-educacion-it-master-1 bash /home/jupyter/wordcount-yarn.sh
```

### Paso 4: Monitorear el job (Opcional)
```bash
# Ver aplicaciones en ejecución
docker exec curso-educacion-it-master-1 bash -c "yarn application -list"

# Ver detalles de una aplicación específica
docker exec curso-educacion-it-master-1 bash -c "yarn application -status <application_id>"
```

### Paso 5: Ver resultados detallados
```bash
# Ver todos los resultados
docker exec curso-educacion-it-master-1 bash -c "hdfs dfs -cat /jobs-prueba/wordcount/output/part-r-00000"

# Ver solo las 10 palabras más frecuentes
docker exec curso-educacion-it-master-1 bash -c "hdfs dfs -cat /jobs-prueba/wordcount/output/part-r-00000 | sort -k2 -nr | head -10"
```

### Resultados esperados:
```
=== RESULTADOS (Top 20 palabras más frecuentes) ===
de      19
Hadoop  13
es      10
datos   7
para    6
el      6
un      4
una     3
programación    3
permite 3
...
```

---

## 🎯 JOB 2: Pi Calculator

### Ejecución rápida:
```bash
# Copiar y ejecutar
docker cp jobs-prueba/2-pi-calculator.sh curso-educacion-it-master-1:/home/jupyter/
docker exec curso-educacion-it-master-1 bash /home/jupyter/2-pi-calculator.sh
```

---

## 🔍 Comandos de Monitoreo YARN

### Ver aplicaciones activas
```bash
docker exec curso-educacion-it-master-1 bash -c "yarn application -list"
```

### Ver detalles de una aplicación
```bash
docker exec curso-educacion-it-master-1 bash -c "yarn application -status <application_id>"
```

### Ver logs de una aplicación
```bash
docker exec curso-educacion-it-master-1 bash -c "yarn logs -applicationId <application_id>"
```

### Ver estado del clúster
```bash
docker exec curso-educacion-it-master-1 bash -c "yarn node -list"
docker exec curso-educacion-it-master-1 bash -c "yarn node -status <node_id>"
```

### Acceder a la interfaz web de YARN
- **YARN Resource Manager**: http://localhost:8088
- **Worker1 Node Manager**: http://localhost:8042
- **Worker2 Node Manager**: http://localhost:8043

---

## 🛠️ Solución de Problemas

### Problema: "Could not find or load main class org.apache.hadoop.mapreduce.v2.app.MRAppMaster"

**Solución**: Actualizar `mapred-site.xml` con las configuraciones de `HADOOP_MAPRED_HOME`:

```bash
# Crear archivo de configuración corregido
cat > mapred-site-fixed.xml << 'EOF'
<?xml version="1.0"?>
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
    <property>
        <name>yarn.app.mapreduce.am.env</name>
        <value>HADOOP_MAPRED_HOME=/opt/hadoop</value>
    </property>
    <property>
        <name>mapreduce.map.env</name>
        <value>HADOOP_MAPRED_HOME=/opt/hadoop</value>
    </property>
    <property>
        <name>mapreduce.reduce.env</name>
        <value>HADOOP_MAPRED_HOME=/opt/hadoop</value>
    </property>
</configuration>
EOF

# Copiar a todos los contenedores
docker cp mapred-site-fixed.xml curso-educacion-it-master-1:/opt/hadoop/etc/hadoop/mapred-site.xml
docker cp mapred-site-fixed.xml curso-educacion-it-worker1-1:/opt/hadoop/etc/hadoop/mapred-site.xml
docker cp mapred-site-fixed.xml curso-educacion-it-worker2-1:/opt/hadoop/etc/hadoop/mapred-site.xml

# Reiniciar YARN
docker exec curso-educacion-it-master-1 bash -c "stop-yarn.sh && start-yarn.sh"
```

### Problema: Nodos YARN no aparecen

**Solución**: Reiniciar NodeManagers manualmente:

```bash
docker exec curso-educacion-it-worker1-1 bash -c "yarn nodemanager" &
docker exec curso-educacion-it-worker2-1 bash -c "yarn nodemanager" &
sleep 10
docker exec curso-educacion-it-master-1 bash -c "yarn node -list"
```

---

## 📝 Notas Importantes

1. **Directorio de trabajo**: Los scripts se ejecutan desde `/home/jupyter/` en el contenedor
2. **Limpieza automática**: Los scripts limpian directorios de salida antes de ejecutarse
3. **Monitoreo**: Usa la interfaz web de YARN (puerto 8088) para monitorear jobs en tiempo real
4. **Logs**: Los logs detallados están disponibles a través de `yarn logs -applicationId <id>`
5. **HDFS**: Los datos se almacenan en HDFS bajo `/jobs-prueba/`

---

## 🎉 ¡Listo para ejecutar jobs en YARN!

Sigue los pasos del **JOB 1: WordCount** para tu primera ejecución exitosa, luego experimenta con los otros jobs disponibles.