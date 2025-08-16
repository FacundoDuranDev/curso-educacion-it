#!/bin/bash

# Script para cargar datos en PostgreSQL usando el archivo SQL
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
SQL_FILE="load_data_sql.sql"

echo -e "${BLUE}🚀 Iniciando carga de datos en PostgreSQL...${NC}"
echo "=================================================="

# Verificar que el contenedor esté corriendo
if ! docker ps | grep -q "$CONTAINER_NAME"; then
    echo -e "${RED}❌ Error: El contenedor $CONTAINER_NAME no está corriendo${NC}"
    echo "Ejecuta: docker-compose up -d metastore"
    exit 1
fi

echo -e "${GREEN}✅ Contenedor PostgreSQL encontrado${NC}"

# Verificar que el archivo SQL existe
if [ ! -f "$SQL_FILE" ]; then
    echo -e "${RED}❌ Error: Archivo $SQL_FILE no encontrado${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Archivo SQL encontrado${NC}"

# Verificar que la base de datos existe
if ! docker exec "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME" -c "\l" | grep -q "$DB_NAME"; then
    echo -e "${RED}❌ Error: Base de datos $DB_NAME no existe${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Base de datos $DB_NAME encontrada${NC}"

# Ejecutar el script SQL
echo -e "${YELLOW}📊 Ejecutando script SQL para cargar datos...${NC}"
echo "=================================================="

docker exec -i "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME" < "$SQL_FILE"

if [ $? -eq 0 ]; then
    echo "=================================================="
    echo -e "${GREEN}🎉 ¡Carga de datos completada!${NC}"
    echo -e "${BLUE}📊 Verifica la cantidad de registros arriba${NC}"
    
    # Mostrar resumen de datos cargados
    echo -e "${BLUE}📋 Resumen de datos cargados:${NC}"
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
else
    echo -e "${RED}❌ Error al ejecutar el script SQL${NC}"
    exit 1
fi
