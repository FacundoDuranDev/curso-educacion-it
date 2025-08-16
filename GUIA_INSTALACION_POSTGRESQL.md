# 🚀 Guía de Instalación - PostgreSQL con Base de Datos EducacionIT

## 📋 **Resumen**
Esta guía te permitirá configurar PostgreSQL con la base de datos `educacionit` completa, incluyendo todas las tablas y datos del curso de Data Engineering.

## 🎯 **Objetivo**
- ✅ Configurar PostgreSQL en Docker
- ✅ Crear base de datos `educacionit`
- ✅ Crear todas las tablas necesarias
- ✅ Cargar todos los datos de ejemplo
- ✅ Configurar usuario `admin` con acceso completo

---

## 🔧 **Prerrequisitos**
- Docker instalado y funcionando
- Git para clonar el repositorio
- Terminal/Línea de comandos

---

## 📥 **Paso 1: Clonar el Repositorio**
```bash
git clone https://github.com/FacundoDuranDev/curso-educacion-it.git
cd curso-educacion-it
```

---

## 🐳 **Paso 2: Levantar PostgreSQL**
```bash
# Levantar solo PostgreSQL
docker-compose up -d metastore

# Verificar que esté funcionando
docker ps | grep metastore
```

**Resultado esperado:**
```
educacionit-metastore-1  postgres:11  "docker-entrypoint.s…"  metastore  2 minutes ago  Up 2 minutes  0.0.0.0:5432->5432/tcp
```

---

## 🗄️ **Paso 3: Crear Base de Datos y Usuario**

### **3.1 Conectarse a PostgreSQL como superusuario**
```bash
docker exec -it educacionit-metastore-1 psql -U postgres
```

### **3.2 Crear base de datos `educacionit`**
```sql
CREATE DATABASE educacionit;
```

### **3.3 Crear usuario `admin`**
```sql
CREATE USER admin WITH PASSWORD 'admin123';
```

### **3.4 Otorgar permisos**
```sql
GRANT ALL PRIVILEGES ON DATABASE educacionit TO admin;
```

### **3.5 Salir de psql**
```sql
\q
```

---

## 🏗️ **Paso 4: Crear Tablas**

### **4.1 Copiar archivos CSV al contenedor**
```bash
docker cp data/etapa1/. educacionit-metastore-1:/tmp/etapa1/
```

### **4.2 Crear todas las tablas**
```bash
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

### **4.3 Verificar tablas creadas**
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

### **5.2 Cargar Sucursales**
```bash
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy sucursales FROM '/tmp/etapa1/Sucursales.csv' WITH (FORMAT csv, DELIMITER ';', HEADER true, ENCODING 'UTF8');"
```

### **5.3 Cargar Tipos de Gasto**
```bash
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy tipos_gasto FROM '/tmp/etapa1/TiposDeGasto.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"
```

### **5.4 Cargar Gastos**
```bash
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy gastos FROM '/tmp/etapa1/Gasto.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"
```

### **5.5 Cargar Compras**
```bash
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy compras FROM '/tmp/etapa1/Compra.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"
```

### **5.6 Cargar Productos**
```bash
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy productos FROM '/tmp/etapa1/PRODUCTOS.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"
```

### **5.7 Cargar Proveedores**
```bash
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy proveedores FROM '/tmp/etapa1/Proveedores.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"
```

### **5.8 Cargar Empleados**
```bash
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy empleados FROM '/tmp/etapa1/Empleados.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"
```

### **5.9 Cargar Canal de Venta**
```bash
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy canal_venta FROM '/tmp/etapa1/CanalDeVenta.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"
```

### **5.10 Cargar Ventas**
```bash
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "\copy ventas FROM '/tmp/etapa1/Venta.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');"
```

---

## ✅ **Paso 6: Verificar Instalación**

### **6.1 Verificar conteo de registros**
```bash
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "
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
ORDER BY tabla;"
```

**Resultado esperado:**
```
   tabla    | registros 
------------+-----------
 clientes   |      3407
 empleados  |       268
 productos  |       292
 sucursales |        31
 ventas     |     16468
```

---

## 🔌 **Paso 7: Conectar con DBeaver**

### **7.1 Configuración de conexión**
- **Host:** `localhost`
- **Puerto:** `5432`
- **Base de datos:** `educacionit`
- **Usuario:** `admin`
- **Contraseña:** `admin123`

### **7.2 Probar conexión**
```bash
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit -c "SELECT 'Conexión exitosa!' as mensaje;"
```

---

## 🚀 **Comando Rápido (Todo en Uno)**

Si quieres hacer todo de una vez, puedes usar este script:

```bash
#!/bin/bash
echo "🚀 Configurando PostgreSQL completo..."

# 1. Levantar PostgreSQL
docker-compose up -d metastore
sleep 10

# 2. Crear base de datos y usuario
docker exec -it educacionit-metastore-1 psql -U postgres -c "CREATE DATABASE educacionit;" 2>/dev/null || true
docker exec -it educacionit-metastore-1 psql -U postgres -c "CREATE USER admin WITH PASSWORD 'admin123';" 2>/dev/null || true
docker exec -it educacionit-metastore-1 psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE educacionit TO admin;" 2>/dev/null || true

# 3. Copiar archivos CSV
docker cp data/etapa1/. educacionit-metastore-1:/tmp/etapa1/

# 4. Crear tablas
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

echo "✅ ¡PostgreSQL configurado completamente!"
echo "📊 Base de datos: educacionit"
echo "👤 Usuario: admin"
echo "🔑 Contraseña: admin123"
echo "🔌 Puerto: 5432"
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

### **Error: "file not found" en COPY**
```bash
# Verificar que los archivos estén en el contenedor
docker exec -it educacionit-metastore-1 ls -la /tmp/etapa1/
```

---

## 📚 **Comandos Útiles**

### **Conectarse a la base de datos**
```bash
docker exec -it educacionit-metastore-1 psql -U admin -d educacionit
```

### **Ver todas las tablas**
```sql
\dt
```

### **Ver estructura de una tabla**
```sql
\d nombre_tabla
```

### **Ejecutar consulta SQL**
```sql
SELECT COUNT(*) FROM clientes;
```

### **Salir de psql**
```sql
\q
```

---

## 🎉 **¡Listo!**

Tu base de datos PostgreSQL está completamente configurada con:
- ✅ 10 tablas creadas
- ✅ Datos de ejemplo cargados
- ✅ Usuario `admin` con acceso completo
- ✅ Conexión disponible en puerto 5432

**¡Puedes empezar a usar SQL y analizar los datos!**
