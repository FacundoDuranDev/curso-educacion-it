# 🐘 POSTGRESQL - GUÍAS PRÁCTICAS

> **🎯 Todo lo que necesitas para trabajar con PostgreSQL en el curso**

## 🚀 **INICIO RÁPIDO**

### **⚡ Para Nuevos Usuarios:**
1. **[📥 Instalación](instalacion.md)** - Configurar PostgreSQL completo
2. **[🔌 Conectar DBeaver](conexion-dbeaver.md)** - Cliente visual recomendado  
3. **[📊 Cargar Datos](carga-datos.md)** - Entender el flujo de datos

### **🎯 ¿Qué Necesitas Hacer?**
- **Instalar todo desde cero** → `instalacion.md`
- **Conectar desde DBeaver** → `conexion-dbeaver.md`
- **Entender cómo funcionan los datos** → `carga-datos.md`
- **Resolver problemas** → `../troubleshooting/problemas-comunes.md`

---

## 📚 **GUÍAS DISPONIBLES**

### **🔧 [INSTALACIÓN](instalacion.md)**
**¿Qué aprenderás?**
- ✅ Configurar PostgreSQL con Docker
- ✅ Crear base de datos `educacionit` 
- ✅ Configurar usuario `admin`
- ✅ Verificar que todo funciona

**⏱️ Tiempo:** 15-20 minutos  
**🎯 Resultado:** PostgreSQL funcionando con datos del curso

---

### **🔌 [CONEXIÓN DBEAVER](conexion-dbeaver.md)**
**¿Qué aprenderás?**
- ✅ Instalar DBeaver en Windows/Linux/Mac
- ✅ Configurar conexión a PostgreSQL
- ✅ Resolver problemas comunes
- ✅ Optimizar configuración

**⏱️ Tiempo:** 10-15 minutos  
**🎯 Resultado:** Cliente visual funcionando perfectamente

---

### **📊 [CARGA DE DATOS](carga-datos.md)**
**¿Qué aprenderás?**
- ✅ Entender arquitectura PostgreSQL ↔ Hive
- ✅ Ver qué datos están disponibles
- ✅ Cargar datos manualmente si es necesario
- ✅ Integrar con Hadoop/Spark

**⏱️ Tiempo:** 20-30 minutos  
**🎯 Resultado:** Dominar el flujo completo de datos

---

## 🎯 **CASOS DE USO COMUNES**

### **👨‍💼 Para Analistas de Datos:**
```
1. instalacion.md          → Configurar entorno
2. conexion-dbeaver.md     → Cliente visual
3. ../../05-EXERCISES/     → Ejercicios SQL
```

### **👨‍💻 Para Data Engineers:**
```
1. instalacion.md          → Base de datos
2. carga-datos.md          → Flujo de datos
3. ../hadoop-spark/        → Integración Big Data
```

### **👨‍🔬 Para Data Scientists:**
```
1. instalacion.md          → Datos disponibles
2. conexion-dbeaver.md     → Exploración visual
3. ../../01-GETTING-STARTED/jupyter-setup.md → Python + PostgreSQL
```

---

## 📊 **DATOS DISPONIBLES**

### **🗄️ Tablas del Curso:**
```sql
educacionit.public:
├── clientes         -- 1000+ registros de clientes
├── productos        -- Catálogo completo de productos
├── ventas          -- Transacciones históricas
├── empleados       -- Personal de la empresa
├── sucursales      -- Ubicaciones de tiendas
├── proveedores     -- Información de proveedores
├── gastos          -- Gastos operativos
├── tiposdegasto    -- Categorías de gastos
├── canaldeventa    -- Canales de distribución
└── compras         -- Compras a proveedores
```

### **🔑 Credenciales:**
```
Host: localhost:5432
Database: educacionit
Usuario: admin
Contraseña: admin123
```
👉 **Detalles completos:** `../../04-REFERENCE/credenciales.md`

---

## 🚨 **TROUBLESHOOTING RÁPIDO**

### **❌ "Connection refused"**
```bash
# PostgreSQL no está corriendo
docker-compose up -d metastore
```

### **❌ "Database does not exist"**
```bash
# Crear base educacionit
docker exec -it educacionit-metastore-1 psql -U postgres -c "CREATE DATABASE educacionit;"
```

### **❌ "Authentication failed"**
```bash
# Recrear usuario admin
docker exec -it educacionit-metastore-1 psql -U postgres -c "
CREATE USER admin WITH PASSWORD 'admin123';
GRANT ALL PRIVILEGES ON DATABASE educacionit TO admin;
"
```

👉 **Troubleshooting completo:** `../troubleshooting/problemas-comunes.md`

---

## 🔗 **INTEGRACIÓN CON OTRAS TECNOLOGÍAS**

### **🐝 Hive + PostgreSQL:**
- **Metastore compartido:** PostgreSQL almacena metadatos de Hive
- **Sincronización:** Datos fluyen entre PostgreSQL y HDFS
- **Guía:** `carga-datos.md` explica la arquitectura completa

### **⚡ Spark + PostgreSQL:**
- **Lectura directa:** Spark puede leer tablas PostgreSQL
- **Escritura:** Resultados de Spark a PostgreSQL
- **Guía:** `../hadoop-spark/spark-postgresql.md`

### **📓 Jupyter + PostgreSQL:**
- **Python + psycopg2:** Conexión desde notebooks
- **Pandas integration:** DataFrames desde PostgreSQL
- **Guía:** `../../01-GETTING-STARTED/jupyter-setup.md`

---

## 📈 **CONSULTAS DE EJEMPLO**

### **🔍 Exploración Básica:**
```sql
-- Ver todas las tablas
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public';

-- Contar registros por tabla
SELECT 'clientes' as tabla, count(*) FROM clientes
UNION ALL
SELECT 'ventas' as tabla, count(*) FROM ventas;
```

### **📊 Análisis de Negocio:**
```sql
-- Top 10 clientes por ventas
SELECT 
    c.nombre_completo,
    sum(v.precio * v.cantidad) as total_compras
FROM clientes c
JOIN ventas v ON c.id_cliente = v.id_cliente
GROUP BY c.id_cliente, c.nombre_completo
ORDER BY total_compras DESC
LIMIT 10;
```

👉 **Más ejemplos:** `../../05-EXERCISES/sql-queries/`

---

## 💡 **CONSEJOS PRO**

### **✅ Mejores Prácticas:**
- 🔄 **Usar transacciones** para cambios múltiples
- 📊 **Crear índices** en columnas frecuentemente consultadas
- 💾 **Hacer backup** antes de cambios importantes
- 🎯 **Usar LIMIT** en consultas exploratorias

### **⚡ Optimización:**
- **Conexiones:** Pool de conexiones para aplicaciones
- **Consultas:** EXPLAIN ANALYZE para optimizar
- **Índices:** Crear en foreign keys y WHERE frecuentes
- **Particionado:** Para tablas muy grandes

---

## 🆘 **¿NECESITAS AYUDA?**

### **🚨 Problemas Comunes:**
- **Conexión:** `../troubleshooting/problemas-comunes.md`
- **Credenciales:** `../../04-REFERENCE/credenciales.md`
- **Performance:** `../../03-CONCEPTS/sql-avanzado.md`

### **📞 Soporte:**
- **Instructor:** Consulta en clase
- **Documentación oficial:** https://www.postgresql.org/docs/
- **Community:** https://stackoverflow.com/questions/tagged/postgresql

---

## 🎯 **PRÓXIMOS PASOS**

### **📚 Después de PostgreSQL:**
1. **Big Data Integration:** `../hadoop-spark/`
2. **Análisis Avanzado:** `../../03-CONCEPTS/`
3. **Ejercicios Prácticos:** `../../05-EXERCISES/`

### **🚀 Proyectos Recomendados:**
- **Dashboard de Ventas:** PostgreSQL + PowerBI/Tableau
- **ETL Pipeline:** PostgreSQL → Spark → HDFS
- **Machine Learning:** PostgreSQL → Python → Jupyter

**🎯 ¡Con PostgreSQL dominado, tienes la base sólida para todo el curso de Big Data!**
