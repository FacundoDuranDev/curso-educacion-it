# Guía de Apache Hive y Ejercicios Prácticos

## ¿Qué es Apache Hive?

Apache Hive es un sistema de almacenamiento de datos (data warehouse) construido sobre Apache Hadoop. Permite:
- Realizar consultas y análisis de datos usando HQL (similar a SQL)
- Procesar grandes volúmenes de datos estructurados
- Integración con herramientas de BI y visualización

## Configuración con Docker

```yaml
version: '3'
services:
  hive-server:
    image: apache/hive:3.1.3
    container_name: hive-server
    ports:
      - "10000:10000"  # HiveServer2
      - "10002:10002"  # HiveServer2 Web UI
    environment:
      - HIVE_CORE_CONF_javax_jdo_option_ConnectionURL=jdbc:postgresql://postgres-metastore:5432/metastore
      - HIVE_CORE_CONF_javax_jdo_option_ConnectionDriverName=org.postgresql.Driver
      - HIVE_CORE_CONF_javax_jdo_option_ConnectionUserName=hive
      - HIVE_CORE_CONF_javax_jdo_option_ConnectionPassword=hive
    depends_on:
      - postgres-metastore
      - namenode

  postgres-metastore:
    image: postgres:13
    container_name: postgres-metastore
    ports:
      - "5432:5432"
    environment:
      - POSTGRES_DB=metastore
      - POSTGRES_USER=hive
      - POSTGRES_PASSWORD=hive
    volumes:
      - postgres-metastore-data:/var/lib/postgresql/data

volumes:
  postgres-metastore-data:
```

## Comandos Básicos de Hive

### Conexión a Hive
```bash
# Conectar al CLI de Hive
beeline -u jdbc:hive2://localhost:10000

# O usando el Hive CLI directamente
hive
```

### Operaciones con Bases de Datos
```sql
-- Crear base de datos
CREATE DATABASE retail;
USE retail;

-- Listar bases de datos
SHOW DATABASES;

-- Ver tablas en la base de datos actual
SHOW TABLES;
```

### Creación de Tablas
```sql
-- Ejemplo de creación de tabla
CREATE TABLE clientes (
    id INT,
    nombre STRING,
    email STRING,
    fecha_registro DATE
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- Crear tabla particionada
CREATE TABLE ventas (
    id_venta INT,
    monto DECIMAL(10,2),
    id_cliente INT
)
PARTITIONED BY (fecha DATE)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',';
```

### Carga de Datos
```sql
-- Cargar datos desde archivo CSV
LOAD DATA LOCAL INPATH '/path/to/clientes.csv' 
INTO TABLE clientes;

-- Cargar datos en tabla particionada
LOAD DATA LOCAL INPATH '/path/to/ventas.csv'
INTO TABLE ventas
PARTITION (fecha='2023-01-01');
```

## Ejercicio Práctico: Carga de Datos de Retail

### 1. Crear las Tablas

```sql
-- Tabla de Clientes
CREATE TABLE clientes (
    id_cliente INT,
    nombre STRING,
    email STRING,
    telefono STRING,
    direccion STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- Tabla de Productos
CREATE TABLE productos (
    id_producto INT,
    nombre STRING,
    precio DECIMAL(10,2),
    categoria STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- Tabla de Ventas
CREATE TABLE ventas (
    id_venta INT,
    id_cliente INT,
    id_producto INT,
    cantidad INT,
    monto_total DECIMAL(10,2),
    fecha_venta DATE
)
PARTITIONED BY (anio INT, mes INT)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',';
```

### 2. Cargar los Datos

```sql
-- Habilitar carga de datos local
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;

-- Cargar datos de clientes
LOAD DATA LOCAL INPATH '/data/Clientes.csv' 
OVERWRITE INTO TABLE clientes;

-- Cargar datos de productos
LOAD DATA LOCAL INPATH '/data/PRODUCTOS.csv' 
OVERWRITE INTO TABLE productos;

-- Cargar datos de ventas (requiere preprocesamiento para particiones)
LOAD DATA LOCAL INPATH '/data/Venta.csv' 
INTO TABLE ventas
PARTITION (anio=2023, mes=1);
```

## Diferencias entre Hive y PostgreSQL

### Arquitectura
- **PostgreSQL**: Base de datos relacional tradicional, optimizada para OLTP
- **Hive**: Data warehouse distribuido sobre Hadoop, optimizado para OLAP

### Casos de Uso
- **PostgreSQL**:
  - Transacciones en tiempo real
  - Aplicaciones web
  - Datos estructurados de tamaño moderado
  
- **Hive**:
  - Análisis de grandes volúmenes de datos
  - Procesamiento por lotes
  - Data warehouse empresarial

### Rendimiento
- **PostgreSQL**:
  - Mejor para consultas puntuales
  - Excelente para actualizaciones frecuentes
  - Índices optimizados
  
- **Hive**:
  - Mejor para análisis de grandes conjuntos
  - Procesamiento paralelo
  - Mayor latencia en consultas individuales

### Escalabilidad
- **PostgreSQL**: Escalamiento vertical principalmente
- **Hive**: Escalamiento horizontal nativo

## Conexión desde DBeaver

### PostgreSQL
1. Crear nueva conexión
2. Seleccionar PostgreSQL
3. Configurar:
   - Host: localhost
   - Puerto: 5432
   - Base de datos: retail
   - Usuario/Contraseña

### Hive
1. Crear nueva conexión
2. Seleccionar Apache Hive
3. Configurar:
   - Host: localhost
   - Puerto: 10000
   - Base de datos: retail
   - URL JDBC: jdbc:hive2://localhost:10000

## Buenas Prácticas

1. **Particionamiento**
   - Usar particiones en tablas grandes
   - Elegir columnas de partición según patrones de consulta

2. **Optimización**
   - Usar formatos columnar (ORC, Parquet) para mejor rendimiento
   - Configurar recursos según necesidades

3. **Mantenimiento**
   - Realizar análisis de estadísticas regularmente
   - Monitorear el espacio y rendimiento

## Referencias
- [Documentación oficial de Apache Hive](https://hive.apache.org/)
- [Guía de optimización de Hive](https://cwiki.apache.org/confluence/display/Hive/LanguageManual+Optimization)
- [Tutoriales de Hive](https://cwiki.apache.org/confluence/display/Hive/Tutorial)