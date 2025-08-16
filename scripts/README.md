# 📚 Scripts para Base de Datos PostgreSQL

Esta carpeta contiene todos los scripts necesarios para configurar y cargar datos en la base de datos PostgreSQL del clúster Hadoop-Hive-Spark.

## 🗂️ Archivos Disponibles

### **Scripts SQL:**
- **`create_tables.sql`** - Crea todas las tablas de la base de datos
- **`load_data_fixed.sql`** - Carga todos los datos desde los archivos CSV (script corregido)

### **Scripts Bash:**
- **`setup_complete.sh`** - Script principal que ejecuta todo el proceso (obsoleto)
- **`load_data.sh`** - Script alternativo solo para cargar datos (obsoleto)

## 🚀 Uso de los Scripts

### **⚠️ IMPORTANTE:**
Los scripts bash están obsoletos. Para configurar la base de datos, sigue la **`GUIA_INSTALACION_POSTGRESQL.md`**.

### **Scripts SQL Disponibles:**
- **`create_tables.sql`** - Crear todas las tablas
- **`load_data_fixed.sql`** - Cargar todos los datos (script corregido)

### **Proceso Manual Recomendado:**
```bash
# 1. Copiar archivos CSV
docker cp data/etapa1/. educacionit-metastore-1:/tmp/etapa1/

# 2. Crear tablas
docker cp scripts/create_tables.sql educacionit-metastore-1:/tmp/
docker exec -it educacionit-metastore-1 psql -U postgres -d educacionit -f /tmp/create_tables.sql

# 3. Cargar datos
docker cp scripts/load_data_fixed.sql educacionit-metastore-1:/tmp/
docker exec -it educacionit-metastore-1 psql -U postgres -d educacionit -f /tmp/load_data_fixed.sql
```

## 📊 Estructura de la Base de Datos

### **Tablas Creadas:**
1. **`canal_venta`** - Canales de venta (Telefónica, OnLine, Presencial)
2. **`productos`** - Catálogo de productos con precios
3. **`proveedores`** - Información de proveedores
4. **`sucursales`** - Ubicaciones de sucursales
5. **`empleados`** - Personal de la empresa
6. **`clientes`** - Base de clientes
7. **`tipos_gasto`** - Categorías de gastos
8. **`gastos`** - Registro de gastos por sucursal
9. **`compras`** - Historial de compras
10. **`ventas`** - Historial de ventas

### **Relaciones:**
- **`ventas`** → `clientes`, `sucursales`, `productos`
- **`gastos`** → `sucursales`, `tipos_gasto`
- **`compras`** → `productos`, `proveedores`

## 🔧 Requisitos Previos

### **1. Contenedor PostgreSQL corriendo**
```bash
# Verificar que esté corriendo
docker ps | grep metastore

# Si no está corriendo, levantar el servicio
docker-compose up -d metastore
```

### **2. Base de datos creada**
```bash
# Conectarse a PostgreSQL
docker exec -it educacionit-metastore-1 psql -U postgres -d metastore

# Verificar que la base existe
\l
```

### **3. Archivos CSV disponibles**
Los archivos deben estar en `data/etapa1/`:
- `CanalDeVenta.csv`
- `PRODUCTOS.csv`
- `Proveedores.csv`
- `Sucursales.csv`
- `Empleados.csv`
- `Clientes.csv`
- `TiposDeGasto.csv`
- `Gasto.csv`
- `Compra.csv`
- `Venta.csv`

## 📋 Proceso de Carga

### **Orden de Carga:**
1. **Tablas sin dependencias** (se crean primero):
   - `canal_venta`
   - `productos`
   - `proveedores`
   - `sucursales`
   - `empleados`
   - `clientes`
   - `tipos_gasto`

2. **Tablas con dependencias** (se cargan después):
   - `gastos`
   - `compras`
   - `ventas`

### **Tiempo Estimado:**
- **Creación de tablas**: 1-2 minutos
- **Carga de datos**: 5-10 minutos
- **Total**: 6-12 minutos

## 🆘 Solución de Problemas

### **Error: Contenedor no encontrado**
```bash
# Verificar estado de servicios
docker-compose ps

# Levantar servicio de PostgreSQL
docker-compose up -d metastore
```

### **Error: Base de datos no existe**
```bash
# Conectarse a PostgreSQL
docker exec -it educacionit-metastore-1 psql -U postgres -d postgres

# Crear base de datos
CREATE DATABASE metastore;
```

### **Error: Permisos denegados**
```bash
# Dar permisos de ejecución
chmod +x scripts/*.sh
```

### **Error: Archivos CSV no encontrados**
```bash
# Verificar que los archivos estén en data/etapa1/
ls -la data/etapa1/
```

## 📈 Verificación de Datos

### **Comando de Verificación:**
```bash
# Verificar cantidad de registros manualmente
docker exec -it educacionit-metastore-1 psql -U postgres -d educacionit -c "
SELECT 
    'clientes' as tabla, COUNT(*) as registros FROM clientes
UNION ALL
SELECT 'sucursales', COUNT(*) FROM sucursales
UNION ALL
SELECT 'productos', COUNT(*) FROM productos
UNION ALL
SELECT 'ventas', COUNT(*) FROM ventas
ORDER BY tabla;"
```

### **Verificación Manual:**
```bash
# Conectarse a PostgreSQL
docker exec -it educacionit-metastore-1 psql -U postgres -d metastore

# Ver tablas
\dt

# Contar registros en una tabla
SELECT COUNT(*) FROM clientes;
```

## 🎯 Casos de Uso

### **Primera Vez:**
```bash
# Seguir GUIA_INSTALACION_POSTGRESQL.md desde el paso 1
```

### **Actualizar Datos:**
```bash
# Usar load_data_fixed.sql
docker cp scripts/load_data_fixed.sql educacionit-metastore-1:/tmp/
docker exec -it educacionit-metastore-1 psql -U postgres -d educacionit -f /tmp/load_data_fixed.sql
```

### **Solo Verificar:**
```bash
# Usar el comando de verificación anterior
```

### **Recrear Estructura:**
```bash
# Usar create_tables.sql
docker cp scripts/create_tables.sql educacionit-metastore-1:/tmp/
docker exec -it educacionit-metastore-1 psql -U postgres -d educacionit -f /tmp/create_tables.sql
```

## 📝 Notas Importantes

- **⚠️ Scripts Bash Obsoletos**: Los scripts `.sh` ya no funcionan
- **Guía Recomendada**: Usa `GUIA_INSTALACION_POSTGRESQL.md`
- **Dependencias**: Las tablas se crean en el orden correcto
- **Verificación**: Siempre verifica que los datos se cargaron correctamente
- **Logs**: Revisa los mensajes de error si algo falla

## 🎉 ¡Listo para Usar!

Una vez que el script se ejecute exitosamente, tendrás:
- ✅ Base de datos completamente configurada
- ✅ Todas las tablas creadas con índices
- ✅ Todos los datos cargados desde los CSV
- ✅ Base de datos lista para consultas y análisis

**¡Tu base de datos está lista para el análisis de datos!**
