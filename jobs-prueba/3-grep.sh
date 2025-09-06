#!/bin/bash

# Job 3: Grep - Búsqueda de patrones en texto
# Este job busca patrones específicos en archivos de texto

echo "=== JOB 3: GREP - BÚSQUEDA DE PATRONES ==="
echo "Preparando datos de entrada..."

# Crear directorio de entrada
hdfs dfs -mkdir -p /jobs-prueba/grep/input

# Crear archivo de texto más grande para búsqueda
cat > datos-log.txt << EOF
2024-01-15 10:30:15 INFO: Usuario admin inició sesión
2024-01-15 10:31:22 ERROR: Error de conexión a base de datos
2024-01-15 10:32:45 WARN: Memoria baja en servidor
2024-01-15 10:33:12 INFO: Usuario juan inició sesión
2024-01-15 10:34:33 ERROR: Timeout en operación de red
2024-01-15 10:35:21 INFO: Backup completado exitosamente
2024-01-15 10:36:44 WARN: Disco casi lleno
2024-01-15 10:37:15 ERROR: Fallo en autenticación
2024-01-15 10:38:22 INFO: Usuario maria inició sesión
2024-01-15 10:39:33 WARN: CPU usage alto
2024-01-15 10:40:15 ERROR: Servicio no disponible
2024-01-15 10:41:22 INFO: Proceso completado
2024-01-15 10:42:33 WARN: Conexión lenta
2024-01-15 10:43:15 ERROR: Archivo no encontrado
2024-01-15 10:44:22 INFO: Usuario carlos inició sesión
2024-01-15 10:45:33 WARN: Memoria fragmentada
2024-01-15 10:46:15 ERROR: Permisos insuficientes
EOF

# Subir archivo a HDFS
hdfs dfs -put datos-log.txt /jobs-prueba/grep/input/

echo "Datos preparados. Ejecutando búsquedas..."

# Búsqueda 1: Buscar todas las líneas con ERROR
echo "=== BÚSQUEDA 1: Líneas con ERROR ==="
hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar \
  grep \
  /jobs-prueba/grep/input \
  /jobs-prueba/grep/output-error \
  "ERROR"

echo "Resultados de ERROR:"
hdfs dfs -cat /jobs-prueba/grep/output-error/part-r-00000

# Búsqueda 2: Buscar todas las líneas con WARN
echo ""
echo "=== BÚSQUEDA 2: Líneas con WARN ==="
hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar \
  grep \
  /jobs-prueba/grep/input \
  /jobs-prueba/grep/output-warn \
  "WARN"

echo "Resultados de WARN:"
hdfs dfs -cat /jobs-prueba/grep/output-warn/part-r-00000

# Búsqueda 3: Buscar líneas con "inició sesión"
echo ""
echo "=== BÚSQUEDA 3: Usuarios que iniciaron sesión ==="
hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar \
  grep \
  /jobs-prueba/grep/input \
  /jobs-prueba/grep/output-login \
  "inició sesión"

echo "Resultados de login:"
hdfs dfs -cat /jobs-prueba/grep/output-login/part-r-00000

echo ""
echo "=== RESUMEN ==="
echo "Archivos de entrada:"
hdfs dfs -ls /jobs-prueba/grep/input/
echo ""
echo "Archivos de salida:"
hdfs dfs -ls /jobs-prueba/grep/
echo ""
echo "Tamaño total de salidas:"
hdfs dfs -du -h /jobs-prueba/grep/
