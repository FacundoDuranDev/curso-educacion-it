#!/bin/bash

# 🚨 Script de Detección Automática de Nombres de Contenedores
# Detecta si estás usando Docker Compose v1 o v2 y muestra los nombres correctos

echo "🔍 Detectando versión de Docker Compose..."
echo "=========================================="

# Verificar si docker-compose está instalado
if ! command -v docker-compose &> /dev/null; then
    echo "❌ ERROR: docker-compose no está instalado"
    echo "💡 Instala Docker Compose primero"
    exit 1
fi

# Obtener versión de Docker Compose
COMPOSE_VERSION=$(docker-compose --version | grep -oE '[0-9]+\.[0-9]+' | head -1)

echo "📋 Versión detectada: Docker Compose v$COMPOSE_VERSION"
echo ""

# Determinar nombres de contenedores según la versión
if [[ $(echo "$COMPOSE_VERSION >= 2.0" | bc -l 2>/dev/null) -eq 1 ]] || [[ "$COMPOSE_VERSION" == "2"* ]]; then
    echo "✅ Docker Compose v2 detectado - usando guiones medios (-)"
    echo ""
    echo "📦 Nombres de contenedores:"
    echo "   • Metastore:  educacionit-metastore-1"
    echo "   • Master:     educacionit-master-1"
    echo "   • Worker1:    educacionit-worker1-1"
    echo "   • Worker2:    educacionit-worker2-1"
    echo "   • History:    educacionit-history-1"
    echo "   • Jupyter:    educacionit-jupyter-1"
    echo ""
    echo "💡 Comandos recomendados:"
    echo "   docker exec -it educacionit-metastore-1 psql -U postgres"
    echo "   docker exec -it educacionit-master-1 bash"
    echo "   docker exec -it educacionit-worker1-1 bash"
    
elif [[ $(echo "$COMPOSE_VERSION >= 1.0" | bc -l 2>/dev/null) -eq 1 ]] || [[ "$COMPOSE_VERSION" == "1"* ]]; then
    echo "⚠️  Docker Compose v1 detectado - usando guiones bajos (_)"
    echo ""
    echo "📦 Nombres de contenedores:"
    echo "   • Metastore:  educacionit_metastore_1"
    echo "   • Master:     educacionit_master_1"
    echo "   • Worker1:    educacionit_worker1_1"
    echo "   • Worker2:    educacionit_worker2_1"
    echo "   • History:    educacionit_history_1"
    echo "   • Jupyter:    educacionit_jupyter_1"
    echo ""
    echo "💡 Comandos recomendados:"
    echo "   docker exec -it educacionit_metastore_1 psql -U postgres"
    echo "   docker exec -it educacionit_master_1 bash"
    echo "   docker exec -it educacionit_worker1_1 bash"
    
else
    echo "❓ Versión no reconocida: $COMPOSE_VERSION"
    echo "💡 Verifica manualmente con: docker-compose --version"
    exit 1
fi

echo ""
echo "🚀 SOLUCIÓN UNIVERSAL (funciona en ambas versiones):"
echo "   docker-compose exec metastore psql -U postgres"
echo "   docker-compose exec master bash"
echo "   docker-compose exec worker1 bash"
echo ""
echo "🔍 Para ver nombres exactos de contenedores corriendo:"
echo "   docker-compose ps"
echo ""
echo "📚 Para más información, consulta: SOLUCION_NOMBRES_CONTENEDORES.md"
