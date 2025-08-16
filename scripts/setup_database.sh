#!/bin/bash

# Script principal para configurar la base de datos completa
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
CREATE_TABLES_FILE="create_tables.sql"
LOAD_DATA_FILE="load_data_sql.sql"

echo -e "${BLUE}🚀 Configurando base de datos completa...${NC}"
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

# Función para crear las tablas
create_tables() {
    echo -e "${YELLOW}🏗️  Creando tablas...${NC}"
    
    if [ ! -f "$CREATE_TABLES_FILE" ]; then
        echo -e "${RED}❌ Error: Archivo $CREATE_TABLES_FILE no encontrado${NC}"
        exit 1
    fi
    
    docker exec -i "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME" < "$CREATE_TABLES_FILE"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Tablas creadas exitosamente${NC}"
    else
        echo -e "${RED}❌ Error al crear las tablas${NC}"
        exit 1
    fi
}

# Función para cargar los datos
load_data() {
    echo -e "${YELLOW}📊 Cargando datos...${NC}"
    
    if [ ! -f "$LOAD_DATA_FILE" ]; then
        echo -e "${RED}❌ Error: Archivo $LOAD_DATA_FILE no encontrado${NC}"
        exit 1
    fi
    
    docker exec -i "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME" < "$LOAD_DATA_FILE"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Datos cargados exitosamente${NC}"
    else
        echo -e "${RED}❌ Error al cargar los datos${NC}"
        exit 1
    fi
}

# Función para verificar el resultado final
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

# Función para limpiar tablas existentes
clean_tables() {
    echo -e "${YELLOW}🧹 Limpiando tablas existentes...${NC}"
    
    docker exec "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME" << EOF
        DROP TABLE IF EXISTS ventas CASCADE;
        DROP TABLE IF EXISTS compras CASCADE;
        DROP TABLE IF EXISTS gastos CASCADE;
        DROP TABLE IF EXISTS clientes CASCADE;
        DROP TABLE IF EXISTS empleados CASCADE;
        DROP TABLE IF EXISTS sucursales CASCADE;
        DROP TABLE IF EXISTS productos CASCADE;
        DROP TABLE IF EXISTS proveedores CASCADE;
        DROP TABLE IF EXISTS tipos_gasto CASCADE;
        DROP TABLE IF EXISTS canal_venta CASCADE;
EOF
    
    echo -e "${GREEN}✅ Tablas limpiadas exitosamente${NC}"
}

# Función para mostrar ayuda
show_help() {
    echo "Uso: $0 [OPCIONES]"
    echo ""
    echo "Opciones:"
    echo "  -h, --help     Mostrar esta ayuda"
    echo "  -c, --clean    Limpiar tablas existentes antes de crear"
    echo "  -v, --verify   Solo verificar datos (no crear/cargar)"
    echo "  -t, --tables   Solo crear tablas (no cargar datos)"
    echo "  -d, --data     Solo cargar datos (asumiendo tablas existentes)"
    echo ""
    echo "Ejemplos:"
    echo "  $0              # Configuración completa"
    echo "  $0 --clean      # Limpiar y configurar desde cero"
    echo "  $0 --verify     # Solo verificar datos existentes"
    echo "  $0 --tables     # Solo crear tablas"
    echo "  $0 --data       # Solo cargar datos"
}

# Función para solo verificar
verify_only() {
    echo -e "${BLUE}🔍 Verificando datos existentes...${NC}"
    check_container
    check_database
    verify_result
}

# Función para solo crear tablas
tables_only() {
    echo -e "${BLUE}🏗️  Solo creando tablas...${NC}"
    check_container
    check_database
    create_tables
    echo -e "${GREEN}✅ Tablas creadas. Para cargar datos ejecuta: $0 --data${NC}"
}

# Función para solo cargar datos
data_only() {
    echo -e "${BLUE}📊 Solo cargando datos...${NC}"
    check_container
    check_database
    load_data
    verify_result
}

# Función principal
main() {
    echo -e "${BLUE}🔍 Verificando entorno...${NC}"
    check_container
    check_database
    
    echo -e "${BLUE}🏗️  Paso 1: Creando tablas...${NC}"
    create_tables
    
    echo -e "${BLUE}📊 Paso 2: Cargando datos...${NC}"
    load_data
    
    echo -e "${BLUE}🔍 Paso 3: Verificando resultado...${NC}"
    verify_result
    
    echo "=================================================="
    echo -e "${GREEN}🎉 ¡Configuración de base de datos completada!${NC}"
    echo -e "${BLUE}📊 Base de datos lista para usar${NC}"
}

# Procesar argumentos de línea de comandos
case "$1" in
    -h|--help)
        show_help
        exit 0
        ;;
    -c|--clean)
        check_container
        check_database
        clean_tables
        main
        exit 0
        ;;
    -v|--verify)
        verify_only
        exit 0
        ;;
    -t|--tables)
        tables_only
        exit 0
        ;;
    -d|--data)
        data_only
        exit 0
        ;;
    "")
        main
        exit 0
        ;;
    *)
        echo -e "${RED}❌ Opción desconocida: $1${NC}"
        show_help
        exit 1
        ;;
esac
