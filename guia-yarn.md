# Guía de Comandos Básicos de YARN

## ¿Qué es YARN?
YARN (Yet Another Resource Negotiator) es el gestor de recursos y planificador de trabajos de Hadoop. Administra los recursos del cluster y ejecuta aplicaciones distribuidas.

## Comandos Básicos de YARN

### 1. Comandos de Información del Cluster

```bash
# Ver información del ResourceManager
yarn node -list

# Ver información detallada de los nodos
yarn node -list -all

# Ver el estado del cluster
yarn top

# Ver información del ResourceManager
yarn rmadmin -getServiceState rm1
```

### 2. Comandos de Aplicaciones

```bash
# Listar todas las aplicaciones
yarn application -list

# Listar aplicaciones por estado
yarn application -list -appStates RUNNING
yarn application -list -appStates FINISHED
yarn application -list -appStates FAILED

# Ver información detallada de una aplicación
yarn application -status <application_id>

# Ver los logs de una aplicación
yarn logs -applicationId <application_id>

# Ver logs de un contenedor específico
yarn logs -applicationId <application_id> -containerId <container_id>

# Matar una aplicación
yarn application -kill <application_id>
```

### 3. Comandos de Colas

```bash
# Listar todas las colas
yarn queue -status

# Ver información de una cola específica
yarn queue -status <queue_name>

# Ver información detallada de colas
yarn queue -status -verbose
```

### 4. Comandos de Usuarios

```bash
# Ver información de usuarios
yarn top -users

# Ver aplicaciones de un usuario específico
yarn application -list -appStates ALL -appTypes ALL -appTags ALL -user <username>
```

### 5. Comandos de Administración

```bash
# Refrescar nodos
yarn rmadmin -refreshNodes

# Refrescar colas
yarn rmadmin -refreshQueues

# Ver configuración del cluster
yarn daemonlog -getlevel <daemon_name> <logger_name>

# Cambiar nivel de log
yarn daemonlog -setlevel <daemon_name> <logger_name> <level>
```

### 6. Comandos de Monitoreo

```bash
# Ver métricas del ResourceManager
curl http://localhost:8088/ws/v1/cluster/metrics

# Ver información del cluster
curl http://localhost:8088/ws/v1/cluster/info

# Ver nodos del cluster
curl http://localhost:8088/ws/v1/cluster/nodes

# Ver aplicaciones via API REST
curl http://localhost:8088/ws/v1/cluster/apps
```

### 7. Comandos de Trabajos MapReduce

```bash
# Ejecutar un trabajo MapReduce
hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar wordcount /input /output

# Ver trabajos MapReduce en ejecución
mapred job -list

# Ver información de un trabajo específico
mapred job -status <job_id>

# Ver logs de un trabajo
mapred job -logs <job_id>

# Matar un trabajo MapReduce
mapred job -kill <job_id>
```

### 8. Comandos de Spark con YARN

```bash
# Ejecutar aplicación Spark en modo cluster
spark-submit --master yarn --deploy-mode cluster --class MiClase mi-aplicacion.jar

# Ejecutar aplicación Spark en modo cliente
spark-submit --master yarn --deploy-mode client --class MiClase mi-aplicacion.jar

# Ejecutar con configuración específica de recursos
spark-submit --master yarn \
  --deploy-mode cluster \
  --num-executors 4 \
  --executor-memory 2g \
  --executor-cores 2 \
  --class MiClase mi-aplicacion.jar
```

### 9. Comandos de Diagnóstico

```bash
# Ver configuración actual
yarn config

# Ver variables de entorno
yarn envvars

# Ver versión de YARN
yarn version

# Ver información del sistema
yarn node -showDetails <node_id>
```

### 10. Ejemplos Prácticos para la Clase

```bash
# Ejemplo 1: Monitorear el estado del cluster
echo "=== Estado del Cluster ==="
yarn node -list
echo ""
echo "=== Aplicaciones Activas ==="
yarn application -list -appStates RUNNING

# Ejemplo 2: Ejecutar trabajo de ejemplo
echo "=== Ejecutando WordCount ==="
hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar \
  wordcount /user/jupyter/input /user/jupyter/output

# Ejemplo 3: Monitorear progreso del trabajo
echo "=== Monitoreando Trabajo ==="
yarn application -list -appStates RUNNING
# Usar el application_id para obtener más detalles
yarn application -status <application_id>

# Ejemplo 4: Ver logs de aplicación
echo "=== Logs de Aplicación ==="
yarn logs -applicationId <application_id> | head -20

# Ejemplo 5: Limpiar trabajos terminados
echo "=== Limpiando Trabajos Terminados ==="
yarn application -list -appStates FINISHED
# Matar aplicaciones específicas si es necesario
# yarn application -kill <application_id>
```

### 11. Comandos de Configuración

```bash
# Ver configuración de YARN
cat $HADOOP_HOME/etc/hadoop/yarn-site.xml

# Ver configuración de capacidad de colas
cat $HADOOP_HOME/etc/hadoop/capacity-scheduler.xml

# Ver configuración de fair scheduler
cat $HADOOP_HOME/etc/hadoop/fair-scheduler.xml
```

### 12. Comandos de Recursos

```bash
# Ver uso de memoria
yarn top -mem

# Ver uso de CPU
yarn top -cpu

# Ver información detallada de recursos
yarn node -showDetails <node_id>
```

## Interfaces Web de YARN

### ResourceManager Web UI
- **URL**: `http://localhost:8088`
- **Funciones**:
  - Ver estado del cluster
  - Monitorear aplicaciones
  - Ver nodos del cluster
  - Administrar colas

### NodeManager Web UI
- **URL**: `http://localhost:8042` (por cada nodo)
- **Funciones**:
  - Ver contenedores locales
  - Monitorear recursos del nodo
  - Ver logs de contenedores

## Consejos para la Clase

1. **Monitoreo continuo**: Usa `yarn top` para monitorear recursos en tiempo real
2. **Verificar estado**: Siempre verifica el estado del cluster antes de ejecutar trabajos
3. **Gestión de recursos**: Configura apropiadamente memoria y CPU para tus aplicaciones
4. **Logs importantes**: Los logs de YARN son cruciales para debugging
5. **API REST**: Usa la API REST para integración con otras herramientas

## Flujo Típico de Trabajo

1. **Verificar estado del cluster**: `yarn node -list`
2. **Ejecutar aplicación**: `spark-submit` o `hadoop jar`
3. **Monitorear progreso**: `yarn application -list`
4. **Ver logs si hay problemas**: `yarn logs -applicationId <id>`
5. **Limpiar recursos**: Matar aplicaciones terminadas si es necesario

## Recursos Adicionales

- **Web UI del ResourceManager**: `http://localhost:8088`
- **Documentación oficial**: [YARN Commands Guide](https://hadoop.apache.org/docs/current/hadoop-yarn/hadoop-yarn-site/YarnCommands.html)
- **API REST**: `http://localhost:8088/ws/v1/cluster/info`
