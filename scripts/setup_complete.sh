#!/bin/bash

echo "🚀 Configuración Completa del Entorno de Data Engineering"
echo "========================================================"
echo ""

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes con colores
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar que Docker esté ejecutándose
print_status "Verificando Docker..."
if ! sudo docker info > /dev/null 2>&1; then
    print_error "Docker no está ejecutándose. Por favor, inicia Docker y vuelve a intentar."
    exit 1
fi
print_success "Docker está ejecutándose"

# Detener contenedores existentes si los hay
print_status "Deteniendo contenedores existentes..."
sudo docker-compose down --remove-orphans 2>/dev/null || true
print_success "Contenedores detenidos"

# Iniciar todos los servicios
print_status "Iniciando todos los servicios..."
sudo docker-compose up -d

# Esperar a que los servicios básicos estén listos
print_status "Esperando a que los servicios básicos se inicien..."
sleep 60

# Verificar PostgreSQL
print_status "Verificando PostgreSQL..."
if sudo docker exec -it postgres psql -U admin -d educacionit -c "SELECT 1;" > /dev/null 2>&1; then
    print_success "PostgreSQL funcionando"
else
    print_warning "PostgreSQL aún no está listo, esperando..."
    sleep 30
fi

# Configurar base de datos PostgreSQL
print_status "Configurando base de datos PostgreSQL..."
if [ -f "scripts/setup_database.sh" ]; then
    ./scripts/setup_database.sh
    print_success "Base de datos PostgreSQL configurada"
else
    print_warning "Script de configuración de base de datos no encontrado"
fi

# Verificar HDFS
print_status "Verificando HDFS..."
if sudo docker exec -it hadoop-namenode hdfs dfsadmin -report > /dev/null 2>&1; then
    print_success "HDFS funcionando"
else
    print_warning "HDFS aún no está listo, esperando..."
    sleep 30
fi

# Configurar HDFS para Hive
print_status "Configurando HDFS para Hive..."
if [ -f "scripts/init_hive_hdfs.sh" ]; then
    ./scripts/init_hive_hdfs.sh
    print_success "HDFS configurado para Hive"
else
    print_warning "Script de configuración de HDFS no encontrado"
fi

# Esperar a que Hive se inicie
print_status "Esperando a que Hive se inicie completamente..."
sleep 120

# Verificar Hive
print_status "Verificando Hive..."
MAX_ATTEMPTS=10
ATTEMPT=1

while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
    if sudo docker exec -it hive-server beeline -u jdbc:hive2://localhost:10000 -e "SHOW DATABASES;" > /dev/null 2>&1; then
        print_success "Hive funcionando correctamente"
        break
    else
        print_warning "Intento $ATTEMPT/$MAX_ATTEMPTS: Hive aún no está listo, esperando..."
        sleep 30
        ATTEMPT=$((ATTEMPT + 1))
    fi
done

if [ $ATTEMPT -gt $MAX_ATTEMPTS ]; then
    print_error "Hive no se pudo iniciar después de $MAX_ATTEMPTS intentos"
    print_status "Revisando logs de Hive..."
    sudo docker logs hive-server --tail 20
fi

# Configurar Hive con datos
print_status "Configurando Hive con datos del proyecto..."
if [ -f "scripts/setup_hive_complete.sh" ]; then
    ./scripts/setup_hive_complete.sh
    print_success "Hive configurado con datos"
else
    print_warning "Script de configuración de Hive no encontrado"
fi

# Verificar Spark
print_status "Verificando Spark..."
if curl -s http://localhost:8080 > /dev/null 2>&1; then
    print_success "Spark Master funcionando"
else
    print_warning "Spark Master aún no está listo"
fi

# Verificar Jupyter
print_status "Verificando Jupyter..."
if curl -s http://localhost:8888 > /dev/null 2>&1; then
    print_success "Jupyter funcionando"
else
    print_warning "Jupyter aún no está listo"
fi

# Mostrar resumen final
echo ""
echo "🎉 ¡Configuración completada!"
echo "=============================="
echo ""
echo "📊 Servicios disponibles:"
echo "   • PostgreSQL: localhost:5432"
echo "   • HDFS Web UI: http://localhost:9870"
echo "   • Spark Master: http://localhost:8080"
echo "   • Spark Worker: http://localhost:8081"
echo "   • Jupyter Lab: http://localhost:8888"
echo "   • HiveServer2: localhost:10000"
echo "   • Hive Metastore: localhost:9083"
echo ""
echo "🔗 Comandos útiles:"
echo "   • Conectar a PostgreSQL:"
echo "     psql -h localhost -p 5432 -U admin -d educacionit"
echo ""
echo "   • Conectar a Hive:"
echo "     docker exec -it hive-server beeline -u jdbc:hive2://localhost:10000"
echo ""
echo "   • Ver logs de un servicio:"
echo "     docker logs <nombre-servicio>"
echo ""
echo "   • Detener todos los servicios:"
echo "     docker-compose down"
echo ""
echo "📚 Para comenzar a trabajar:"
echo "   1. Abre Jupyter Lab en http://localhost:8888"
echo "   2. Conecta a Hive usando Beeline"
echo "   3. Ejecuta los ejercicios del curso"
echo ""
print_success "¡Entorno listo para el curso de Data Engineering!" 