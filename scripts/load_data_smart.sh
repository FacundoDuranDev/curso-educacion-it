#!/bin/bash

# Script inteligente para cargar datos en PostgreSQL
# Copia los archivos CSV al contenedor y usa rutas relativas
# Base de datos: educacionit
# Usuario: jupyter
# Contenedor: hadoop-hive-spark-docker-metastore-1

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuración
DB_NAME="metastore"
DB_USER="jupyter"
CONTAINER_NAME="hadoop-hive-spark-docker-metastore-1"
CSV_SOURCE_DIR="data/etapa1"
CSV_CONTAINER_DIR="/tmp/csv_data"

echo -e "${BLUE}🚀 Iniciando carga inteligente de datos en PostgreSQL...${NC}"
echo "=================================================="

# Función para verificar que el contenedor esté corriendo
check_container() {
    if ! docker ps | grep -q "$CONTAINER_NAME"; then
        echo -e "${RED}❌ Error: El contenedor $CONTAINER_NAME no está corriendo${NC}"
        echo "Ejecuta: docker-compose up -d metastore"
        exit 1
    fi
    echo -e "${GREEN}✅ Contenedor PostgreSQL encontrado${NC}"
}

# Función para verificar que la base de datos existe
check_database() {
    echo -e "${YELLOW}🔍 Verificando base de datos...${NC}"
    if docker exec "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME" -c "\l" | grep -q "$DB_NAME"; then
        echo -e "${GREEN}✅ Base de datos $DB_NAME encontrada${NC}"
    else
        echo -e "${RED}❌ Error: Base de datos $DB_NAME no existe${NC}"
        exit 1
    fi
}

# Función para copiar archivos CSV al contenedor
copy_csv_to_container() {
    echo -e "${YELLOW}📁 Copiando archivos CSV al contenedor...${NC}"
    
    # Crear directorio temporal en el contenedor
    docker exec "$CONTAINER_NAME" mkdir -p "$CSV_CONTAINER_DIR"
    
    # Copiar todos los archivos CSV
    for csv_file in "$CSV_SOURCE_DIR"/*.csv; do
        if [ -f "$csv_file" ]; then
            filename=$(basename "$csv_file")
            echo "  📋 Copiando $filename..."
            docker cp "$csv_file" "$CONTAINER_NAME:$CSV_CONTAINER_DIR/"
        fi
    done
    
    echo -e "${GREEN}✅ Archivos CSV copiados al contenedor${NC}"
}

# Función para crear script SQL con rutas del contenedor
create_container_sql() {
    echo -e "${YELLOW}📝 Creando script SQL para el contenedor...${NC}"
    
    cat > /tmp/load_data_container.sql << 'EOF'
-- Script para cargar datos en PostgreSQL usando \copy
-- Base de datos: educacionit
-- Archivos ubicados en /tmp/csv_data/ dentro del contenedor

-- 1. Cargar datos de Clientes
\copy clientes FROM '/tmp/csv_data/Clientes.csv' WITH (FORMAT csv, DELIMITER ';', HEADER true, ENCODING 'UTF8');

-- 2. Cargar datos de Sucursales
\copy sucursales FROM '/tmp/csv_data/Sucursales.csv' WITH (FORMAT csv, DELIMITER ';', HEADER true, ENCODING 'UTF8');

-- 3. Cargar datos de Tipos de Gasto
\copy tipos_gasto FROM '/tmp/csv_data/TiposDeGasto.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');

-- 4. Cargar datos de Gastos
\copy gastos FROM '/tmp/csv_data/Gasto.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');

-- 5. Cargar datos de Compras
\copy compras FROM '/tmp/csv_data/Compra.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');

-- 6. Cargar datos de Productos
\copy productos FROM '/tmp/csv_data/PRODUCTOS.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');

-- 7. Cargar datos de Proveedores
\copy proveedores FROM '/tmp/csv_data/Proveedores.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');

-- 8. Cargar datos de Empleados (usando tabla temporal para evitar duplicados)
CREATE TEMP TABLE temp_empleados (
    id_empleado INTEGER,
    apellido VARCHAR(100),
    nombre VARCHAR(100),
    sucursal VARCHAR(100),
    sector VARCHAR(100),
    cargo VARCHAR(100),
    salario DECIMAL(10,2)
);

\copy temp_empleados FROM '/tmp/csv_data/Empleados.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');

INSERT INTO empleados (id_empleado, apellido, nombre, sucursal, sector, cargo, salario)
SELECT DISTINCT id_empleado, apellido, nombre, sucursal, sector, cargo, salario
FROM temp_empleados
ON CONFLICT (id_empleado) DO NOTHING;

-- 9. Cargar datos de Canal de Venta
\copy canal_venta FROM '/tmp/csv_data/CanalDeVenta.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');

-- 10. Cargar datos de Ventas
\copy ventas FROM '/tmp/csv_data/Venta.csv' WITH (FORMAT csv, DELIMITER ',', HEADER true, ENCODING 'UTF8');
EOF

    echo -e "${GREEN}✅ Script SQL creado${NC}"
}

# Función para ejecutar la carga de datos
load_data() {
    echo -e "${YELLOW}📊 Ejecutando carga de datos...${NC}"
    
    # Copiar script SQL al contenedor
    docker cp /tmp/load_data_container.sql "$CONTAINER_NAME:/tmp/"
    
    # Ejecutar el script
    docker exec -i "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME" < /tmp/load_data_container.sql
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Datos cargados exitosamente${NC}"
    else
        echo -e "${RED}❌ Error al cargar los datos${NC}"
        exit 1
    fi
}

# Función para limpiar archivos temporales
cleanup() {
    echo -e "${YELLOW}🧹 Limpiando archivos temporales...${NC}"
    
    # Eliminar archivos del contenedor
    docker exec "$CONTAINER_NAME" rm -rf "$CSV_CONTAINER_DIR"
    docker exec "$CONTAINER_NAME" rm -f /tmp/load_data_container.sql
    
    # Eliminar archivo temporal local
    rm -f /tmp/load_data_container.sql
    
    echo -e "${GREEN}✅ Limpieza completada${NC}"
}

# Función para verificar el resultado
verify_result() {
    echo -e "${BLUE}🔍 Verificando resultado final...${NC}"
    echo "=================================================="
    
    # Mostrar resumen de datos cargados
    docker exec "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME" << EOF
        SELECT 
            'canal_venta' as tabla, COUNT(*) as registros FROM canal_venta
        UNION ALL
        SELECT 'productos', COUNT(*) FROM productos
        UNION ALL
        SELECT 'proveedores', COUNT(*) FROM proveedores
        UNION ALL
        SELECT 'sucursales', COUNT(*) FROM sucursales
        UNION ALL
        SELECT 'empleados', COUNT(*) FROM empleados
        UNION ALL
        SELECT 'clientes', COUNT(*) FROM clientes
        UNION ALL
        SELECT 'tipos_gasto', COUNT(*) FROM tipos_gasto
        UNION ALL
        SELECT 'gastos', COUNT(*) FROM gastos
        UNION ALL
        SELECT 'compras', COUNT(*) FROM compras
        UNION ALL
        SELECT 'ventas', COUNT(*) FROM ventas
        ORDER BY tabla;
EOF
}

# Función principal
main() {
    echo -e "${BLUE}🔍 Verificando entorno...${NC}"
    check_container
    check_database
    
    echo -e "${BLUE}📁 Paso 1: Copiando archivos CSV...${NC}"
    copy_csv_to_container
    
    echo -e "${BLUE}📝 Paso 2: Preparando script SQL...${NC}"
    create_container_sql
    
    echo -e "${BLUE}📊 Paso 3: Cargando datos...${NC}"
    load_data
    
    echo -e "${BLUE}🔍 Paso 4: Verificando resultado...${NC}"
    verify_result
    
    echo -e "${BLUE}🧹 Paso 5: Limpiando archivos temporales...${NC}"
    cleanup
    
    echo "=================================================="
    echo -e "${GREEN}🎉 ¡Carga de datos completada exitosamente!${NC}"
    echo -e "${BLUE}📊 Base de datos lista para usar${NC}"
}

# Ejecutar función principal
main
