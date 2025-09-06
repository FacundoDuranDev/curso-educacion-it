#!/bin/bash

# Script de monitoreo para YARN
# Este script ayuda a monitorear los jobs en ejecución

echo "=== MONITOREO DE YARN ==="
echo "Fecha: $(date)"
echo ""

# Función para mostrar aplicaciones
mostrar_aplicaciones() {
    echo "=== APLICACIONES ACTIVAS ==="
    yarn application -list -appStates RUNNING
    
    echo ""
    echo "=== APLICACIONES RECIENTES ==="
    yarn application -list -appStates FINISHED,FAILED,KILLED | head -10
}

# Función para mostrar nodos
mostrar_nodos() {
    echo "=== ESTADO DE LOS NODOS ==="
    yarn node -list
}

# Función para mostrar métricas
mostrar_metricas() {
    echo "=== MÉTRICAS DEL CLUSTER ==="
    echo "Uso de memoria:"
    yarn top -mem
    
    echo ""
    echo "Uso de CPU:"
    yarn top -cpu
}

# Función para monitorear aplicación específica
monitorear_aplicacion() {
    if [ -z "$1" ]; then
        echo "Uso: $0 monitorear <application_id>"
        return 1
    fi
    
    echo "=== MONITOREANDO APLICACIÓN: $1 ==="
    yarn application -status $1
    
    echo ""
    echo "=== LOGS DE LA APLICACIÓN ==="
    yarn logs -applicationId $1 | tail -20
}

# Función para limpiar aplicaciones terminadas
limpiar_aplicaciones() {
    echo "=== LIMPIANDO APLICACIONES TERMINADAS ==="
    echo "Aplicaciones terminadas:"
    yarn application -list -appStates FINISHED,FAILED,KILLED
    
    echo ""
    read -p "¿Desea eliminar todas las aplicaciones terminadas? (y/N): " confirm
    if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
        echo "Eliminando aplicaciones terminadas..."
        yarn application -list -appStates FINISHED,FAILED,KILLED | grep -v "Total" | awk '{print $1}' | grep -v "ApplicationId" | while read app_id; do
            if [ ! -z "$app_id" ]; then
                echo "Eliminando aplicación: $app_id"
                yarn application -kill $app_id
            fi
        done
    fi
}

# Función para mostrar uso de HDFS
mostrar_hdfs() {
    echo "=== ESTADO DE HDFS ==="
    hdfs dfsadmin -report
    
    echo ""
    echo "=== USO DE ESPACIO ==="
    hdfs dfs -df -h
}

# Menú principal
case "$1" in
    "aplicaciones")
        mostrar_aplicaciones
        ;;
    "nodos")
        mostrar_nodos
        ;;
    "metricas")
        mostrar_metricas
        ;;
    "monitorear")
        monitorear_aplicacion $2
        ;;
    "limpiar")
        limpiar_aplicaciones
        ;;
    "hdfs")
        mostrar_hdfs
        ;;
    "todo")
        mostrar_aplicaciones
        echo ""
        mostrar_nodos
        echo ""
        mostrar_hdfs
        ;;
    *)
        echo "=== SCRIPT DE MONITOREO YARN ==="
        echo "Uso: $0 [comando]"
        echo ""
        echo "Comandos disponibles:"
        echo "  aplicaciones  - Mostrar aplicaciones activas y recientes"
        echo "  nodos         - Mostrar estado de los nodos"
        echo "  metricas      - Mostrar métricas del cluster"
        echo "  monitorear <id> - Monitorear aplicación específica"
        echo "  limpiar       - Limpiar aplicaciones terminadas"
        echo "  hdfs          - Mostrar estado de HDFS"
        echo "  todo          - Mostrar toda la información"
        echo ""
        echo "Ejemplos:"
        echo "  $0 aplicaciones"
        echo "  $0 monitorear application_1234567890_0001"
        echo "  $0 todo"
        ;;
esac
