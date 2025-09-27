#!/bin/bash

# 🚀 SCRIPT EJECUTOR DE TUTORIALES SPARK
# ======================================
# 
# 🎯 OBJETIVO: Ejecutar tutoriales de Spark de forma fácil y organizada
# 
# 📋 USO:
#   ./ejecutar_tutoriales.sh [tutorial] [opciones]
#
# 📚 TUTORIALES DISPONIBLES:
#   - basics     : Tutorial básico de Spark
#   - dataframes : Tutorial de DataFrames avanzados
#   - sql        : Tutorial de Spark SQL
#   - all        : Ejecutar todos los tutoriales
#
# ⚡ EJEMPLOS:
#   ./ejecutar_tutoriales.sh basics
#   ./ejecutar_tutoriales.sh all
#   ./ejecutar_tutoriales.sh sql --jupyter

set -e  # Salir si hay error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Función para mostrar banner
show_banner() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    🚀 SPARK TUTORIALS                       ║"
    echo "║                                                              ║"
    echo "║  🎯 Aprendizaje práctico de Apache Spark                     ║"
    echo "║  📚 Desde lo básico hasta conceptos avanzados                ║"
    echo "║                                                              ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Función para mostrar ayuda
show_help() {
    echo -e "${CYAN}📋 USO DEL SCRIPT:${NC}"
    echo ""
    echo "  ./ejecutar_tutoriales.sh [tutorial] [opciones]"
    echo ""
    echo -e "${YELLOW}📚 TUTORIALES DISPONIBLES:${NC}"
    echo "  ${GREEN}basics${NC}     - Tutorial básico de Spark (01-basics)"
    echo "  ${GREEN}dataframes${NC} - Tutorial de DataFrames avanzados (02-dataframes)"
    echo "  ${GREEN}sql${NC}        - Tutorial de Spark SQL (03-sql)"
    echo "  ${GREEN}all${NC}        - Ejecutar todos los tutoriales"
    echo ""
    echo -e "${YELLOW}⚡ OPCIONES:${NC}"
    echo "  ${GREEN}--jupyter${NC}  - Ejecutar en Jupyter (abre navegador)"
    echo "  ${GREEN}--help${NC}     - Mostrar esta ayuda"
    echo ""
    echo -e "${YELLOW}🎯 EJEMPLOS:${NC}"
    echo "  ./ejecutar_tutoriales.sh basics"
    echo "  ./ejecutar_tutoriales.sh dataframes --jupyter"
    echo "  ./ejecutar_tutoriales.sh all"
    echo ""
}

# Función para verificar prerrequisitos
check_prerequisites() {
    echo -e "${BLUE}🔍 Verificando prerrequisitos...${NC}"
    
    # Verificar que estamos en el directorio correcto
    if [ ! -f "spark-tutorials/README.md" ]; then
        echo -e "${RED}❌ Error: No se encontró spark-tutorials/README.md${NC}"
        echo -e "${YELLOW}💡 Asegúrate de ejecutar este script desde el directorio raíz del proyecto${NC}"
        exit 1
    fi
    
    # Verificar que Docker esté corriendo
    if ! docker ps > /dev/null 2>&1; then
        echo -e "${RED}❌ Error: Docker no está corriendo${NC}"
        echo -e "${YELLOW}💡 Ejecuta: make up${NC}"
        exit 1
    fi
    
    # Verificar que Spark esté corriendo
    if ! docker-compose ps | grep -q "master.*Up"; then
        echo -e "${RED}❌ Error: Spark master no está corriendo${NC}"
        echo -e "${YELLOW}💡 Ejecuta: make up${NC}"
        exit 1
    fi
    
    # Verificar que Python esté disponible
    if ! command -v python3 > /dev/null 2>&1; then
        echo -e "${RED}❌ Error: Python3 no está instalado${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Prerrequisitos verificados${NC}"
}

# Función para ejecutar tutorial básico
run_basics() {
    echo -e "${PURPLE}🚀 Ejecutando Tutorial Básico de Spark...${NC}"
    echo -e "${CYAN}📚 Conceptos: RDD, DataFrames, Lazy Evaluation${NC}"
    echo ""
    
    python3 spark-tutorials/01-basics/01_spark_introduccion.py
    
    echo ""
    echo -e "${GREEN}✅ Tutorial básico completado${NC}"
}

# Función para ejecutar tutorial de DataFrames
run_dataframes() {
    echo -e "${PURPLE}📊 Ejecutando Tutorial de DataFrames Avanzados...${NC}"
    echo -e "${CYAN}📚 Conceptos: Joins, Window Functions, Optimización${NC}"
    echo ""
    
    python3 spark-tutorials/02-dataframes/02_dataframes_avanzado.py
    
    echo ""
    echo -e "${GREEN}✅ Tutorial de DataFrames completado${NC}"
}

# Función para ejecutar tutorial de SQL
run_sql() {
    echo -e "${PURPLE}🗄️ Ejecutando Tutorial de Spark SQL...${NC}"
    echo -e "${CYAN}📚 Conceptos: Consultas SQL, Hive, Optimización${NC}"
    echo ""
    
    python3 spark-tutorials/03-sql/03_spark_sql.py
    
    echo ""
    echo -e "${GREEN}✅ Tutorial de SQL completado${NC}"
}

# Función para ejecutar todos los tutoriales
run_all() {
    echo -e "${PURPLE}🎯 Ejecutando TODOS los tutoriales...${NC}"
    echo ""
    
    run_basics
    echo ""
    echo -e "${BLUE}⏳ Esperando 3 segundos antes del siguiente tutorial...${NC}"
    sleep 3
    
    run_dataframes
    echo ""
    echo -e "${BLUE}⏳ Esperando 3 segundos antes del siguiente tutorial...${NC}"
    sleep 3
    
    run_sql
    
    echo ""
    echo -e "${GREEN}🎉 TODOS los tutoriales completados exitosamente!${NC}"
}

# Función para abrir Jupyter
open_jupyter() {
    echo -e "${BLUE}🌐 Abriendo Jupyter Notebook...${NC}"
    echo -e "${YELLOW}💡 Navega a: http://localhost:8888${NC}"
    echo -e "${YELLOW}📁 Los tutoriales están en: spark-tutorials/${NC}"
    echo ""
    
    # Abrir navegador si es posible
    if command -v xdg-open > /dev/null 2>&1; then
        xdg-open http://localhost:8888
    elif command -v open > /dev/null 2>&1; then
        open http://localhost:8888
    else
        echo -e "${YELLOW}🌐 Abre manualmente: http://localhost:8888${NC}"
    fi
}

# Función para mostrar estadísticas
show_stats() {
    echo -e "${BLUE}📊 Estadísticas del proyecto:${NC}"
    echo ""
    
    # Contar archivos Python
    python_files=$(find spark-tutorials -name "*.py" | wc -l)
    echo -e "${GREEN}📄 Archivos Python: ${python_files}${NC}"
    
    # Contar líneas de código
    total_lines=$(find spark-tutorials -name "*.py" -exec wc -l {} + | tail -1 | awk '{print $1}')
    echo -e "${GREEN}📝 Líneas de código: ${total_lines}${NC}"
    
    # Mostrar tamaño del directorio
    dir_size=$(du -sh spark-tutorials | cut -f1)
    echo -e "${GREEN}💾 Tamaño del directorio: ${dir_size}${NC}"
    
    echo ""
}

# Función principal
main() {
    show_banner
    
    # Verificar argumentos
    if [ $# -eq 0 ] || [ "$1" = "--help" ]; then
        show_help
        exit 0
    fi
    
    # Verificar prerrequisitos
    check_prerequisites
    
    # Procesar argumentos
    tutorial=$1
    use_jupyter=false
    
    # Verificar opciones
    for arg in "$@"; do
        case $arg in
            --jupyter)
                use_jupyter=true
                ;;
        esac
    done
    
    # Si se solicita Jupyter, abrirlo y salir
    if [ "$use_jupyter" = true ]; then
        open_jupyter
        exit 0
    fi
    
    # Ejecutar tutorial solicitado
    case $tutorial in
        basics)
            run_basics
            ;;
        dataframes)
            run_dataframes
            ;;
        sql)
            run_sql
            ;;
        all)
            run_all
            ;;
        stats)
            show_stats
            ;;
        *)
            echo -e "${RED}❌ Tutorial desconocido: $tutorial${NC}"
            echo -e "${YELLOW}💡 Usa --help para ver tutoriales disponibles${NC}"
            exit 1
            ;;
    esac
    
    # Mostrar estadísticas al final
    echo ""
    show_stats
    
    echo -e "${GREEN}🎉 Proceso completado exitosamente!${NC}"
}

# Ejecutar función principal con todos los argumentos
main "$@"
