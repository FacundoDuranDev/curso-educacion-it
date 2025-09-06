# Guía de Comandos Básicos de HDFS

## ¿Qué es HDFS?
HDFS (Hadoop Distributed File System) es el sistema de archivos distribuido de Hadoop diseñado para almacenar grandes volúmenes de datos en múltiples nodos.

## Comandos Básicos de HDFS

### 1. Comandos de Navegación y Listado

```bash
# Listar contenido del directorio raíz
hdfs dfs -ls /

# Listar contenido de un directorio específico
hdfs dfs -ls /user

# Listar contenido con detalles (permisos, tamaño, fecha)
hdfs dfs -ls -la /

# Listar contenido recursivamente
hdfs dfs -ls -R /user
```

### 2. Comandos de Creación de Directorios

```bash
# Crear un directorio
hdfs dfs -mkdir /mi-directorio

# Crear múltiples directorios
hdfs dfs -mkdir /directorio1 /directorio2 /directorio3

# Crear directorios padre si no existen
hdfs dfs -mkdir -p /ruta/completa/al/directorio
```

### 3. Comandos de Transferencia de Archivos

```bash
# Subir un archivo local a HDFS
hdfs dfs -put archivo-local.txt /destino/

# Subir múltiples archivos
hdfs dfs -put archivo1.txt archivo2.txt /destino/

# Subir un directorio completo
hdfs dfs -put directorio-local/ /destino/

# Copiar archivos desde sistema local
hdfs dfs -copyFromLocal archivo.txt /destino/

# Descargar archivo desde HDFS al sistema local
hdfs dfs -get /origen/archivo.txt ./archivo-descargado.txt

# Copiar archivo desde HDFS al sistema local
hdfs dfs -copyToLocal /origen/archivo.txt ./archivo-copiado.txt
```

### 4. Comandos de Visualización de Archivos

```bash
# Ver contenido de un archivo
hdfs dfs -cat /ruta/archivo.txt

# Ver las primeras líneas de un archivo
hdfs dfs -head /ruta/archivo.txt

# Ver las últimas líneas de un archivo
hdfs dfs -tail /ruta/archivo.txt

# Ver contenido de archivos grandes (paginado)
hdfs dfs -cat /ruta/archivo-grande.txt | less
```

### 5. Comandos de Información del Sistema

```bash
# Ver el uso del espacio en disco
hdfs dfs -df

# Ver el uso del espacio en disco con formato legible
hdfs dfs -df -h

# Ver el tamaño de un archivo o directorio
hdfs dfs -du /ruta/archivo

# Ver el tamaño con formato legible
hdfs dfs -du -h /ruta/archivo

# Ver el tamaño total de un directorio
hdfs dfs -du -s /ruta/directorio
```

### 6. Comandos de Gestión de Archivos

```bash
# Copiar archivo dentro de HDFS
hdfs dfs -cp /origen/archivo.txt /destino/archivo-copiado.txt

# Mover archivo dentro de HDFS
hdfs dfs -mv /origen/archivo.txt /destino/archivo-movido.txt

# Eliminar un archivo
hdfs dfs -rm /ruta/archivo.txt

# Eliminar un directorio vacío
hdfs dfs -rmdir /ruta/directorio-vacio

# Eliminar directorio y su contenido
hdfs dfs -rm -r /ruta/directorio-con-contenido

# Eliminar múltiples archivos
hdfs dfs -rm /ruta/archivo1.txt /ruta/archivo2.txt
```

### 7. Comandos de Permisos

```bash
# Cambiar permisos de un archivo
hdfs dfs -chmod 755 /ruta/archivo.txt

# Cambiar el propietario de un archivo
hdfs dfs -chown usuario:grupo /ruta/archivo.txt

# Cambiar el grupo de un archivo
hdfs dfs -chgrp grupo /ruta/archivo.txt

# Ver permisos detallados
hdfs dfs -ls -la /ruta/archivo.txt
```

### 8. Comandos de Verificación

```bash
# Verificar la integridad de un archivo
hdfs dfs -checksum /ruta/archivo.txt

# Verificar si un archivo existe
hdfs dfs -test -e /ruta/archivo.txt && echo "El archivo existe" || echo "El archivo no existe"

# Verificar si es un archivo
hdfs dfs -test -f /ruta/archivo.txt && echo "Es un archivo" || echo "No es un archivo"

# Verificar si es un directorio
hdfs dfs -test -d /ruta/directorio && echo "Es un directorio" || echo "No es un directorio"
```

### 9. Comandos de Administración

```bash
# Ver el estado del NameNode
hdfs dfsadmin -report

# Ver el estado de los DataNodes
hdfs dfsadmin -printTopology

# Ver el estado del sistema de archivos
hdfs dfsadmin -fsck /

# Salir del modo seguro (si está activo)
hdfs dfsadmin -safemode leave
```

### 10. Ejemplos Prácticos para la Clase

```bash
# Ejemplo 1: Crear estructura de directorios para un proyecto
hdfs dfs -mkdir -p /proyecto/datos/raw
hdfs dfs -mkdir -p /proyecto/datos/processed
hdfs dfs -mkdir -p /proyecto/logs

# Ejemplo 2: Subir datos de ejemplo
hdfs dfs -put datos-ejemplo.csv /proyecto/datos/raw/

# Ejemplo 3: Verificar el contenido subido
hdfs dfs -ls -la /proyecto/datos/raw/

# Ejemplo 4: Ver el tamaño de los datos
hdfs dfs -du -h /proyecto/

# Ejemplo 5: Crear un archivo de texto simple
echo "Hola desde HDFS" | hdfs dfs -put - /proyecto/test.txt
hdfs dfs -cat /proyecto/test.txt
```

## Consejos para la Clase

1. **Siempre verificar el estado**: Usa `hdfs dfsadmin -report` para ver el estado del cluster
2. **Usar rutas absolutas**: Siempre especifica rutas completas desde la raíz `/`
3. **Verificar permisos**: Asegúrate de tener permisos para realizar las operaciones
4. **Monitorear espacio**: Usa `hdfs dfs -df -h` para verificar el espacio disponible
5. **Práctica incremental**: Comienza con comandos simples y avanza gradualmente

## Recursos Adicionales

- **Web UI del NameNode**: `http://localhost:9870`
- **Documentación oficial**: [HDFS Commands Guide](https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/HDFSCommands.html)
