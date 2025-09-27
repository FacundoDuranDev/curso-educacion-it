# 📁 HDFS MANAGEMENT

> **🎯 Objetivo:** Dominar HDFS para almacenamiento distribuido de Big Data

## 🚀 **¿QUÉ ES HDFS?**

### **📋 Definición:**
**HDFS (Hadoop Distributed File System)** es el sistema de archivos distribuido de Hadoop diseñado para:
- ✅ **Almacenar grandes volúmenes** de datos (petabytes)
- ✅ **Distribuir datos** en múltiples nodos
- ✅ **Tolerar fallos** automáticamente
- ✅ **Escalar horizontalmente** agregando nodos

### **🏗️ Arquitectura HDFS:**
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   NameNode      │    │   DataNode 1    │    │   DataNode 2    │
│   (Metadatos)   │◄──►│   (Datos)       │    │   (Datos)       │
│   Puerto: 9000  │    │   Puerto: 50010 │    │   Puerto: 50010 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                        │                        │
         └────────────────────────┼────────────────────────┘
                                  │
                        ┌─────────────────┐
                        │   Secondary     │
                        │   NameNode      │
                        │   (Backup)      │
                        └─────────────────┘
```

---

## 🔧 **COMANDOS BÁSICOS DE HDFS**

### **📂 Navegación y Listado**

#### **🔍 Ver Contenido:**
```bash
# Listar directorio raíz
hdfs dfs -ls /

# Listar directorio específico
hdfs dfs -ls /user

# Listar con detalles (permisos, tamaño, fecha)
hdfs dfs -ls -la /

# Listar recursivamente (subdirectorios)
hdfs dfs -ls -R /user

# Ver solo archivos (no directorios)
hdfs dfs -ls -R /data | grep -v "^d"
```

#### **📊 Información Detallada:**
```bash
# Ver información de un archivo específico
hdfs dfs -ls -h /data/etapa1/Clientes.csv

# Ver tamaño total de un directorio
hdfs dfs -du -h /data

# Ver uso de espacio por directorio
hdfs dfs -du -s -h /data /user /tmp
```

### **📁 Creación de Directorios**

#### **🗂️ Crear Estructura:**
```bash
# Crear directorio simple
hdfs dfs -mkdir /mi-directorio

# Crear múltiples directorios
hdfs dfs -mkdir /data/etapa1 /data/etapa2 /data/etapa3

# Crear estructura completa (con padres)
hdfs dfs -mkdir -p /user/hive/warehouse/educacionit

# Crear directorios con permisos específicos
hdfs dfs -mkdir -m 755 /data/privado
hdfs dfs -mkdir -m 777 /data/compartido
```

#### **📋 Verificar Creación:**
```bash
# Verificar que se crearon los directorios
hdfs dfs -ls -la /data

# Ver estructura completa
hdfs dfs -ls -R /data
```

### **📤 Transferencia de Archivos**

#### **⬆️ Subir Archivos:**
```bash
# Subir archivo local a HDFS
hdfs dfs -put /opt/data/Clientes.csv /data/etapa1/

# Subir múltiples archivos
hdfs dfs -put /opt/data/etapa1/*.csv /data/etapa1/

# Subir directorio completo
hdfs dfs -put /opt/data/etapa1 /data/

# Subir con nombre diferente
hdfs dfs -put /opt/data/Clientes.csv /data/etapa1/clientes_backup.csv
```

#### **⬇️ Descargar Archivos:**
```bash
# Descargar archivo de HDFS a local
hdfs dfs -get /data/etapa1/Clientes.csv /tmp/

# Descargar directorio completo
hdfs dfs -get /data/etapa1 /tmp/backup/

# Descargar con nombre diferente
hdfs dfs -get /data/etapa1/Clientes.csv /tmp/clientes_local.csv
```

#### **📋 Copiar entre Ubicaciones:**
```bash
# Copiar dentro de HDFS
hdfs dfs -cp /data/etapa1/Clientes.csv /data/backup/

# Mover archivo (cortar y pegar)
hdfs dfs -mv /data/etapa1/Clientes.csv /data/etapa2/

# Copiar directorio completo
hdfs dfs -cp -R /data/etapa1 /data/backup/
```

---

## 🔍 **ANÁLISIS DE ARCHIVOS**

### **📊 Ver Contenido de Archivos**

#### **👀 Visualizar Contenido:**
```bash
# Ver primeras líneas de un archivo
hdfs dfs -cat /data/etapa1/Clientes.csv | head -10

# Ver últimas líneas
hdfs dfs -cat /data/etapa1/Clientes.csv | tail -10

# Ver líneas específicas
hdfs dfs -cat /data/etapa1/Clientes.csv | sed -n '5,15p'

# Contar líneas totales
hdfs dfs -cat /data/etapa1/Clientes.csv | wc -l
```

#### **🔍 Buscar en Archivos:**
```bash
# Buscar texto en archivo
hdfs dfs -cat /data/etapa1/Clientes.csv | grep "Madrid"

# Buscar en múltiples archivos
hdfs dfs -cat /data/etapa1/*.csv | grep "Madrid"

# Buscar con contexto (líneas antes y después)
hdfs dfs -cat /data/etapa1/Clientes.csv | grep -A 2 -B 2 "Madrid"
```

### **📈 Análisis de Tamaños**

#### **📊 Estadísticas de Uso:**
```bash
# Ver uso de espacio por usuario
hdfs dfs -du -h /user

# Ver archivos más grandes
hdfs dfs -ls -R -h /data | sort -k5 -hr | head -10

# Ver archivos más antiguos
hdfs dfs -ls -R -t /data | head -10

# Ver archivos más recientes
hdfs dfs -ls -R -t /data | tail -10
```

---

## 🛠️ **GESTIÓN DE PERMISOS**

### **🔐 Permisos en HDFS**

#### **👥 Usuarios y Grupos:**
```bash
# Ver permisos actuales
hdfs dfs -ls -la /data

# Cambiar propietario
hdfs dfs -chown hive:hive /data/etapa1

# Cambiar grupo
hdfs dfs -chgrp hadoop /data/etapa1

# Cambiar permisos (similar a chmod en Linux)
hdfs dfs -chmod 755 /data/etapa1
hdfs dfs -chmod 644 /data/etapa1/Clientes.csv
```

#### **🔒 Permisos Especiales:**
```bash
# Permisos recursivos
hdfs dfs -chmod -R 755 /data

# Solo archivos (no directorios)
hdfs dfs -chmod -R 644 /data/etapa1/*.csv

# Solo directorios
hdfs dfs -chmod -R 755 /data/etapa1/
```

### **📋 ACLs (Access Control Lists)**
```bash
# Ver ACLs de un archivo
hdfs dfs -getfacl /data/etapa1/Clientes.csv

# Establecer ACL
hdfs dfs -setfacl -m user:analyst:r-- /data/etapa1/Clientes.csv

# Establecer ACL por defecto
hdfs dfs -setfacl -m default:user:analyst:r-- /data/etapa1/

# Remover ACL
hdfs dfs -setfacl -x user:analyst /data/etapa1/Clientes.csv
```

---

## 🗑️ **GESTIÓN DE ARCHIVOS**

### **📁 Organización de Datos**

#### **🗂️ Estructura Recomendada:**
```bash
# Crear estructura estándar para el curso
hdfs dfs -mkdir -p /data/etapa1/raw
hdfs dfs -mkdir -p /data/etapa1/processed
hdfs dfs -mkdir -p /data/etapa1/archive
hdfs dfs -mkdir -p /user/hive/warehouse/educacionit
hdfs dfs -mkdir -p /tmp/analisis
```

#### **📊 Organizar por Fecha:**
```bash
# Crear estructura por año/mes
hdfs dfs -mkdir -p /data/2024/01
hdfs dfs -mkdir -p /data/2024/02
hdfs dfs -mkdir -p /data/2024/03

# Mover archivos por fecha
hdfs dfs -mv /data/etapa1/Clientes.csv /data/2024/01/
```

### **🗑️ Eliminación de Archivos**

#### **⚠️ Eliminar con Precaución:**
```bash
# Eliminar archivo
hdfs dfs -rm /data/etapa1/archivo_temporal.csv

# Eliminar directorio vacío
hdfs dfs -rmdir /data/etapa1/directorio_vacio

# Eliminar directorio con contenido
hdfs dfs -rm -r /data/etapa1/directorio_con_archivos

# Eliminar recursivamente
hdfs dfs -rm -R /data/etapa1/backup/
```

#### **♻️ Papelera de Reciclaje:**
```bash
# Eliminar a papelera (si está habilitada)
hdfs dfs -rm -skipTrash /data/etapa1/archivo_importante.csv

# Restaurar desde papelera
hdfs dfs -mv /user/hdfs/.Trash/Current/data/etapa1/archivo_importante.csv /data/etapa1/
```

---

## 📊 **MONITOREO Y MANTENIMIENTO**

### **📈 Estado del Cluster**

#### **🔍 Información del Sistema:**
```bash
# Ver estado del NameNode
hdfs dfsadmin -report

# Ver información detallada del cluster
hdfs dfsadmin -printTopology

# Ver configuración actual
hdfs getconf -confKey dfs.namenode.name.dir

# Ver uso de espacio
hdfs dfsadmin -report | grep "DFS Used"
```

#### **📊 Métricas de Rendimiento:**
```bash
# Ver estadísticas de operaciones
hdfs dfsadmin -fetchImage /tmp/fsimage

# Ver logs de operaciones
hdfs dfsadmin -refreshNodes

# Ver información de DataNodes
hdfs dfsadmin -printTopology
```

### **🧹 Limpieza y Mantenimiento**

#### **🗂️ Limpieza de Temporales:**
```bash
# Limpiar archivos temporales
hdfs dfs -rm -r /tmp/hadoop-*

# Limpiar archivos de usuario específico
hdfs dfs -rm -r /user/analyst/tmp/*

# Limpiar archivos antiguos (más de 30 días)
hdfs dfs -ls -R /tmp | awk '$6 < "'$(date -d '30 days ago' '+%Y-%m-%d')'" {print $8}' | xargs hdfs dfs -rm
```

#### **📊 Optimización de Espacio:**
```bash
# Ver archivos duplicados
hdfs dfs -ls -R /data | sort -k5 -k8 | uniq -d -f4

# Comprimir archivos grandes
hdfs dfs -cat /data/etapa1/Clientes.csv | gzip | hdfs dfs -put - /data/etapa1/Clientes.csv.gz

# Verificar integridad de archivos
hdfs fsck /data -files -blocks
```

---

## 🚨 **TROUBLESHOOTING**

### **❌ Problemas Comunes**

#### **🔌 "Connection refused"**
```bash
# Verificar que NameNode está corriendo
docker exec -it educacionit-master-1 jps | grep NameNode

# Verificar puertos
netstat -tlnp | grep 9000

# Reiniciar NameNode si es necesario
docker-compose restart master
```

#### **📁 "No such file or directory"**
```bash
# Verificar que el archivo existe
hdfs dfs -ls /data/etapa1/

# Verificar permisos
hdfs dfs -ls -la /data/etapa1/Clientes.csv

# Verificar ruta completa
hdfs dfs -ls /data/etapa1/Clientes.csv
```

#### **💾 "No space left on device"**
```bash
# Verificar espacio disponible
hdfs dfsadmin -report | grep "DFS Remaining"

# Ver archivos más grandes
hdfs dfs -ls -R -h /data | sort -k5 -hr | head -10

# Limpiar archivos temporales
hdfs dfs -rm -r /tmp/hadoop-*
```

### **🔧 Comandos de Diagnóstico**
```bash
# Verificar salud del sistema de archivos
hdfs fsck / -files -blocks

# Verificar replicación
hdfs fsck /data -files -blocks -locations

# Ver logs de errores
docker exec -it educacionit-master-1 tail -f /opt/hadoop/logs/hadoop-hdfs-namenode-*.log
```

---

## 💡 **MEJORES PRÁCTICAS**

### **✅ Recomendaciones Generales:**

1. **Organización de Datos:**
   ```bash
   # Estructura recomendada
   /data/
   ├── raw/          # Datos sin procesar
   ├── processed/    # Datos procesados
   ├── archive/      # Datos históricos
   └── temp/         # Archivos temporales
   ```

2. **Naming Conventions:**
   ```bash
   # Usar nombres descriptivos
   /data/2024/01/ventas_enero_2024.csv
   /data/processed/clientes_normalizados.parquet
   /data/archive/ventas_2023_backup/
   ```

3. **Permisos Seguros:**
   ```bash
   # Permisos por defecto
   hdfs dfs -chmod 755 /data/          # Directorios
   hdfs dfs -chmod 644 /data/*.csv     # Archivos
   ```

### **⚡ Optimización de Rendimiento:**

1. **Tamaño de Archivos:**
   - Archivos grandes (>128MB) para mejor rendimiento
   - Evitar muchos archivos pequeños
   - Usar compresión para archivos de texto

2. **Replicación:**
   - Factor de replicación 3 (por defecto)
   - Ajustar según criticidad de datos
   - Monitorear espacio de almacenamiento

---

## 🔗 **RECURSOS ADICIONALES**

### **📚 Guías Relacionadas:**
- **Hive Setup:** `hive-setup.md`
- **YARN Monitoring:** `yarn-monitoring.md`
- **Spark Integration:** `spark-postgresql.md`

### **🛠️ Herramientas Útiles:**
- **HDFS Web UI:** http://localhost:9870
- **Hadoop Commands:** `hadoop fs` (alias de `hdfs dfs`)
- **File System Shell:** Documentación oficial

### **📖 Documentación:**
- HDFS User Guide
- HDFS Architecture Guide
- HDFS Commands Reference

---

## 🆘 **¿NECESITAS AYUDA?**

### **🚨 Problemas Comunes:**
- **Permisos:** Verificar usuario y grupos
- **Espacio:** Monitorear uso de disco
- **Conectividad:** Verificar servicios

### **📞 Soporte:**
- **Instructor:** Consulta en clase
- **Logs:** `docker-compose logs master`
- **Documentación:** HDFS official docs

**🎯 ¡Con HDFS dominado, ya puedes manejar Big Data a escala!**
