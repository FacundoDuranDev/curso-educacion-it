#!/bin/bash

# 🔧 SCRIPT PARA HACER NOTEBOOKS MODIFICABLES
# Este script resuelve el problema de archivos de solo lectura en Jupyter

echo "🚀 Iniciando proceso para hacer notebooks modificables..."
echo "=================================================="

# Verificar si estamos en el directorio correcto
if [ ! -d "spark-tutorials" ] || [ ! -d "jupyter" ]; then
    echo "❌ Error: Ejecutar este script desde el directorio raíz del proyecto"
    echo "   Directorio actual: $(pwd)"
    echo "   Debe contener las carpetas 'spark-tutorials' y 'jupyter'"
    exit 1
fi

echo "📂 Directorio actual: $(pwd)"
echo ""

# Función para procesar archivos
procesar_archivos() {
    local directorio=$1
    local extension=$2
    local descripcion=$3
    
    echo "🔍 Buscando $descripcion en $directorio..."
    
    if [ -d "$directorio" ]; then
        # Contar archivos encontrados
        count=$(find "$directorio" -name "$extension" 2>/dev/null | wc -l)
        
        if [ $count -gt 0 ]; then
            echo "   📊 Encontrados $count archivos"
            
            # Mostrar archivos antes de modificar
            echo "   📋 Archivos encontrados:"
            find "$directorio" -name "$extension" -exec ls -la {} \; | sed 's/^/     /'
            
            # Cambiar permisos
            find "$directorio" -name "$extension" -exec chmod 777 {} \;
            echo "   ✅ Permisos modificados a 777"
        else
            echo "   ℹ️ No se encontraron archivos $extension"
        fi
    else
        echo "   ⚠️ Directorio $directorio no existe"
    fi
    echo ""
}

# Procesar notebooks de Jupyter
procesar_archivos "jupyter/notebook/spark-tutorials" "*.ipynb" "notebooks de Jupyter"

# Procesar notebooks de spark-tutorials
procesar_archivos "spark-tutorials" "*.ipynb" "notebooks de Spark"

# Procesar scripts Python
procesar_archivos "." "*.py" "scripts Python"

# Hacer scripts ejecutables
echo "🔧 Haciendo scripts ejecutables..."
find . -name "*.sh" -exec chmod +x {} \;
echo "✅ Scripts .sh ahora son ejecutables"

echo "=================================================="
echo "🎉 ¡PROCESO COMPLETADO!"
echo ""
echo "📋 Resumen de cambios:"
echo "   • Notebooks .ipynb → Permisos 777 (lectura/escritura/ejecución)"
echo "   • Scripts .py → Permisos 777"
echo "   • Scripts .sh → Ejecutables"
echo ""
echo "💡 Ahora puedes editar los notebooks en Jupyter sin problemas"
echo "🌐 Accede a: http://localhost:8890"
echo ""
echo "🔍 Para verificar permisos:"
echo "   ls -la jupyter/notebook/spark-tutorials/*/*.ipynb"
echo "   ls -la spark-tutorials/*/*.ipynb"
