# 📚 Scripts para Base de Datos PostgreSQL

Esta carpeta contiene todos los scripts necesarios para configurar y cargar datos en la base de datos PostgreSQL del clúster Hadoop-Hive-Spark.

## 🗂️ Archivos Disponibles

### **Scripts SQL:**
- **`create_tables.sql`** - Crea todas las tablas de la base de datos
- **`load_data_sql.sql`** - Carga todos los datos desde los archivos CSV

### **Scripts Bash:**
- **`setup_database.sh`** - Script principal que ejecuta todo el proceso
- **`load_data.sh`** - Script alternativo solo para cargar datos

## 🚀 Uso del Script Principal

### **Configuración Completa (Recomendado)**
```bash
# Desde la carpeta scripts/
./setup_database.sh
```

**¿Qué hace?**
1. ✅ Verifica que PostgreSQL esté corriendo
2. ✅ Crea todas las tablas con índices
3. ✅ Carga todos los datos desde los CSV
4. ✅ Verifica que todo esté funcionando

### **Opciones Disponibles**

```bash
# Mostrar ayuda
./setup_database.sh --help

# Limpiar y configurar desde cero
./setup_database.sh --clean

# Solo crear tablas (sin cargar datos)
./setup_database.sh --tables

# Solo cargar datos (asumiendo tablas existentes)
./setup_database.sh --data

# Solo verificar datos existentes
./setup_database.sh --verify
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
docker exec -it hadoop-hive-spark-docker-metastore-1 psql -U jupyter -d metastore

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
docker exec -it hadoop-hive-spark-docker-metastore-1 psql -U jupyter -d postgres

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
# Verificar cantidad de registros
./setup_database.sh --verify
```

### **Verificación Manual:**
```bash
# Conectarse a PostgreSQL
docker exec -it hadoop-hive-spark-docker-metastore-1 psql -U jupyter -d metastore

# Ver tablas
\dt

# Contar registros en una tabla
SELECT COUNT(*) FROM clientes;
```

## 🎯 Casos de Uso

### **Primera Vez:**
```bash
./setup_database.sh --clean
```

### **Actualizar Datos:**
```bash
./setup_database.sh --data
```

### **Solo Verificar:**
```bash
./setup_database.sh --verify
```

### **Recrear Estructura:**
```bash
./setup_database.sh --tables
```

## 📝 Notas Importantes

- **Backup**: Siempre haz backup antes de usar `--clean`
- **Permisos**: Los scripts necesitan permisos de ejecución
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
