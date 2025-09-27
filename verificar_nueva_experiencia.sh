#!/bin/bash

# 🧪 SCRIPT DE VERIFICACIÓN - NUEVA EXPERIENCIA DE USUARIO
# Este script simula lo que haría un nuevo alumno

echo "🎯 VERIFICANDO NUEVA EXPERIENCIA DE USUARIO"
echo "=============================================="

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

success=0
total=0

check_file() {
    local file=$1
    local description=$2
    total=$((total + 1))
    
    if [ -f "$file" ]; then
        echo -e "${GREEN}✅ $description${NC}"
        success=$((success + 1))
    else
        echo -e "${RED}❌ $description${NC}"
        echo "   📁 Archivo faltante: $file"
    fi
}

check_url() {
    local url=$1
    local description=$2
    total=$((total + 1))
    
    if curl -s "$url" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ $description${NC}"
        success=$((success + 1))
    else
        echo -e "${RED}❌ $description${NC}"
        echo "   🌐 URL no responde: $url"
    fi
}

echo ""
echo "📋 1. VERIFICANDO ESTRUCTURA NUEVA DOCUMENTACIÓN"
echo "================================================"

check_file "README.md" "README principal actualizado"
check_file "docs/README.md" "Índice de documentación"
check_file "docs/01-GETTING-STARTED/README.md" "Guía de inicio"
check_file "docs/01-GETTING-STARTED/instalacion-rapida.md" "Instalación rápida"
check_file "docs/04-REFERENCE/credenciales.md" "Credenciales centralizadas"
check_file "docs/02-HOW-TO-GUIDES/troubleshooting/problemas-comunes.md" "Troubleshooting"

echo ""
echo "🔧 2. VERIFICANDO MAKEFILE Y DOCKER-COMPOSE"
echo "============================================"

check_file "Makefile" "Makefile disponible"
check_file "docker-compose.yml" "Docker Compose configurado"

# Verificar que make funciona
total=$((total + 1))
if command -v make >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Comando 'make' disponible${NC}"
    success=$((success + 1))
else
    echo -e "${RED}❌ Comando 'make' no disponible${NC}"
    echo "   💡 En Windows: choco install make"
    echo "   💡 En Ubuntu: sudo apt install make"
fi

echo ""
echo "🐳 3. VERIFICANDO DOCKER"
echo "========================"

# Verificar Docker
total=$((total + 1))
if command -v docker >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Docker instalado${NC}"
    success=$((success + 1))
else
    echo -e "${RED}❌ Docker no instalado${NC}"
fi

# Verificar Docker Compose
total=$((total + 1))
if command -v docker-compose >/dev/null 2>&1 || command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Docker Compose disponible${NC}"
    success=$((success + 1))
else
    echo -e "${RED}❌ Docker Compose no disponible${NC}"
fi

echo ""
echo "🏗️ 4. VERIFICANDO IMÁGENES DOCKER (si están construidas)"
echo "========================================================"

# Verificar si las imágenes personalizadas existen
images=("hadoop-hive-spark-base" "hadoop-hive-spark-master" "hadoop-hive-spark-worker" "hadoop-hive-spark-jupyter" "hadoop-hive-spark-jupyterlab")

for image in "${images[@]}"; do
    total=$((total + 1))
    if docker images | grep -q "$image"; then
        echo -e "${GREEN}✅ Imagen $image construida${NC}"
        success=$((success + 1))
    else
        echo -e "${YELLOW}⚠️ Imagen $image no construida (normal si es primera vez)${NC}"
        echo "   💡 Ejecutar: make build"
    fi
done

echo ""
echo "🌐 5. VERIFICANDO SERVICIOS (si están corriendo)"
echo "==============================================="

# Verificar servicios web (solo si están corriendo)
services=(
    "http://localhost:5432|PostgreSQL"
    "http://localhost:8888|Jupyter Notebook"
    "http://localhost:8890|JupyterLab"
    "http://localhost:8080|Spark Master"
    "http://localhost:9870|HDFS Web UI"
    "http://localhost:8088|YARN ResourceManager"
)

for service in "${services[@]}"; do
    IFS='|' read -r url description <<< "$service"
    total=$((total + 1))
    
    if [ "$url" = "http://localhost:5432" ]; then
        # PostgreSQL requiere verificación especial
        if docker ps | grep -q "educacionit-metastore-1"; then
            echo -e "${GREEN}✅ $description corriendo${NC}"
            success=$((success + 1))
        else
            echo -e "${YELLOW}⚠️ $description no corriendo (normal si no se ha ejecutado 'make up')${NC}"
        fi
    else
        # Otros servicios HTTP
        if curl -s --connect-timeout 2 "$url" > /dev/null 2>&1; then
            echo -e "${GREEN}✅ $description corriendo${NC}"
            success=$((success + 1))
        else
            echo -e "${YELLOW}⚠️ $description no corriendo (normal si no se ha ejecutado 'make up')${NC}"
        fi
    fi
done

echo ""
echo "📊 6. VERIFICANDO CONTENIDO DE ARCHIVOS CRÍTICOS"
echo "==============================================="

# Verificar que README.md contiene la nueva estructura
total=$((total + 1))
if grep -q "🎯 **¡BIENVENIDO AL CURSO MÁS COMPLETO DE DATA ENGINEERING!**" README.md 2>/dev/null; then
    echo -e "${GREEN}✅ README.md actualizado con nueva estructura${NC}"
    success=$((success + 1))
else
    echo -e "${RED}❌ README.md no tiene la nueva estructura${NC}"
fi

# Verificar que credenciales.md tiene contenido
total=$((total + 1))
if [ -f "docs/04-REFERENCE/credenciales.md" ] && [ -s "docs/04-REFERENCE/credenciales.md" ]; then
    echo -e "${GREEN}✅ Archivo de credenciales tiene contenido${NC}"
    success=$((success + 1))
else
    echo -e "${RED}❌ Archivo de credenciales vacío o inexistente${NC}"
fi

echo ""
echo "🎯 RESUMEN DE VERIFICACIÓN"
echo "=========================="

percentage=$((success * 100 / total))

echo "📊 Resultados: $success/$total tests pasados ($percentage%)"

if [ $percentage -ge 80 ]; then
    echo -e "${GREEN}🎉 ¡EXCELENTE! La nueva experiencia está lista${NC}"
    echo ""
    echo "✅ PRÓXIMOS PASOS PARA UN NUEVO USUARIO:"
    echo "1. git clone https://github.com/FacundoDuranDev/curso-educacion-it.git"
    echo "2. cd curso-educacion-it"
    echo "3. make"
    echo "4. Abrir http://localhost:8888"
    echo ""
    echo "📚 DOCUMENTACIÓN DISPONIBLE:"
    echo "- README.md (punto de entrada)"
    echo "- docs/ (documentación organizada)"
    echo "- docs/04-REFERENCE/credenciales.md (todas las credenciales)"
    echo "- docs/02-HOW-TO-GUIDES/troubleshooting/ (solución de problemas)"
elif [ $percentage -ge 60 ]; then
    echo -e "${YELLOW}⚠️ BUENO - La estructura está lista, faltan servicios corriendo${NC}"
    echo ""
    echo "🔧 PARA COMPLETAR LA VERIFICACIÓN:"
    echo "make build  # Construir imágenes"
    echo "make up     # Levantar servicios"
    echo "./verificar_nueva_experiencia.sh  # Ejecutar de nuevo"
else
    echo -e "${RED}❌ NECESITA TRABAJO - Faltan elementos críticos${NC}"
    echo ""
    echo "🚨 ELEMENTOS FALTANTES CRÍTICOS:"
    echo "- Verificar que todos los archivos de documentación estén presentes"
    echo "- Asegurarse que Docker esté instalado"
    echo "- Verificar que make esté disponible"
fi

echo ""
echo "📋 LISTA DE VERIFICACIÓN PARA INSTRUCTOR:"
echo "========================================="
echo "□ README.md actualizado y atractivo"
echo "□ docs/ estructura creada y poblada"
echo "□ Credenciales centralizadas y claras"
echo "□ Troubleshooting completo disponible"
echo "□ make build funciona sin errores"
echo "□ make up levanta todos los servicios"
echo "□ URLs responden correctamente"
echo "□ PostgreSQL acepta conexiones"
echo "□ Jupyter accesible sin token"
echo "□ Spark cluster visible y funcional"

echo ""
echo "🎯 ¡Verificación completada!"
