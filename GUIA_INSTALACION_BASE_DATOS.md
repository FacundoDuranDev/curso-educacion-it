# 🗄️ Guía Completa de Instalación - Base de Datos PostgreSQL

## 📋 **Resumen**
Esta guía te permitirá configurar completamente la base de datos PostgreSQL con la base de datos `educacionit`, incluyendo todas las tablas y datos del curso de Data Engineering.

---

## 🎯 **Objetivo**
- ✅ Configurar PostgreSQL en Docker
- ✅ Crear base de datos `educacionit`
- ✅ Crear todas las tablas necesarias
- ✅ Cargar todos los datos de ejemplo
- ✅ Configurar usuario `admin` con acceso completo
- ✅ Verificar que todo funcione correctamente

---

## 🔧 **Prerrequisitos**
- ✅ Docker instalado y funcionando
- ✅ Git para clonar el repositorio
- ✅ Terminal/Línea de comandos
- ✅ Repositorio clonado en tu máquina local

---

## 📥 **Paso 1: Preparar el Entorno**

### **1.1 Clonar el Repositorio**
```bash
git clone https://github.com/FacundoDuranDev/curso-educacion-it.git
cd curso-educacion-it
```

### **1.2 Verificar Estructura de Archivos**
```bash
# Verificar que tengas estos directorios y archivos
ls -la
ls -la data/etapa1/
ls -la scripts/
```

**Archivos necesarios:**
- ✅ `docker-compose.yml`
- ✅ `data/etapa1/` (con archivos CSV)
- ✅ `scripts/create_tables.sql`
- ✅ `scripts/load_data_sql.sql`

---

## 🐳 **Paso 2: Levantar PostgreSQL**

### **2.1 Levantar Solo PostgreSQL**
```bash
# Levantar solo el servicio de PostgreSQL
docker-compose up -d metastore

# Verificar que esté funcionando
docker ps | grep metastore
```

**Resultado esperado:**
```
educacionit-metastore-1  postgres:11  "docker-entrypoint.s…"  metastore  2 minutes ago  Up 2 minutes  0.0.0.0:5432->5432/tcp
```

### **2.2 Verificar Estado del Contenedor**
```bash
# Ver logs del contenedor
docker logs educacionit-metastore-1

# Verificar que PostgreSQL esté respondiendo
docker exec -it educacionit-metastore-1 pg_isready -U postgres
```

---

## 🗄️ **Paso 3: Crear Base de Datos y Usuario**

### **3.1 Conectarse a PostgreSQL como Superusuario**
```bash
docker exec -it educacionit-metastore-1 psql -U postgres
```

**Indicador de éxito:** El prompt cambiará a `postgres=#`

### **3.2 Crear Base de Datos `educacionit`**
```sql
CREATE DATABASE educacionit;
```

**Resultado esperado:**
```
CREATE DATABASE
```

### **3.3 Crear Usuario `admin`**
```sql
CREATE USER admin WITH PASSWORD 'admin123';
```

**Resultado esperado:**
```
CREATE ROLE
```

### **3.4 Otorgar Permisos Completos**
```sql
GRANT ALL PRIVILEGES ON DATABASE educacionit TO admin;
```

**Resultado esperado:**
```
GRANT
```

### **3.5 Verificar Creación**
```sql
-- Listar bases de datos
\l

-- Listar usuarios
\du

-- Salir de psql
\q
```

**Resultado esperado:**
```
                                  List of databases
    Name     |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-------------+----------+----------+------------+------------+-----------------------
 educacionit | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/postgres         +
             |          |          |            |            | postgres=CTc/postgres+
             |          |            |            |            | admin=CTc/postgres
```

---

## 🏗️ **Paso 4: Crear Tablas**

### **4.1 Copiar Archivos CSV al Contenedor**
```bash
# Copiar todos los archivos CSV al contenedor
docker cp data/etapa1/. educacionit-metastore-1:/tmp/etapa1/

# Verificar que se copiaron correctamente
docker exec -it educacionit-metastore-1 ls -la /tmp/etapa1/
```

**Archivos que deben estar disponibles:**
- `Clientes.csv`
- `Sucursales.csv`
- `TiposDeGasto.csv`
- `Gasto.csv`
- `Compra.csv`
- `PRODUCTOS.csv`
- `Proveedores.csv`
- `Empleados.csv`
- `CanalDeVenta.csv`
- `Venta.csv`

### **4.2 Crear Todas las Tablas**
```bash
# Ejecutar script de creación de tablas
docker exec -i educacionit-metastore-1 psql -U admin -d educacionit < scripts/create_tables.sql
```

**Resultado esperado:**
```
CREATE TABLE
CREATE TABLE
CREATE TABLE
...
CREATE INDEX
CREATE INDEX
...
```

### **4.3 Verificar Tablas Creadas**
```bash
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\dt"
```

**Resultado esperado:**
```
          List of relations
 Schema |    Name     | Type  | Owner 
--------+-------------+-------+-------
 public | canal_venta | table | admin
 public | clientes    | table | admin
 public | compras     | table | admin
 public | empleados   | table | admin
 public | gastos      | table | admin
 public | productos   | table | admin
 public | proveedores | table | admin
 public | sucursales  | table | admin
 public | tipos_gasto | table | admin
 public | ventas      | table | admin
```

---

## 📊 **Paso 5: Cargar Datos**

### **5.1 Cargar Clientes**
```bash
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy clientes FROM '/tmp/etapa1/Clientes.csv' WITH (FORMAT csv, DELIMITER ';', HEADER true, ENCODING 'UTF8');"
```

**Resultado esperado:**
```
COPY 3407
```

### **5.2 Cargar Sucursales**
```bash
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy sucursales FROM '/tmp/etapa1/Sucursales.csv' WITH (FORMAT csv, DELIMITER ';', HEADER true, ENCODING 'UTF8');"
```

**Resultado esperado:**
```
COPY 31
```

### **5.3 Cargar Tipos de Gasto**
```bash
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy tipos_gasto FROM '/tmp/etapa1/TiposDeGasto.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"
```

**Resultado esperado:**
```
COPY 6
```

### **5.4 Cargar Gastos**
```bash
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy gastos FROM '/tmp/etapa1/Gasto.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"
```

**Resultado esperado:**
```
COPY 8642
```

### **5.5 Cargar Compras**
```bash
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy compras FROM '/tmp/etapa1/Compra.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"
```

**Resultado esperado:**
```
COPY 11541
```

### **5.6 Cargar Productos**
```bash
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy productos FROM '/tmp/etapa1/PRODUCTOS.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"
```

**Resultado esperado:**
```
COPY 291
```

### **5.7 Cargar Proveedores**
```bash
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy proveedores FROM '/tmp/etapa1/Proveedores.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"
```

**Resultado esperado:**
```
COPY 16
```

### **5.8 Cargar Empleados**
```bash
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy empleados FROM '/tmp/etapa1/Empleados.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"
```

**Resultado esperado:**
```
COPY 268
```

### **5.9 Cargar Canal de Venta**
```bash
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy canal_venta FROM '/tmp/etapa1/CanalDeVenta.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"
```

**Resultado esperado:**
```
COPY 5
```

### **5.10 Cargar Ventas**
```bash
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy ventas FROM '/tmp/etapa1/Venta.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"
```

**Resultado esperado:**
```
COPY 16468
```

---

## ✅ **Paso 6: Verificar Instalación**

### **6.1 Verificar Conteo de Registros**
```bash
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "
SELECT 
    'clientes' as tabla, COUNT(*) as registros FROM clientes
UNION ALL
SELECT 'sucursales', COUNT(*) FROM sucursales
UNION ALL
SELECT 'tipos_gasto', COUNT(*) FROM tipos_gasto
UNION ALL
SELECT 'gastos', COUNT(*) FROM gastos
UNION ALL
SELECT 'compras', COUNT(*) FROM compras
UNION ALL
SELECT 'productos', COUNT(*) FROM productos
UNION ALL
SELECT 'proveedores', COUNT(*) FROM proveedores
UNION ALL
SELECT 'empleados', COUNT(*) FROM empleados
UNION ALL
SELECT 'canal_venta', COUNT(*) FROM canal_venta
UNION ALL
SELECT 'ventas', COUNT(*) FROM ventas
ORDER BY tabla;"
```

**Resultado esperado:**
```
    tabla    | registros 
-------------+-----------
 canal_venta |         5
 clientes    |      3407
 compras     |     11541
 empleados   |       268
 gastos      |      8642
 productos   |       291
 proveedores |        16
 sucursales  |        31
 tipos_gasto |         6
 ventas      |     16468
```

### **6.2 Verificar Estructura de Tablas**
```bash
# Ver estructura de la tabla clientes
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\d clientes"

# Ver estructura de la tabla ventas
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\d ventas"
```

### **6.3 Ejecutar Consulta de Prueba**
```bash
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "
SELECT 
    c.nombre_y_apellido,
    COUNT(v.id_venta) as total_ventas,
    SUM(v.precio_unitario * v.cantidad) as monto_total
FROM clientes c
JOIN ventas v ON c.id = v.id_cliente
GROUP BY c.id, c.nombre_y_apellido
ORDER BY monto_total DESC
LIMIT 5;"
```

---

## 🔌 **Paso 7: Conectar con DBeaver**

### **7.1 Configuración de Conexión**
- **Host:** `localhost`
- **Puerto:** `5432`
- **Base de datos:** `educacionit`
- **Usuario:** `admin`
- **Contraseña:** `admin123`

### **7.2 Probar Conexión**
```bash
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "SELECT 'Conexión exitosa!' as mensaje;"
```

**Resultado esperado:**
```
   mensaje    
--------------
 Conexión exitosa!
```

---

## 🚀 **Script Automático (Todo en Uno)**

Si quieres hacer todo de una vez, puedes usar este script:

```bash
#!/bin/bash
echo "🚀 Configurando base de datos PostgreSQL completa..."

# 1. Verificar que PostgreSQL esté corriendo
if ! docker ps | grep -q "educacionit-metastore-1"; then
    echo "❌ Error: PostgreSQL no está corriendo. Ejecuta: docker-compose up -d metastore"
    exit 1
fi

# 2. Crear base de datos y usuario
echo "🗄️ Creando base de datos y usuario..."
docker exec -it educacionit-metastore-1 psql -U postgres -c "CREATE DATABASE educacionit;" 2>/dev/null || true
docker exec -it educacionit-metastore-1 psql -U postgres -c "CREATE USER admin WITH PASSWORD 'admin123';" 2>/dev/null || true
docker exec -it educacionit-metastore-1 psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE educacionit TO admin;" 2>/dev/null || true

# 3. Copiar archivos CSV
echo "📁 Copiando archivos CSV..."
docker cp data/etapa1/. educacionit-metastore-1:/tmp/etapa1/

# 4. Crear tablas
echo "🏗️ Creando tablas..."
docker exec -i educacionit-metastore-1 psql -U admin -d educacionit < scripts/create_tables.sql

# 5. Cargar datos
echo "📊 Cargando datos..."
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy clientes FROM '/tmp/etapa1/Clientes.csv' WITH (FORMAT csv, DELIMITER ';', HEADER true, ENCODING 'UTF8');"
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy sucursales FROM '/tmp/etapa1/Sucursales.csv' WITH (FORMAT csv, DELIMITER ';', HEADER true, ENCODING 'UTF8');"
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy tipos_gasto FROM '/tmp/etapa1/TiposDeGasto.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy gastos FROM '/tmp/etapa1/Gasto.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy compras FROM '/tmp/etapa1/Compra.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy productos FROM '/tmp/etapa1/PRODUCTOS.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy proveedores FROM '/tmp/etapa1/Proveedores.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy empleados FROM '/tmp/etapa1/Empleados.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy canal_venta FROM '/tmp/etapa1/CanalDeVenta.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy ventas FROM '/tmp/etapa1/Venta.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"

# 6. Verificar resultado
echo "🔍 Verificando instalación..."
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "
SELECT 
    'clientes' as tabla, COUNT(*) as registros FROM clientes
UNION ALL
SELECT 'sucursales', COUNT(*) FROM sucursales
UNION ALL
SELECT 'productos', COUNT(*) FROM productos
UNION ALL
SELECT 'ventas', COUNT(*) FROM ventas
ORDER BY tabla;"

echo ""
echo "✅ ¡Base de datos PostgreSQL configurada completamente!"
echo "📊 Base de datos: educacionit"
echo "👤 Usuario: admin"
echo "🔑 Contraseña: admin123"
echo "🔌 Puerto: 5432"
echo "📈 Total de registros: ~42,000+"
```

---

## 🆘 **Solución de Problemas**

### **Error: "role admin does not exist"**
```bash
# Crear usuario admin
docker exec -it educacionit-metastore-1 psql -U postgres -c "CREATE USER admin WITH PASSWORD 'admin123';"
```

### **Error: "database educacionit does not exist"**
```bash
# Crear base de datos
docker exec -it educacionit-metastore-1 psql -U postgres -c "CREATE DATABASE educacionit;"
```

### **Error: "permission denied"**
```bash
# Otorgar permisos
docker exec -it educacionit-metastore-1 psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE educacionit TO admin;"
```

### **Error: "duplicate key value violates unique constraint"**
```bash
# Las tablas ya tienen datos, esto es normal
# Puedes verificar con: SELECT COUNT(*) FROM nombre_tabla;
```

### **Error: "file not found" en COPY**
```bash
# Verificar que los archivos estén en el contenedor
docker exec -it educacionit-metastore-1 ls -la /tmp/etapa1/

# Si no están, copiarlos de nuevo
docker cp data/etapa1/. educacionit-metastore-1:/tmp/etapa1/
```

---

## 📚 **Comandos Útiles**

### **Conectarse a la Base de Datos**
```bash
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit
```

### **Ver Todas las Tablas**
```sql
\dt
```

### **Ver Estructura de una Tabla**
```sql
\d nombre_tabla
```

### **Ejecutar Consulta SQL**
```sql
SELECT COUNT(*) FROM clientes;
```

### **Salir de psql**
```sql
\q
```

---

## 🎯 **Checklist de Verificación**

### **✅ Entorno:**
- [ ] Docker funcionando
- [ ] Repositorio clonado
- [ ] Archivos CSV disponibles

### **✅ PostgreSQL:**
- [ ] Contenedor corriendo
- [ ] Puerto 5432 accesible
- [ ] Base de datos `educacionit` creada
- [ ] Usuario `admin` creado con permisos

### **✅ Tablas:**
- [ ] 10 tablas creadas
- [ ] Estructura correcta
- [ ] Datos cargados

### **✅ Datos:**
- [ ] Clientes: ~3,407 registros
- [ ] Sucursales: ~31 registros
- [ ] Productos: ~291 registros
- [ ] Ventas: ~16,468 registros
- [ ] Y todas las demás tablas con datos

### **✅ Conexión:**
- [ ] DBeaver conecta correctamente
- [ ] Consultas SQL funcionan
- [ ] Datos accesibles

---

## 🎉 **¡Listo!**

Tu base de datos PostgreSQL está completamente configurada con:

- ✅ **10 tablas** creadas con estructura correcta
- ✅ **~42,000+ registros** de datos de ejemplo
- ✅ **Usuario `admin`** con acceso completo
- ✅ **Conexión disponible** en puerto 5432
- ✅ **Datos reales** para practicar SQL

**¡Puedes empezar a usar SQL y analizar los datos del curso!**

---

## 📞 **Soporte Adicional**

### **Guías relacionadas:**
- 🔌 **`GUIA_DBEAVER_POSTGRESQL_WINDOWS.md`** - Conexión con DBeaver
- 📊 **`GUIA_SQL.md`** - Sintaxis básica de SQL
- 🏗️ **`EJEMPLOS_NORMALIZACION.md`** - Teoría de normalización

### **Si nada funciona:**
1. **Revisar logs:** `docker logs educacionit-metastore-1`
2. **Reiniciar:** `docker-compose restart metastore`
3. **Empezar de nuevo:** `docker-compose down && docker-compose up -d metastore`
4. **Buscar ayuda** con el instructor o en la comunidad
