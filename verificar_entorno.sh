#!/bin/bash

# Script de verificación del entorno para alumnos
# Ayuda a diagnosticar problemas comunes antes de ejecutar make

echo "🔍 VERIFICANDO ENTORNO PARA HADOOP-HIVE-SPARK..."
echo "=================================================="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para mostrar OK
show_ok() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Función para mostrar ERROR
show_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Función para mostrar WARNING
show_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Función para mostrar INFO
show_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

echo ""
echo "1️⃣ VERIFICANDO DOCKER..."
echo "------------------------"

# Verificar Docker
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version)
    show_ok "Docker instalado: $DOCKER_VERSION"
    
    # Verificar si Docker daemon está corriendo
    if docker info &> /dev/null; then
        show_ok "Docker daemon está corriendo"
    else
        show_error "Docker daemon NO está corriendo"
        show_info "Solución: sudo systemctl start docker (Linux) o iniciar Docker Desktop"
        exit 1
    fi
else
    show_error "Docker NO está instalado"
    show_info "Instalar desde: https://docs.docker.com/get-docker/"
    exit 1
fi

# Verificar Docker Compose
if command -v docker-compose &> /dev/null; then
    COMPOSE_VERSION=$(docker-compose --version)
    show_ok "Docker Compose instalado: $COMPOSE_VERSION"
else
    show_error "Docker Compose NO está instalado"
    show_info "Instalar desde: https://docs.docker.com/compose/install/"
    exit 1
fi

echo ""
echo "2️⃣ VERIFICANDO ARCHIVOS DEL PROYECTO..."
echo "---------------------------------------"

# Verificar archivos críticos
REQUIRED_FILES=(
    "docker-compose.yml"
    "Makefile"
    "base/Dockerfile"
    "master/Dockerfile"
    "worker/Dockerfile"
    "history/Dockerfile"
    "jupyter/Dockerfile"
    "jupyterlab/Dockerfile"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [[ -f "$file" ]]; then
        show_ok "Archivo encontrado: $file"
    else
        show_error "Archivo FALTANTE: $file"
        show_info "Asegúrate de estar en el directorio correcto del proyecto"
        exit 1
    fi
done

echo ""
echo "3️⃣ VERIFICANDO PUERTOS DISPONIBLES..."
echo "-------------------------------------"

# Puertos que debe usar el proyecto
REQUIRED_PORTS=(5432 8020 8080 8088 8888 8890 9870 10000 16010 18080 19888)

for port in "${REQUIRED_PORTS[@]}"; do
    if lsof -Pi :$port -sTCP:LISTEN -t &> /dev/null; then
        show_warning "Puerto $port ya está en uso"
        PROCESS=$(lsof -Pi :$port -sTCP:LISTEN | tail -n 1)
        show_info "Proceso: $PROCESS"
    else
        show_ok "Puerto $port disponible"
    fi
done

echo ""
echo "4️⃣ VERIFICANDO ESPACIO EN DISCO..."
echo "-----------------------------------"

# Verificar espacio disponible (mínimo 10GB)
AVAILABLE_SPACE=$(df . | awk 'NR==2 {print $4}')
AVAILABLE_GB=$((AVAILABLE_SPACE / 1024 / 1024))

if [[ $AVAILABLE_GB -gt 10 ]]; then
    show_ok "Espacio disponible: ${AVAILABLE_GB}GB (suficiente)"
else
    show_warning "Espacio disponible: ${AVAILABLE_GB}GB (puede ser insuficiente)"
    show_info "Recomendado: mínimo 10GB libres"
fi

echo ""
echo "5️⃣ VERIFICANDO MEMORIA RAM..."
echo "-----------------------------"

# Verificar memoria disponible (mínimo 8GB)
if command -v free &> /dev/null; then
    TOTAL_RAM=$(free -g | awk 'NR==2{print $2}')
    if [[ $TOTAL_RAM -gt 7 ]]; then
        show_ok "RAM total: ${TOTAL_RAM}GB (suficiente)"
    else
        show_warning "RAM total: ${TOTAL_RAM}GB (puede ser insuficiente)"
        show_info "Recomendado: mínimo 8GB RAM"
    fi
else
    show_info "No se pudo verificar la memoria RAM (comando 'free' no disponible)"
fi

echo ""
echo "6️⃣ VERIFICANDO MAKE..."
echo "---------------------"

if command -v make &> /dev/null; then
    MAKE_VERSION=$(make --version | head -n1)
    show_ok "Make instalado: $MAKE_VERSION"
else
    show_error "Make NO está instalado"
    show_info "Ubuntu/Debian: sudo apt-get install build-essential"
    show_info "macOS: xcode-select --install"
    show_info "Windows: choco install make"
    exit 1
fi

echo ""
echo "7️⃣ VERIFICANDO IMÁGENES DOCKER EXISTENTES..."
echo "--------------------------------------------"

# Verificar si las imágenes ya existen
DOCKER_IMAGES=(
    "hadoop-hive-spark-base"
    "hadoop-hive-spark-master"
    "hadoop-hive-spark-worker"
    "hadoop-hive-spark-history"
    "hadoop-hive-spark-jupyter"
    "hadoop-hive-spark-jupyterlab"
)

IMAGES_EXIST=0
for image in "${DOCKER_IMAGES[@]}"; do
    if docker images | grep -q "^$image"; then
        show_ok "Imagen encontrada: $image"
        IMAGES_EXIST=$((IMAGES_EXIST + 1))
    else
        show_info "Imagen no encontrada: $image (se construirá con 'make build')"
    fi
done

echo ""
echo "📋 RESUMEN DE VERIFICACIÓN"
echo "========================="

if [[ $IMAGES_EXIST -eq 6 ]]; then
    show_ok "Todas las imágenes Docker ya existen"
    show_info "Puedes ejecutar directamente: docker-compose up -d"
elif [[ $IMAGES_EXIST -gt 0 ]]; then
    show_warning "Algunas imágenes existen, pero no todas"
    show_info "Recomendado ejecutar: make clean && make"
else
    show_info "No hay imágenes construidas"
    show_info "Debes ejecutar: make build (o simplemente 'make')"
fi

echo ""
echo "🚀 SIGUIENTES PASOS RECOMENDADOS:"
echo "================================="

if [[ $IMAGES_EXIST -eq 6 ]]; then
    echo "1. docker-compose up -d"
    echo "2. make status (para verificar)"
else
    echo "1. make (construye imágenes y levanta servicios)"
    echo "2. make status (para verificar)"
fi

echo ""
echo "🌐 DESPUÉS DE LEVANTAR LOS SERVICIOS:"
echo "===================================="
echo "• Jupyter Lab: http://localhost:8890"
echo "• Jupyter Notebook: http://localhost:8888"
echo "• Spark Master: http://localhost:8080"
echo "• HDFS Web UI: http://localhost:9870"
echo "• YARN ResourceManager: http://localhost:8088"

echo ""
show_ok "Verificación completada. ¡Tu entorno está listo!"



