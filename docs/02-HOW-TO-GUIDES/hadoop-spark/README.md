# ⚡ HADOOP/SPARK - GUÍAS PRÁCTICAS

> **🎯 Todo lo que necesitas para dominar Big Data con Hadoop y Spark**

## 🚀 **INICIO RÁPIDO**

### **⚡ Para empezar ahora:**
1. **Verificar cluster** → `hive-setup.md` (verificación del entorno)
2. **Elegir tu objetivo** → Hive, HDFS, YARN o Spark Jobs
3. **Seguir guía específica** → Paso a paso con ejemplos

### **🗄️ Componentes Disponibles:**
```
Hadoop Ecosystem:
├── HDFS (Sistema de archivos distribuido)
├── YARN (Gestor de recursos)
├── Hive (SQL sobre Hadoop)
└── Spark (Procesamiento en memoria)
```

---

## 📚 **GUÍAS DISPONIBLES**

### **🐝 [HIVE SETUP](hive-setup.md)**
**¿Qué aprenderás?**
- ✅ Configurar Apache Hive desde cero
- ✅ Crear tablas y cargar datos
- ✅ Ejecutar consultas SQL sobre Big Data
- ✅ Integrar Hive con Spark

**📊 Contenido:**
- Configuración del metastore con PostgreSQL
- Creación de tablas desde archivos CSV
- Consultas de ejemplo con JOINs
- Integración con Spark para análisis avanzado

**⏱️ Tiempo estimado:** 2-3 horas  
**🎯 Resultado:** Hive funcionando con datos del curso

---

### **📁 [HDFS MANAGEMENT](hdfs-management.md)**
**¿Qué aprenderás?**
- ✅ Dominar comandos HDFS esenciales
- ✅ Gestionar archivos distribuidos
- ✅ Optimizar almacenamiento
- ✅ Monitorear uso de espacio

**📊 Contenido:**
- Comandos básicos de navegación
- Transferencia de archivos
- Gestión de permisos
- Monitoreo y mantenimiento

**⏱️ Tiempo estimado:** 1-2 horas  
**🎯 Resultado:** Gestión eficiente de archivos en HDFS

---

### **⚡ [YARN MONITORING](yarn-monitoring.md)**
**¿Qué aprenderás?**
- ✅ Monitorear recursos del cluster
- ✅ Gestionar aplicaciones YARN
- ✅ Optimizar configuración
- ✅ Resolver problemas de recursos

**📊 Contenido:**
- Comandos de monitoreo del cluster
- Gestión de aplicaciones
- Configuración de recursos
- Troubleshooting avanzado

**⏱️ Tiempo estimado:** 1-2 horas  
**🎯 Resultado:** Cluster optimizado y monitoreado

---

### **🔥 [SPARK JOBS](spark-jobs.md)**
**¿Qué aprenderás?**
- ✅ Ejecutar jobs de Spark y MapReduce
- ✅ Probar funcionalidad del cluster
- ✅ Optimizar configuración de Spark
- ✅ Monitorear ejecución de jobs

**📊 Contenido:**
- Jobs de ejemplo (Pi, WordCount, Grep)
- Configuración avanzada de Spark
- Monitoreo de aplicaciones
- Troubleshooting de jobs

**⏱️ Tiempo estimado:** 2-3 horas  
**🎯 Resultado:** Cluster validado y optimizado

---

## 🎯 **RUTAS DE APRENDIZAJE**

### **🏗️ ARQUITECTO DE BIG DATA**
```
1. hive-setup.md          → Configurar Hive
2. hdfs-management.md     → Gestionar almacenamiento
3. yarn-monitoring.md     → Monitorear recursos
4. spark-jobs.md          → Validar cluster
```
**⏱️ Tiempo total:** 6-8 horas  
**🎯 Objetivo:** Dominar todo el ecosistema Hadoop

### **⚡ DESARROLLADOR SPARK**
```
1. hive-setup.md          → Datos para Spark
2. spark-jobs.md          → Jobs de Spark
3. yarn-monitoring.md     → Optimizar recursos
4. hdfs-management.md     → Gestionar datos
```
**⏱️ Tiempo total:** 5-7 horas  
**🎯 Objetivo:** Desarrollo eficiente con Spark

### **📊 DATA ENGINEER**
```
1. hdfs-management.md     → Almacenamiento
2. hive-setup.md          → Data warehouse
3. yarn-monitoring.md     → Recursos
4. spark-jobs.md          → Procesamiento
```
**⏱️ Tiempo total:** 6-8 horas  
**🎯 Objetivo:** Pipeline completo de datos

---

## 🧪 **LABORATORIOS PRÁCTICOS**

### **🏆 Lab 1: Análisis de Ventas con Hive**
**Objetivo:** Crear análisis completo de ventas usando Hive
**Tiempo:** 2-3 horas
**Habilidades:** Hive, SQL, Análisis de datos

```sql
-- Ejemplo de lo que construirás:
SELECT 
    c.ciudad,
    p.categoria,
    COUNT(v.id_venta) as total_ventas,
    SUM(v.precio * v.cantidad) as ingresos,
    AVG(v.precio * v.cantidad) as ticket_promedio
FROM ventas v
JOIN clientes c ON v.id_cliente = c.id_cliente
JOIN productos p ON v.id_producto = p.id_producto
GROUP BY c.ciudad, p.categoria
ORDER BY ingresos DESC;
```

### **🏆 Lab 2: Optimización de Cluster**
**Objetivo:** Optimizar configuración del cluster
**Tiempo:** 1-2 horas  
**Habilidades:** YARN, Configuración, Monitoreo

### **🏆 Lab 3: Pipeline de Datos Completo**
**Objetivo:** Crear pipeline de datos end-to-end
**Tiempo:** 3-4 horas
**Habilidades:** HDFS, Hive, Spark, YARN

---

## 📈 **CASOS DE USO REALES**

### **🏢 Para Analistas de Negocio:**
```sql
-- Análisis de tendencias de ventas
SELECT 
    YEAR(fecha_venta) as año,
    MONTH(fecha_venta) as mes,
    COUNT(*) as total_ventas,
    SUM(precio * cantidad) as ingresos,
    AVG(precio * cantidad) as ticket_promedio
FROM ventas
GROUP BY YEAR(fecha_venta), MONTH(fecha_venta)
ORDER BY año, mes;
```

### **💰 Para Directores Financieros:**
```sql
-- Análisis de rentabilidad por producto
SELECT 
    p.nombre_producto,
    p.precio as precio_venta,
    COUNT(v.id_venta) as veces_vendido,
    SUM(v.cantidad) as unidades_vendidas,
    SUM(v.precio * v.cantidad) as ingresos_totales
FROM productos p
JOIN ventas v ON p.id_producto = v.id_producto
GROUP BY p.id_producto, p.nombre_producto, p.precio
ORDER BY ingresos_totales DESC;
```

### **👥 Para Gerentes de Marketing:**
```sql
-- Segmentación de clientes
SELECT 
    c.ciudad,
    COUNT(DISTINCT c.id_cliente) as clientes_unicos,
    COUNT(v.id_venta) as total_compras,
    SUM(v.precio * v.cantidad) as ingresos_totales,
    AVG(v.precio * v.cantidad) as ticket_promedio
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
GROUP BY c.ciudad
ORDER BY ingresos_totales DESC;
```

---

## 💡 **CONCEPTOS CLAVE**

### **🏗️ Arquitectura del Sistema:**
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   PostgreSQL    │    │      HDFS       │    │   Apache Hive   │
│   (MetaStore)   │◄──►│ (Almacenamiento)│◄──►│   (SQL Engine)  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                        │                        │
         │                        │                        │
         └────────────────────────┼────────────────────────┘
                                  │
                        ┌─────────────────┐
                        │   Apache Spark  │
                        │   (Procesamiento)│
                        └─────────────────┘
```

### **⚡ Flujo de Datos:**
1. **Datos** → HDFS (almacenamiento distribuido)
2. **Metadatos** → PostgreSQL (esquemas de tablas)
3. **Consultas** → Hive (SQL sobre HDFS)
4. **Procesamiento** → Spark (análisis avanzado)
5. **Recursos** → YARN (gestión de cluster)

---

## 🔧 **CONFIGURACIONES RECOMENDADAS**

### **⚡ Spark Optimizado:**
```bash
# Configuración recomendada para el curso
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
  --conf spark.sql.adaptive.enabled=false \
  --conf spark.serializer=org.apache.spark.serializer.KryoSerializer
```

### **📊 YARN Configurado:**
```bash
# Verificar configuración actual
yarn node -list -showDetails

# Configuración recomendada:
# - Memoria total por nodo: 2GB
# - Cores por nodo: 2
# - Factor de replicación HDFS: 3
```

---

## 🚨 **TROUBLESHOOTING**

### **❌ Problemas Comunes:**

#### **🔌 "Connection refused"**
```bash
# Verificar servicios
docker-compose ps

# Reiniciar servicios
docker-compose restart master
```

#### **💾 "Out of memory"**
```bash
# Verificar recursos
yarn node -list

# Reducir memoria de Spark
spark-submit --executor-memory 512m --driver-memory 512m
```

#### **📁 "File not found"**
```bash
# Verificar HDFS
hdfs dfs -ls /data/

# Verificar permisos
hdfs dfs -ls -la /data/
```

---

## 🔗 **RECURSOS ADICIONALES**

### **📚 Guías Relacionadas:**
- **PostgreSQL:** `../postgresql/`
- **Troubleshooting:** `../troubleshooting/problemas-comunes.md`
- **Conceptos:** `../../03-CONCEPTS/`

### **🛠️ Herramientas Útiles:**
- **Hive Web UI:** http://localhost:10002
- **HDFS Web UI:** http://localhost:9870
- **YARN Web UI:** http://localhost:8088
- **Spark Master UI:** http://localhost:8080

### **📖 Documentación:**
- Apache Hadoop Documentation
- Apache Spark Programming Guide
- Apache Hive Language Manual

---

## 🆘 **¿NECESITAS AYUDA?**

### **🚨 Problemas Comunes:**
- **Cluster no responde:** Verificar servicios Docker
- **Jobs lentos:** Optimizar configuración de memoria
- **Datos no encontrados:** Verificar HDFS y permisos

### **📞 Soporte:**
- **Instructor:** Consulta en clase
- **Logs:** `docker-compose logs master`
- **Documentación:** Links a recursos oficiales

### **💡 Estrategia de Aprendizaje:**
1. **Empezar con Hive** → Configuración básica
2. **Practicar con HDFS** → Gestión de archivos
3. **Monitorear con YARN** → Recursos del cluster
4. **Validar con Spark** → Jobs de prueba

**🎯 ¡Con estas guías dominarás el ecosistema completo de Big Data!**
