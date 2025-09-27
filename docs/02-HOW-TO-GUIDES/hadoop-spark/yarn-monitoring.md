# ⚡ YARN MONITORING

> **🎯 Objetivo:** Monitorear y gestionar recursos del cluster con YARN

## 🚀 **¿QUÉ ES YARN?**

### **📋 Definición:**
**YARN (Yet Another Resource Negotiator)** es el gestor de recursos y planificador de trabajos de Hadoop que:
- ✅ **Administra recursos** del cluster (CPU, memoria, disco)
- ✅ **Planifica aplicaciones** distribuidas
- ✅ **Gestiona contenedores** de ejecución
- ✅ **Optimiza utilización** de recursos

### **🏗️ Arquitectura YARN:**
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  ResourceManager│    │   NodeManager 1 │    │   NodeManager 2 │
│   (Planificador)│◄──►│   (Recursos)    │    │   (Recursos)    │
│   Puerto: 8088  │    │   Puerto: 8042  │    │   Puerto: 8042  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                        │                        │
         └────────────────────────┼────────────────────────┘
                                  │
                        ┌─────────────────┐
                        │   Application   │
                        │   Master        │
                        │   (Spark, etc.) │
                        └─────────────────┘
```

---

## 🔍 **COMANDOS BÁSICOS DE YARN**

### **📊 Información del Cluster**

#### **🔍 Estado General:**
```bash
# Ver información del ResourceManager
yarn node -list

# Ver información detallada de todos los nodos
yarn node -list -all

# Ver estado del cluster
yarn top

# Ver información del ResourceManager
yarn rmadmin -getServiceState rm1
```

#### **📈 Métricas del Cluster:**
```bash
# Ver estadísticas del cluster
yarn node -list -showDetails

# Ver información de memoria y CPU
yarn node -list | grep -E "(Memory|VCores)"

# Ver nodos por estado
yarn node -list | grep -E "(RUNNING|UNHEALTHY|DECOMMISSIONED)"
```

### **📋 Gestión de Aplicaciones**

#### **🔍 Listar Aplicaciones:**
```bash
# Listar todas las aplicaciones
yarn application -list

# Listar aplicaciones por estado
yarn application -list -appStates RUNNING
yarn application -list -appStates FINISHED
yarn application -list -appStates FAILED

# Listar aplicaciones de un usuario específico
yarn application -list -appStates ALL | grep "analyst"

# Listar aplicaciones con detalles
yarn application -list -appStates ALL -showDetails
```

#### **📊 Información de Aplicación:**
```bash
# Ver información de una aplicación específica
yarn application -status application_1234567890_0001

# Ver logs de una aplicación
yarn logs -applicationId application_1234567890_0001

# Ver logs de un contenedor específico
yarn logs -applicationId application_1234567890_0001 -containerId container_1234567890_0001_01_000001
```

### **🎯 Gestión de Trabajos**

#### **⏹️ Control de Aplicaciones:**
```bash
# Matar una aplicación
yarn application -kill application_1234567890_0001

# Matar todas las aplicaciones de un usuario
yarn application -kill $(yarn application -list -appStates RUNNING | grep "analyst" | awk '{print $1}')

# Matar aplicaciones por tipo
yarn application -kill $(yarn application -list -appStates RUNNING | grep "spark" | awk '{print $1}')
```

---

## 📊 **MONITOREO EN TIEMPO REAL**

### **📈 Dashboard de YARN**

#### **🌐 Web UI del ResourceManager:**
```
URL: http://localhost:8088

Información disponible:
- Cluster Overview (recursos totales y utilizados)
- Applications (estado de aplicaciones)
- Nodes (estado de nodos del cluster)
- Scheduler (configuración del planificador)
```

#### **🔍 Métricas Clave:**
```bash
# Ver métricas del cluster desde línea de comandos
curl -s http://localhost:8088/ws/v1/cluster/metrics | jq .

# Ver información de nodos
curl -s http://localhost:8088/ws/v1/cluster/nodes | jq .

# Ver aplicaciones activas
curl -s http://localhost:8088/ws/v1/cluster/apps?state=RUNNING | jq .
```

### **📊 Monitoreo de Recursos**

#### **💾 Uso de Memoria:**
```bash
# Ver uso de memoria por nodo
yarn node -list | awk '{print $1, $4, $5}' | column -t

# Ver memoria disponible vs utilizada
yarn node -list -showDetails | grep -E "(Memory|VCores)"

# Ver memoria por aplicación
yarn application -list -appStates RUNNING | awk '{print $1, $6, $7}'
```

#### **⚡ Uso de CPU:**
```bash
# Ver uso de CPU por nodo
yarn node -list | awk '{print $1, $6, $7}' | column -t

# Ver contenedores por nodo
yarn node -list -showDetails | grep -E "(Containers|Memory|VCores)"
```

---

## 🔧 **CONFIGURACIÓN Y OPTIMIZACIÓN**

### **⚙️ Configuraciones Clave**

#### **📋 Archivo yarn-site.xml:**
```xml
<!-- Configuraciones importantes -->
<property>
    <name>yarn.resourcemanager.hostname</name>
    <value>master</value>
</property>

<property>
    <name>yarn.nodemanager.resource.memory-mb</name>
    <value>2048</value>
</property>

<property>
    <name>yarn.nodemanager.resource.cpu-vcores</name>
    <value>2</value>
</property>

<property>
    <name>yarn.scheduler.maximum-allocation-mb</name>
    <value>2048</value>
</property>

<property>
    <name>yarn.scheduler.minimum-allocation-mb</name>
    <value>128</value>
</property>
```

#### **🎯 Configuraciones de Spark:**
```bash
# Configuración recomendada para Spark en YARN
spark-submit \
  --master yarn \
  --deploy-mode cluster \
  --driver-memory 1g \
  --driver-cores 1 \
  --executor-memory 800m \
  --executor-cores 1 \
  --num-executors 2 \
  --conf spark.dynamicAllocation.enabled=false \
  --conf spark.shuffle.service.enabled=false \
  --class org.apache.spark.examples.SparkPi \
  /opt/spark/examples/jars/spark-examples_2.12-3.5.3.jar 100
```

### **📊 Optimización de Rendimiento**

#### **⚡ Configuraciones de Rendimiento:**
```bash
# Verificar configuración actual
yarn node -list -showDetails

# Ajustar memoria por contenedor
export YARN_CONF_DIR=/opt/hadoop/etc/hadoop
yarn node -list | grep "Memory"

# Verificar límites de recursos
yarn rmadmin -getServiceState rm1
```

---

## 🚨 **TROUBLESHOOTING**

### **❌ Problemas Comunes**

#### **🔌 "Connection refused"**
```bash
# Verificar que ResourceManager está corriendo
docker exec -it educacionit-master-1 jps | grep ResourceManager

# Verificar puertos
netstat -tlnp | grep 8088

# Reiniciar ResourceManager
docker-compose restart master
```

#### **💾 "Out of memory"**
```bash
# Ver uso de memoria actual
yarn node -list -showDetails

# Ver aplicaciones que consumen más memoria
yarn application -list -appStates RUNNING | sort -k6 -hr

# Matar aplicaciones que consumen mucha memoria
yarn application -kill application_1234567890_0001
```

#### **⏱️ "Application timeout"**
```bash
# Ver logs de aplicación que falla
yarn logs -applicationId application_1234567890_0001

# Verificar recursos disponibles
yarn node -list | grep RUNNING

# Aumentar timeout de aplicación
spark-submit --conf spark.yarn.executor.memoryFraction=0.8
```

### **🔧 Comandos de Diagnóstico**

#### **📊 Análisis de Recursos:**
```bash
# Ver estado detallado del cluster
yarn node -list -showDetails | head -20

# Ver aplicaciones por estado
yarn application -list -appStates ALL | awk '{print $6}' | sort | uniq -c

# Ver uso de recursos por usuario
yarn application -list -appStates ALL | awk '{print $2}' | sort | uniq -c
```

#### **📋 Logs y Debugging:**
```bash
# Ver logs del ResourceManager
docker exec -it educacionit-master-1 tail -f /opt/hadoop/logs/yarn-hdfs-resourcemanager-*.log

# Ver logs de NodeManager
docker exec -it educacionit-worker-1 tail -f /opt/hadoop/logs/yarn-hdfs-nodemanager-*.log

# Ver logs de aplicación específica
yarn logs -applicationId application_1234567890_0001 | tail -50
```

---

## 📈 **MÉTRICAS Y ALERTAS**

### **📊 Métricas Clave a Monitorear**

#### **🎯 KPIs del Cluster:**
```bash
# Script para monitoreo automático
#!/bin/bash

echo "=== YARN CLUSTER STATUS ==="
echo "Total Nodes: $(yarn node -list | grep -c RUNNING)"
echo "Total Memory: $(yarn node -list | awk '{sum+=$4} END {print sum " MB"}')"
echo "Used Memory: $(yarn node -list | awk '{sum+=$5} END {print sum " MB"}')"
echo "Available Memory: $(yarn node -list | awk '{sum+=$4-$5} END {print sum " MB"}')"
echo "Running Applications: $(yarn application -list -appStates RUNNING | wc -l)"
echo "Failed Applications: $(yarn application -list -appStates FAILED | wc -l)"
```

#### **⚠️ Alertas Automáticas:**
```bash
# Script de alertas
#!/bin/bash

# Verificar memoria disponible
AVAILABLE_MEMORY=$(yarn node -list | awk '{sum+=$4-$5} END {print sum}')
if [ $AVAILABLE_MEMORY -lt 1000 ]; then
    echo "ALERTA: Memoria disponible baja: ${AVAILABLE_MEMORY} MB"
fi

# Verificar aplicaciones fallidas
FAILED_APPS=$(yarn application -list -appStates FAILED | wc -l)
if [ $FAILED_APPS -gt 0 ]; then
    echo "ALERTA: $FAILED_APPS aplicaciones fallidas"
fi

# Verificar nodos no saludables
UNHEALTHY_NODES=$(yarn node -list | grep -c UNHEALTHY)
if [ $UNHEALTHY_NODES -gt 0 ]; then
    echo "ALERTA: $UNHEALTHY_NODES nodos no saludables"
fi
```

---

## 💡 **MEJORES PRÁCTICAS**

### **✅ Recomendaciones Generales:**

1. **Monitoreo Continuo:**
   ```bash
   # Crear dashboard personalizado
   watch -n 30 'yarn node -list && echo "---" && yarn application -list -appStates RUNNING'
   ```

2. **Gestión de Recursos:**
   ```bash
   # Limpiar aplicaciones terminadas regularmente
   yarn application -list -appStates FINISHED | awk '{print $1}' | xargs -I {} yarn application -kill {}
   ```

3. **Optimización de Aplicaciones:**
   ```bash
   # Usar configuración adecuada para Spark
   spark-submit \
     --conf spark.dynamicAllocation.enabled=true \
     --conf spark.dynamicAllocation.minExecutors=1 \
     --conf spark.dynamicAllocation.maxExecutors=10
   ```

### **⚡ Optimización de Rendimiento:**

1. **Configuración de Memoria:**
   - Asignar 75% de RAM del nodo a YARN
   - Dejar 25% para sistema operativo
   - Configurar límites mínimos y máximos

2. **Gestión de Contenedores:**
   - Monitorear tamaño de contenedores
   - Evitar contenedores muy grandes o muy pequeños
   - Balancear carga entre nodos

---

## 🔗 **RECURSOS ADICIONALES**

### **📚 Guías Relacionadas:**
- **Hive Setup:** `hive-setup.md`
- **HDFS Management:** `hdfs-management.md`
- **Spark Integration:** `spark-postgresql.md`

### **🛠️ Herramientas Útiles:**
- **YARN Web UI:** http://localhost:8088
- **Ganglia:** Monitoreo avanzado (opcional)
- **Nagios:** Alertas automáticas (opcional)

### **📖 Documentación:**
- YARN User Guide
- YARN Architecture Guide
- YARN Commands Reference

---

## 🆘 **¿NECESITAS AYUDA?**

### **🚨 Problemas Comunes:**
- **Recursos insuficientes:** Ajustar configuración de memoria
- **Aplicaciones lentas:** Optimizar configuración de Spark
- **Nodos no saludables:** Verificar logs y reiniciar

### **📞 Soporte:**
- **Instructor:** Consulta en clase
- **Logs:** `docker-compose logs master`
- **Documentación:** YARN official docs

**🎯 ¡Con YARN dominado, ya puedes gestionar recursos del cluster eficientemente!**
