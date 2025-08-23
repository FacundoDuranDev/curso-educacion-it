# 🚀 **Guía Completa de Carga de Datos - Data Engineering (CORREGIDA)**

## 📋 **Resumen Ejecutivo**

Esta guía explica el **flujo completo de carga de datos** en el entorno de Data Engineering, incluyendo:
- ✅ **Carga en PostgreSQL** (datos reales)
- ✅ **Configuración de HDFS** (directorios del sistema)
- ✅ **Integración con Hive** (metadatos + procesamiento)

---

## 🔄 **FLUJO COMPLETO DE CARGA DE DATOS**

### **🎯 ARQUITECTURA DEL SISTEMA:**

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   ARCHIVOS CSV  │    │   POSTGRESQL    │    │      HIVE       │
│   (Etapa 1/2)  │───▶│   (Metastore)   │───▶│  (Metadatos)    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │                       │
                                │                       │
                                ▼                       ▼
                       ┌─────────────────┐    ┌─────────────────┐
                       │   TABLAS SQL    │    │      HDFS       │
                       │  (Datos reales) │    │ (Sistema arch.) │
                       └─────────────────┘    └─────────────────┘
```

---

## 📊 **PASO 1: CARGA EN POSTGRESQL (DATOS REALES)**

### **1.1 Preparación del Entorno**
```bash
# Verificar que PostgreSQL esté corriendo
docker-compose ps | grep metastore

# Si no está corriendo, levantar el servicio
docker-compose up -d metastore

# Esperar a que esté listo
sleep 10
```

### **1.2 Crear Base de Datos y Usuario**
```bash
# Conectarse como superusuario
docker exec -it educacionit-metastore-1 psql -U postgres

# Crear base de datos
CREATE DATABASE educacionit;

# Crear usuario con permisos
CREATE USER admin WITH PASSWORD 'admin123';
GRANT ALL PRIVILEGES ON DATABASE educacionit TO admin;

# Salir de psql
\q
```

### **1.3 Copiar Archivos CSV al Contenedor**
```bash
# Crear directorio temporal en el contenedor
docker exec educacionit-metastore-1 mkdir -p /tmp/etapa1

# Copiar todos los archivos CSV desde el host
docker cp data/etapa1/. educacionit-metastore-1:/tmp/etapa1/

# Verificar que se copiaron correctamente
docker exec educacionit-metastore-1 ls -la /tmp/etapa1/
```

**📁 ARCHIVOS CSV DISPONIBLES (CON DELIMITADORES CORRECTOS):**

| Archivo | Delimitador | Separador Decimal | Registros | Columnas |
|---------|-------------|-------------------|-----------|----------|
| `Clientes.csv` | `;` (punto y coma) | `,` (coma) | 3,407 | 15 |
| `Venta.csv` | `,` (coma) | `.` (punto) | 46,645 | 10 |
| `Sucursales.csv` | `;` (punto y coma) | `,` (coma) | 31 | 7 |
| `PRODUCTOS.csv` | `,` (coma) | `.` (punto) | 291 | 4 |
| `Empleados.csv` | `,` (coma) | `.` (punto) | 249 | 7 |
| `Gasto.csv` | `,` (coma) | `.` (punto) | 8,640 | 5 |
| `Compra.csv` | `,` (coma) | `.` (punto) | 11,539 | 6 |
| `Proveedores.csv` | `,` (coma) | `.` (punto) | 14 | 7 |
| `TiposDeGasto.csv` | `,` (coma) | `.` (punto) | 14 | 3 |
| `CanalDeVenta.csv` | `,` (coma) | `.` (punto) | 3 | 2 |

**⚠️ IMPORTANTE: Delimitadores mixtos**
- **Archivos con `;`**: `Clientes.csv`, `Sucursales.csv`
- **Archivos con `,`**: Todos los demás

### **1.4 Crear Estructura de Tablas**
```bash
# Copiar script de creación de tablas
docker cp scripts/create_tables.sql educacionit-metastore-1:/tmp/

# Ejecutar script para crear todas las tablas
docker exec -it educacionit-metastore-1 psql -U postgres -d educacionit -f /tmp/create_tables.sql
```

**🏗️ TABLAS CREADAS (ESQUEMA REAL):**

#### **1. `canal_venta` - Canales de venta**
```sql
codigo INTEGER PRIMARY KEY,
descripcion VARCHAR(100)
```

#### **2. `productos` - Catálogo de productos**
```sql
id_producto INTEGER PRIMARY KEY,
concepto VARCHAR(200),
tipo VARCHAR(100),
precio DECIMAL(10,2)
```

#### **3. `proveedores` - Información de proveedores**
```sql
id_proveedor INTEGER PRIMARY KEY,
nombre VARCHAR(100),
address TEXT,
city VARCHAR(100),
state VARCHAR(100),
country VARCHAR(100),
departamen VARCHAR(100)
```

#### **4. `sucursales` - Ubicaciones de sucursales**
```sql
id INTEGER PRIMARY KEY,
sucursal VARCHAR(100),
direccion TEXT,
localidad VARCHAR(100),
provincia VARCHAR(100),
latitud VARCHAR(20),
longitud VARCHAR(20)
```

#### **5. `empleados` - Personal de la empresa**
```sql
id_empleado INTEGER PRIMARY KEY,
apellido VARCHAR(100),
nombre VARCHAR(100),
sucursal VARCHAR(100),
sector VARCHAR(100),
cargo VARCHAR(100),
salario DECIMAL(10,2)
```

#### **6. `clientes` - Base de clientes**
```sql
id INTEGER PRIMARY KEY,
provincia VARCHAR(100),
nombre_y_apellido VARCHAR(200),
domicilio TEXT,
telefono VARCHAR(50),
edad INTEGER,
localidad VARCHAR(100),
x VARCHAR(20),
y VARCHAR(20),
fecha_alta DATE,
usuario_alta VARCHAR(50),
fecha_ultima_modificacion DATE,
usuario_ultima_modificacion VARCHAR(50),
marca_baja INTEGER,
col10 VARCHAR(50)
```

#### **7. `tipos_gasto` - Categorías de gastos**
```sql
id_tipo_gasto INTEGER PRIMARY KEY,
descripcion VARCHAR(100),
monto_aproximado DECIMAL(10,2)
```

#### **8. `gastos` - Registro de gastos por sucursal**
```sql
id_gasto INTEGER PRIMARY KEY,
id_sucursal INTEGER REFERENCES sucursales(id),
id_tipo_gasto INTEGER REFERENCES tipos_gasto(id_tipo_gasto),
fecha DATE,
monto DECIMAL(10,2)
```

#### **9. `compras` - Historial de compras**
```sql
id_compra INTEGER PRIMARY KEY,
fecha DATE,
id_producto INTEGER REFERENCES productos(id_producto),
cantidad INTEGER,
precio DECIMAL(10,2),
id_proveedor INTEGER REFERENCES proveedores(id_proveedor)
```

#### **10. `ventas` - Historial de ventas**
```sql
id_venta INTEGER PRIMARY KEY,
fecha DATE,
fecha_entrega DATE,
id_canal INTEGER REFERENCES canal_venta(codigo),
id_cliente INTEGER REFERENCES clientes(id),
id_sucursal INTEGER REFERENCES sucursales(id),
id_empleado INTEGER REFERENCES empleados(id_empleado),
id_producto INTEGER REFERENCES productos(id_producto),
precio DECIMAL(10,2),
cantidad INTEGER
```

### **1.5 Cargar Datos en las Tablas (CON DELIMITADORES CORRECTOS)**

**⚠️ IMPORTANTE: Usar delimitadores correctos para cada archivo**

```bash
# 1. Cargar clientes (delimitador: ;)
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "
\copy clientes FROM '/tmp/etapa1/Clientes.csv' WITH (FORMAT csv, DELIMITER ';', HEADER true, ENCODING 'UTF8');"

# 2. Cargar sucursales (delimitador: ;)
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "
\copy sucursales FROM '/tmp/etapa1/Sucursales.csv' WITH (FORMAT csv, DELIMITER ';', HEADER true, ENCODING 'UTF8');"

# 3. Cargar tipos de gasto (delimitador: ,)
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "
\copy tipos_gasto FROM '/tmp/etapa1/TiposDeGasto.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"

# 4. Cargar gastos (delimitador: ,)
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "
\copy gastos FROM '/tmp/etapa1/Gasto.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"

# 5. Cargar compras (delimitador: ,)
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "
\copy compras FROM '/tmp/etapa1/Compra.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"

# 6. Cargar productos (delimitador: ,)
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "
\copy productos FROM '/tmp/etapa1/PRODUCTOS.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"

# 7. Cargar proveedores (delimitador: ,)
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "
\copy proveedores FROM '/tmp/etapa1/Proveedores.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"

# 8. Cargar empleados (delimitador: ,)
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "
\copy empleados FROM '/tmp/etapa1/Empleados.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"

# 9. Cargar canal de venta (delimitador: ,)
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "
\copy canal_venta FROM '/tmp/etapa1/CanalDeVenta.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"

# 10. Cargar ventas (delimitador: ,)
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "
\copy ventas FROM '/tmp/etapa1/Venta.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"
```

**📊 RESULTADO ESPERADO (CON DELIMITADORES CORRECTOS):**
```
COPY 3407    # clientes (;)
COPY 31      # sucursales (;)
COPY 14      # tipos_gasto (,)
COPY 8640    # gastos (,)
COPY 11539   # compras (,)
COPY 291     # productos (,)
COPY 14      # proveedores (,)
COPY 249     # empleados (,)
COPY 3       # canal_venta (,)
COPY 46645   # ventas (,)
```

### **1.6 Verificar Carga de Datos**
```bash
# Conectarse a la base de datos
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit

# Ver todas las tablas
\dt

# Contar registros en cada tabla
SELECT 
    'clientes' as tabla, COUNT(*) as registros FROM clientes
UNION ALL
SELECT 'sucursales', COUNT(*) FROM sucursales
UNION ALL
SELECT 'productos', COUNT(*) FROM productos
UNION ALL
SELECT 'ventas', COUNT(*) FROM ventas
UNION ALL
SELECT 'empleados', COUNT(*) FROM empleados
UNION ALL
SELECT 'gastos', COUNT(*) FROM gastos
UNION ALL
SELECT 'compras', COUNT(*) FROM compras
UNION ALL
SELECT 'proveedores', COUNT(*) FROM proveedores
UNION ALL
SELECT 'tipos_gasto', COUNT(*) FROM tipos_gasto
UNION ALL
SELECT 'canal_venta', COUNT(*) FROM canal_venta
ORDER BY tabla;

# Salir de psql
\q
```

---

## 🗄️ **PASO 2: CONFIGURACIÓN DE HDFS (SISTEMA DE ARCHIVOS)**

### **2.1 Acceso al Contenedor Master**
```bash
# Entrar al contenedor master (Hadoop + Hive + Spark)
docker exec -it educacionit-master-1 bash
```

### **2.2 Crear Directorios HDFS para Hive**
```bash
# Directorio principal del warehouse de Hive
hdfs dfs -mkdir -p /user/hive/warehouse

# Directorio temporal para operaciones
hdfs dfs -mkdir -p /tmp

# Directorio de usuario de Hive
hdfs dfs -mkdir -p /user/hive
```

**Explicación de directorios:**
- **`/user/hive/warehouse`**: Almacena las tablas de Hive
- **`/tmp`**: Directorio temporal para operaciones
- **`/user/hive`**: Directorio de usuario del sistema Hive

### **2.3 Configurar Permisos HDFS**
```bash
# Dar permisos completos a los directorios
hdfs dfs -chmod 777 /user/hive/warehouse
hdfs dfs -chmod 777 /tmp
hdfs dfs -chmod 777 /user/hive
```

**¿Por qué permisos 777?**
- **Desarrollo**: Facilita operaciones sin problemas de permisos
- **Testing**: Permite pruebas rápidas del sistema
- **⚠️ Producción**: NO usar permisos 777 en entornos productivos

### **2.4 Verificar Directorios Creados**
```bash
# Listar directorios del warehouse
hdfs dfs -ls /user/hive/

# Listar directorio temporal
hdfs dfs -ls /tmp/

# Verificar permisos
hdfs dfs -ls -d /user/hive/warehouse
```

---

## 🐝 **PASO 3: CONFIGURACIÓN DE HIVE**

### **3.1 Configurar Archivo de Configuración**
```bash
# Copiar archivo de configuración funcional
cp /opt/hive/conf/hive-site-working.xml /opt/hive/conf/hive-site.xml

# Verificar que se copió correctamente
ls -la /opt/hive/conf/hive-site.xml
```

### **3.2 Reiniciar Servicios de Hive**
```bash
# Detener servicios actuales
pkill -f HiveServer2
pkill -f MetaStore

# Iniciar MetaStore en background
/opt/hive/bin/hive --service metastore &

# Iniciar HiveServer2 en background
/opt/hive/bin/hive --service hiveserver2 &

# Verificar que estén corriendo
ps aux | grep hive
```

### **3.3 Verificar Estado de Hive**
```bash
# Verificar puerto de HiveServer2
netstat -tlnp | grep 10000

# Verificar logs de Hive
tail -f /opt/hive/logs/hive.log
```

---

## 🔍 **PASO 4: VERIFICACIÓN COMPLETA**

### **4.1 Verificar PostgreSQL**
```bash
# Conectarse desde otro terminal
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit

# Verificar tablas y datos
\dt
SELECT COUNT(*) FROM clientes;
SELECT COUNT(*) FROM ventas;

\q
```

### **4.2 Verificar HDFS**
```bash
# Desde el contenedor master
hdfs dfs -ls /user/hive/
hdfs dfs -ls /tmp/
```

### **4.3 Verificar Hive**
```bash
# Conectar a Hive desde el contenedor master
/opt/hive/bin/beeline -u jdbc:hive2://localhost:10000 -n root

# Ejecutar consultas de prueba
SHOW DATABASES;
SHOW TABLES;

# Salir de beeline
!quit
```

---

## 🚀 **SCRIPT AUTOMATIZADO (TODO EN UNO) - CORREGIDO**

### **4.1 Script Completo con Delimitadores Correctos**
```bash
#!/bin/bash

echo "🚀 Configurando entorno completo de Data Engineering..."
echo "=================================================="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 1. LEVANTAR SERVICIOS
echo -e "${BLUE}📦 Paso 1: Levantando servicios...${NC}"
docker-compose up -d
sleep 15

# 2. CONFIGURAR POSTGRESQL
echo -e "${BLUE}🗄️ Paso 2: Configurando PostgreSQL...${NC}"
docker exec -it educacionit-metastore-1 psql -U postgres -c "CREATE DATABASE educacionit;" 2>/dev/null || true
docker exec -it educacionit-metastore-1 psql -U postgres -c "CREATE USER admin WITH PASSWORD 'admin123';" 2>/dev/null || true
docker exec -it educacionit-metastore-1 psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE educacionit TO admin;" 2>/dev/null || true

# 3. COPIAR CSV Y CREAR TABLAS
echo -e "${BLUE}📁 Paso 3: Copiando archivos CSV...${NC}"
docker cp data/etapa1/. educacionit-metastore-1:/tmp/etapa1/

echo -e "${BLUE}🏗️ Paso 4: Creando tablas...${NC}"
docker exec -i educacionit-metastore-1 psql -U admin -d educacionit < scripts/create_tables.sql

# 4. CARGAR DATOS CON DELIMITADORES CORRECTOS
echo -e "${BLUE}📊 Paso 5: Cargando datos con delimitadores correctos...${NC}"

# Archivos con delimitador ; (punto y coma)
echo -e "${YELLOW}   • Cargando clientes (delimitador: ;)...${NC}"
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy clientes FROM '/tmp/etapa1/Clientes.csv' WITH (FORMAT csv, DELIMITER ';', HEADER true, ENCODING 'UTF8');"

echo -e "${YELLOW}   • Cargando sucursales (delimitador: ;)...${NC}"
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy sucursales FROM '/tmp/etapa1/Sucursales.csv' WITH (FORMAT csv, DELIMITER ';', HEADER true, ENCODING 'UTF8');"

# Archivos con delimitador , (coma)
echo -e "${YELLOW}   • Cargando tipos de gasto (delimitador: ,)...${NC}"
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy tipos_gasto FROM '/tmp/etapa1/TiposDeGasto.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"

echo -e "${YELLOW}   • Cargando gastos (delimitador: ,)...${NC}"
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy gastos FROM '/tmp/etapa1/Gasto.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"

echo -e "${YELLOW}   • Cargando compras (delimitador: ,)...${NC}"
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy compras FROM '/tmp/etapa1/Compra.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"

echo -e "${YELLOW}   • Cargando productos (delimitador: ,)...${NC}"
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy productos FROM '/tmp/etapa1/PRODUCTOS.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"

echo -e "${YELLOW}   • Cargando proveedores (delimitador: ,)...${NC}"
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy proveedores FROM '/tmp/etapa1/Proveedores.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"

echo -e "${YELLOW}   • Cargando empleados (delimitador: ,)...${NC}"
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy empleados FROM '/tmp/etapa1/Empleados.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"

echo -e "${YELLOW}   • Cargando canal de venta (delimitador: ,)...${NC}"
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy canal_venta FROM '/tmp/etapa1/CanalDeVenta.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"

echo -e "${YELLOW}   • Cargando ventas (delimitador: ,)...${NC}"
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy ventas FROM '/tmp/etapa1/Venta.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"

# 5. CONFIGURAR HDFS
echo -e "${BLUE}🗄️ Paso 6: Configurando HDFS...${NC}"
docker exec educacionit-master-1 hdfs dfs -mkdir -p /user/hive/warehouse /tmp /user/hive
docker exec educacionit-master-1 hdfs dfs -chmod 777 /user/hive/warehouse /tmp /user/hive

# 6. CONFIGURAR HIVE
echo -e "${BLUE}🐝 Paso 7: Configurando Hive...${NC}"
docker exec educacionit-master-1 cp /opt/hive/conf/hive-site-working.xml /opt/hive/conf/hive-site.xml
docker exec educacionit-master-1 bash -c "pkill -f HiveServer2; pkill -f MetaStore; /opt/hive/bin/hive --service metastore & /opt/hive/bin/hive --service hiveserver2 &"
sleep 10

echo "=================================================="
echo -e "${GREEN}🎉 ¡Entorno completamente configurado!${NC}"
echo -e "${BLUE}📊 PostgreSQL: Base de datos con datos reales${NC}"
echo -e "${BLUE}🗄️ HDFS: Directorios del sistema configurados${NC}"
echo -e "${BLUE}🐝 Hive: Servicios iniciados y funcionando${NC}"
echo -e "${BLUE}🔌 Conexiones disponibles:${NC}"
echo -e "${YELLOW}   • PostgreSQL: localhost:5432 (admin/admin123)${NC}"
echo -e "${YELLOW}   • HDFS Web UI: http://localhost:9870${NC}"
echo -e "${YELLOW}   • Hive: localhost:10000${NC}"
echo -e "${YELLOW}   • Spark: http://localhost:8080${NC}"
echo -e "${YELLOW}   • Jupyter: http://localhost:8888${NC}"
```

### **4.2 Ejecutar Script**
```bash
# Dar permisos de ejecución
chmod +x setup_completo_corregido.sh

# Ejecutar script
./setup_completo_corregido.sh
```

---

## 🔧 **SOLUCIÓN DE PROBLEMAS**

### **Problema: Error de delimitador**
```bash
# Verificar delimitador del archivo
head -1 /ruta/archivo.csv

# Si usa ; (punto y coma):
\copy tabla FROM '/ruta/archivo.csv' WITH (FORMAT csv, DELIMITER ';', HEADER true);

# Si usa , (coma):
\copy tabla FROM '/ruta/archivo.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true);
```

### **Problema: PostgreSQL no responde**
```bash
# Verificar logs
docker logs educacionit-metastore-1

# Reiniciar servicio
docker-compose restart metastore
```

### **Problema: HDFS no accesible**
```bash
# Verificar estado del master
docker exec educacionit-master-1 jps

# Verificar logs
docker logs educacionit-master-1
```

### **Problema: Hive no conecta**
```bash
# Verificar servicios
docker exec educacionit-master-1 ps aux | grep hive

# Verificar puerto
docker exec educacionit-master-1 netstat -tlnp | grep 10000
```

---

## 📚 **REFERENCIAS TÉCNICAS**

### **Comandos HDFS Útiles:**
```bash
# Listar archivos
hdfs dfs -ls /

# Crear directorios
hdfs dfs -mkdir -p /ruta/directorio

# Cambiar permisos
hdfs dfs -chmod 777 /ruta/directorio

# Ver uso de espacio
hdfs dfs -df -h
```

### **Comandos Hive Útiles:**
```bash
# Conectar a Hive
beeline -u jdbc:hive2://localhost:10000 -n root

# Ver bases de datos
SHOW DATABASES;

# Ver tablas
SHOW TABLES;

# Crear tabla externa
CREATE EXTERNAL TABLE tabla_externa (
    columna1 STRING,
    columna2 INT
) LOCATION '/ruta/hdfs';
```

---

## 🎯 **RESUMEN FINAL**

### **¿Qué se carga y dónde?**

| Componente | Contenido | Propósito |
|------------|-----------|-----------|
| **PostgreSQL** | CSV → Tablas SQL | **Datos reales** del negocio |
| **HDFS** | Directorios del sistema | **Sistema de archivos** para Hive |
| **Hive** | Metadatos desde PostgreSQL | **Procesamiento SQL** sobre datos |

### **Flujo de Datos:**
1. **CSV** → **PostgreSQL** (carga masiva con delimitadores correctos)
2. **PostgreSQL** → **Hive** (metadatos)
3. **HDFS** → **Hive** (almacenamiento opcional)
4. **Hive** → **Análisis** (consultas SQL)

### **Ventajas de esta Arquitectura:**
- ✅ **PostgreSQL**: Transaccional, ACID, consultas complejas
- ✅ **HDFS**: Escalable, distribuido, tolerante a fallos
- ✅ **Hive**: SQL sobre datos distribuidos
- ✅ **Flexibilidad**: Puedes usar PostgreSQL o Hive según necesites

---

## 🎉 **¡Listo para Analizar Datos!**

Tu entorno está completamente configurado con:
- **📊 10 tablas** con datos reales en PostgreSQL
- **🗄️ HDFS** configurado para Hive
- **🐝 Hive** funcionando y conectado
- **🔌 Todas las interfaces** web accesibles

**¡Puedes empezar a hacer análisis de datos, consultas SQL y procesamiento distribuido!**
