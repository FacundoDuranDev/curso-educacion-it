# 📊 CARGA DE DATOS COMPLETA

> **🎯 Objetivo:** Entender y manejar el flujo completo de datos PostgreSQL ↔ Hadoop/Hive

## 🚀 **CARGA AUTOMÁTICA (RECOMENDADA)**

### **⚡ Un Solo Comando:**
```bash
make
# Esto automáticamente:
# ✅ Crea base de datos PostgreSQL
# ✅ Carga todos los CSV a PostgreSQL  
# ✅ Configura HDFS y Hive
# ✅ Sincroniza metadatos
```

**⏱️ Tiempo:** 5-10 minutos  
**📊 Resultado:** Sistema completo funcionando

---

## 🔄 **ARQUITECTURA DE DATOS**

### **📋 Flujo de Información:**
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   ARCHIVOS CSV  │    │   POSTGRESQL    │    │      HIVE       │
│   data/etapa1/  │───▶│   educacionit   │───▶│   metadatos     │
│   data/etapa2/  │    │   (datos reales)│    │  (estructura)   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │                       │
                                │                       │
                                ▼                       ▼
                       ┌─────────────────┐    ┌─────────────────┐
                       │  CONSULTAS SQL  │    │      HDFS       │
                       │   (análisis)    │    │ (big data files)│
                       └─────────────────┘    └─────────────────┘
```

---

## 📁 **DATOS DISPONIBLES**

### **📊 Etapa 1 (Datos Principales):**
```
data/etapa1/
├── Clientes.csv        → 1000+ registros de clientes
├── PRODUCTOS.csv       → Catálogo completo de productos
├── Venta.csv          → Transacciones históricas
├── Empleados.csv      → Personal de la empresa
├── Sucursales.csv     → Ubicaciones de tiendas
├── Proveedores.csv    → Información de proveedores
├── Gasto.csv          → Gastos operativos
├── TiposDeGasto.csv   → Categorías de gastos
├── CanalDeVenta.csv   → Canales de distribución
└── Compra.csv         → Compras a proveedores
```

### **🔄 Etapa 2 (Datos Actualizados):**
```
data/etapa2/
└── Clientes_Actualizado.csv → Versión actualizada de clientes
```

### **➕ Datos Adicionales:**
```
data/
├── nuevos_clientes.csv        → Clientes nuevos para agregar
└── modificaciones_clientes.csv → Cambios en clientes existentes
```

---

## 🗄️ **TABLAS POSTGRESQL**

### **📋 Esquema de Base de Datos:**
```sql
-- Tablas creadas automáticamente:
educacionit.public:
├── clientes         -- Información de clientes
├── productos        -- Catálogo de productos
├── ventas          -- Transacciones de venta
├── empleados       -- Personal de la empresa
├── sucursales      -- Ubicaciones de tiendas
├── proveedores     -- Proveedores de productos
├── gastos          -- Gastos operativos
├── tiposdegasto    -- Categorías de gastos
├── canaldeventa    -- Canales de distribución
└── compras         -- Compras a proveedores
```

### **🔍 Verificar Datos Cargados:**
```sql
-- Contar registros en todas las tablas
SELECT 'clientes' as tabla, count(*) as registros FROM clientes
UNION ALL
SELECT 'productos' as tabla, count(*) as registros FROM productos  
UNION ALL
SELECT 'ventas' as tabla, count(*) as registros FROM ventas
UNION ALL
SELECT 'empleados' as tabla, count(*) as registros FROM empleados
UNION ALL
SELECT 'sucursales' as tabla, count(*) as registros FROM sucursales
UNION ALL
SELECT 'proveedores' as tabla, count(*) as registros FROM proveedores
UNION ALL
SELECT 'gastos' as tabla, count(*) as registros FROM gastos
UNION ALL
SELECT 'tiposdegasto' as tabla, count(*) as registros FROM tiposdegasto
UNION ALL
SELECT 'canaldeventa' as tabla, count(*) as registros FROM canaldeventa
UNION ALL
SELECT 'compras' as tabla, count(*) as registros FROM compras;
```

---

## 🔧 **CARGA MANUAL (SI ES NECESARIO)**

### **📥 Paso 1: Crear Tablas**
```bash
# Ejecutar script de creación de tablas
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -f /opt/scripts/create_tables.sql
```

### **📊 Paso 2: Cargar Datos CSV**
```bash
# Cargar todos los datos automáticamente
docker exec -it educacionit-metastore-1 bash /opt/scripts/load_data.sh
```

### **✅ Paso 3: Verificar Carga**
```bash
# Verificar que los datos se cargaron correctamente
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "
SELECT 
    schemaname,
    tablename,
    n_tup_ins as registros_insertados,
    n_tup_upd as registros_actualizados
FROM pg_stat_user_tables 
ORDER BY tablename;
"
```

---

## 🐝 **INTEGRACIÓN CON HIVE**

### **🔗 Metastore Compartido:**
PostgreSQL actúa como **Hive Metastore**, almacenando:
- 📊 **Esquemas de tablas** Hive
- 📁 **Ubicaciones HDFS** de los datos
- 🔧 **Metadatos** de particiones
- 📋 **Estadísticas** de tablas

### **⚙️ Configuración Automática:**
```bash
# El sistema automáticamente:
# 1. Configura Hive para usar PostgreSQL como metastore
# 2. Crea tablas Hive que apuntan a datos en HDFS
# 3. Sincroniza esquemas entre PostgreSQL y Hive
```

### **🔍 Ver Metadatos Hive:**
```sql
-- Conectar a la base metastore
docker exec -it educacionit-metastore-1 psql -U jupyter -d metastore

-- Ver tablas Hive registradas
SELECT 
    t.tbl_name as tabla_hive,
    d.name as database_hive,
    s.location as ubicacion_hdfs
FROM TBLS t
JOIN DBS d ON t.db_id = d.db_id  
JOIN SDS s ON t.sd_id = s.sd_id;
```

---

## 📁 **DATOS EN HDFS**

### **🗂️ Estructura de Directorios:**
```bash
# Ver estructura HDFS
docker exec -it educacionit-master-1 hdfs dfs -ls /

# Directorios típicos:
/user/hive/warehouse/    # Datos de Hive
/tmp/                    # Archivos temporales
/data/                   # Datos del curso
```

### **📊 Cargar Datos a HDFS:**
```bash
# Copiar CSV a HDFS (si es necesario)
docker exec -it educacionit-master-1 hdfs dfs -put /opt/data/etapa1/*.csv /data/

# Verificar archivos en HDFS
docker exec -it educacionit-master-1 hdfs dfs -ls /data/
```

---

## 🔄 **SINCRONIZACIÓN DE DATOS**

### **📈 PostgreSQL → Hive:**
```sql
-- En Hive, crear tabla externa que lee de PostgreSQL
CREATE TABLE clientes_postgresql (
    id_cliente INT,
    nombre_completo STRING,
    email STRING
)
STORED BY 'org.apache.hadoop.hive.jdbc.storagehandler.JdbcStorageHandler'
TBLPROPERTIES (
    "hive.sql.database.type" = "POSTGRES",
    "hive.sql.jdbc.driver" = "org.postgresql.Driver",
    "hive.sql.jdbc.url" = "jdbc:postgresql://metastore:5432/educacionit",
    "hive.sql.dbcp.username" = "admin",
    "hive.sql.dbcp.password" = "admin123",
    "hive.sql.table" = "clientes"
);
```

### **📉 Hive → PostgreSQL:**
```bash
# Exportar resultados de Hive a PostgreSQL
docker exec -it educacionit-master-1 hive -e "
INSERT OVERWRITE DIRECTORY '/tmp/export_clientes'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT * FROM clientes WHERE edad > 30;
"

# Importar a PostgreSQL
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "
COPY clientes_mayores_30 FROM '/tmp/export_clientes/000000_0' 
WITH (FORMAT csv, DELIMITER ',');
"
```

---

## 🧪 **CONSULTAS DE EJEMPLO**

### **📊 Análisis en PostgreSQL:**
```sql
-- Top 10 productos más vendidos
SELECT 
    p.nombre_producto,
    SUM(v.cantidad) as total_vendido,
    SUM(v.precio * v.cantidad) as ingresos_totales
FROM productos p
JOIN ventas v ON p.id_producto = v.id_producto
GROUP BY p.id_producto, p.nombre_producto
ORDER BY total_vendido DESC
LIMIT 10;

-- Ventas por sucursal y mes
SELECT 
    s.nombre_sucursal,
    DATE_TRUNC('month', v.fecha_venta) as mes,
    COUNT(*) as total_ventas,
    SUM(v.precio * v.cantidad) as ingresos
FROM sucursales s
JOIN ventas v ON s.id_sucursal = v.id_sucursal
GROUP BY s.id_sucursal, s.nombre_sucursal, DATE_TRUNC('month', v.fecha_venta)
ORDER BY mes DESC, ingresos DESC;
```

### **🔥 Análisis en Hive/Spark:**
```sql
-- Conectar a Hive
docker exec -it educacionit-master-1 hive

-- Análisis de grandes volúmenes
SELECT 
    canal.nombre_canal,
    COUNT(*) as total_ventas,
    AVG(venta.precio * venta.cantidad) as ticket_promedio
FROM ventas venta
JOIN canaldeventa canal ON venta.id_canal = canal.id_canal
GROUP BY canal.nombre_canal
ORDER BY total_ventas DESC;
```

---

## 🚨 **TROUBLESHOOTING**

### **❌ "No data loaded"**
```bash
# Verificar archivos CSV existen
ls -la data/etapa1/

# Verificar permisos
docker exec -it educacionit-metastore-1 ls -la /opt/data/

# Recargar datos manualmente
docker exec -it educacionit-metastore-1 bash /opt/scripts/load_data.sh
```

### **❌ "Connection to PostgreSQL failed"**
```bash
# Verificar PostgreSQL está corriendo
docker ps | grep metastore

# Probar conexión
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "SELECT 1;"

# Ver logs
docker-compose logs metastore
```

### **❌ "Hive metastore error"**
```bash
# Verificar metastore database
docker exec -it educacionit-metastore-1 psql -U jupyter -d metastore -c "\dt"

# Reinicializar metastore si es necesario
docker exec -it educacionit-master-1 schematool -dbType postgres -initSchema
```

---

## 📚 **SCRIPTS DISPONIBLES**

### **🔧 Scripts de Carga:**
```bash
scripts/
├── create_tables.sql      # Crear todas las tablas
├── load_data.sql         # Cargar datos SQL
├── load_data.sh          # Script de carga automática
└── setup_database.sh     # Configuración completa
```

### **📊 Scripts de Análisis:**
```bash
# Ejecutar análisis predefinidos
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -f /opt/scripts/analisis_ventas.sql
```

---

## 🎯 **CASOS DE USO COMUNES**

### **📈 Para Data Analysts:**
1. **Conectar DBeaver** → `conexion-dbeaver.md`
2. **Ejecutar consultas SQL** → PostgreSQL directamente
3. **Crear dashboards** → Conectar PowerBI/Tableau

### **🔄 Para Data Engineers:**
1. **Procesar con Spark** → `../hadoop-spark/spark-postgresql.md`
2. **ETL Pipelines** → `../../03-CONCEPTS/etl-patterns.md`
3. **Data Lakes** → `../hadoop-spark/hdfs-management.md`

### **🧪 Para Data Scientists:**
1. **Jupyter + PostgreSQL** → `../../01-GETTING-STARTED/jupyter-setup.md`
2. **Python + Pandas** → Conectar con psycopg2
3. **Machine Learning** → Usar datos para modelos

---

## 💡 **MEJORES PRÁCTICAS**

### **✅ Recomendaciones:**
- 🔄 **Backup regular** de PostgreSQL
- 📊 **Indexar** columnas frecuentemente consultadas
- 🎯 **Particionar** tablas grandes por fecha
- 🔧 **Monitorear** rendimiento de consultas

### **⚠️ Precauciones:**
- 💾 **No borrar** metastore sin backup
- 🔒 **Cambiar credenciales** en producción
- 📈 **Monitorear espacio** en disco
- 🚀 **Optimizar consultas** lentas

---

## 🆘 **¿NECESITAS AYUDA?**

- 🚨 **Problemas de carga:** `../troubleshooting/problemas-comunes.md`
- 🔑 **Credenciales:** `../../04-REFERENCE/credenciales.md`
- 🐝 **Hive setup:** `../hadoop-spark/hive-setup.md`
- 📞 **Soporte:** Consulta con tu instructor

**🎯 ¡Con los datos cargados, ya puedes realizar análisis completos de Big Data!**
