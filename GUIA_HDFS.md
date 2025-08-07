# Guía Básica de HDFS y Acceso desde Docker

## ¿Qué es HDFS?

HDFS (Hadoop Distributed File System) es el sistema de archivos distribuido diseñado para ejecutarse en hardware commodity. Características principales:

- Altamente tolerante a fallos
- Diseñado para ser implementado en hardware de bajo costo
- Proporciona alto rendimiento de acceso a datos
- Adecuado para aplicaciones con grandes conjuntos de datos

## Arquitectura de HDFS

HDFS tiene una arquitectura maestro-esclavo que consiste en:

1. **NameNode (Maestro)**
   - Gestiona el espacio de nombres del sistema de archivos
   - Mantiene el árbol del sistema de archivos
   - Almacena los metadatos de todos los archivos y directorios
   - Conoce la ubicación de los bloques de datos en los DataNodes

2. **DataNodes (Esclavos)**
   - Almacenan los datos reales
   - Sirven las solicitudes de lectura y escritura
   - Realizan creación, eliminación y replicación de bloques

## Acceso a HDFS desde Docker

### 1. Configuración del Docker Compose

```yaml
version: '3'
services:
  namenode:
    image: apache/hadoop:3
    hostname: namenode
    environment:
      - CLUSTER_NAME=hadoop-cluster
    ports:
      - "9870:9870"  # UI de Namenode
      - "9000:9000"  # Cliente HDFS
    volumes:
      - hadoop_namenode:/hadoop/dfs/name
    command: ["hdfs", "namenode"]

  datanode:
    image: apache/hadoop:3
    environment:
      - CLUSTER_NAME=hadoop-cluster
    volumes:
      - hadoop_datanode:/hadoop/dfs/data
    command: ["hdfs", "datanode"]
    depends_on:
      - namenode

volumes:
  hadoop_namenode:
  hadoop_datanode:
```

### 2. Comandos Básicos de HDFS

Para ejecutar comandos HDFS desde dentro del contenedor:

```bash
# Listar archivos
hdfs dfs -ls /

# Crear un directorio
hdfs dfs -mkdir /mi_directorio

# Subir un archivo
hdfs dfs -put archivo_local.txt /mi_directorio/

# Descargar un archivo
hdfs dfs -get /mi_directorio/archivo.txt ./

# Ver contenido de un archivo
hdfs dfs -cat /mi_directorio/archivo.txt

# Eliminar archivo o directorio
hdfs dfs -rm /mi_directorio/archivo.txt
hdfs dfs -rm -r /mi_directorio
```

### 3. Acceso desde fuera del contenedor

Para acceder a HDFS desde fuera del contenedor, puedes:

1. Usar el cliente web: http://localhost:9870
2. Usar el cliente HDFS configurando el archivo `core-site.xml`:
```xml
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://localhost:9000</value>
    </property>
</configuration>
```

## Buenas Prácticas

1. **Replicación**
   - Configurar factor de replicación adecuado (por defecto es 3)
   - Considerar el balance entre disponibilidad y espacio

2. **Tamaño de Bloques**
   - Por defecto 128MB
   - Ajustar según necesidades específicas

3. **Monitoreo**
   - Revisar regularmente el estado del cluster
   - Monitorear espacio disponible
   - Verificar logs de errores

4. **Seguridad**
   - Configurar permisos adecuados
   - Implementar autenticación si es necesario
   - Mantener backups de datos críticos

## Solución de Problemas Comunes

1. **No se puede conectar al NameNode**
   - Verificar que los puertos están correctamente expuestos
   - Comprobar logs del contenedor
   - Verificar configuración de red

2. **Problemas de permisos**
   - Verificar permisos HDFS
   - Comprobar usuario que ejecuta los comandos
   - Revisar configuración de seguridad

3. **DataNode no se registra**
   - Revisar logs del DataNode
   - Verificar configuración de red
   - Comprobar espacio en disco

## Referencias Útiles

- [Documentación oficial de Apache Hadoop](https://hadoop.apache.org/docs/current/)
- [Comandos HDFS](https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/HDFSCommands.html)
- [Guía de Administración HDFS](https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/HdfsAdmin.html)