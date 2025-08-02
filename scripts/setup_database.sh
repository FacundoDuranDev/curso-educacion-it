#!/bin/bash

# Script para configurar la base de datos PostgreSQL para el curso de Data Engineering
# Autor: EducaciónIT
# Fecha: 2024

echo "🚀 Configurando base de datos para Data Engineering..."
echo "=================================================="

# Verificar que PostgreSQL esté corriendo
echo "📋 Verificando conexión a PostgreSQL..."
if ! psql -h localhost -p 5432 -U admin -d educacionit -c "SELECT 1;" > /dev/null 2>&1; then
    echo "❌ Error: No se puede conectar a PostgreSQL"
    echo "   Asegúrate de que el contenedor esté corriendo:"
    echo "   docker-compose up -d postgres"
    exit 1
fi
echo "✅ Conexión a PostgreSQL exitosa"

# Verificar que los archivos CSV existan
echo "📋 Verificando archivos de datos..."
if [ ! -f "Etapa 1/Clientes.csv" ]; then
    echo "❌ Error: No se encuentra el archivo Etapa 1/Clientes.csv"
    exit 1
fi
echo "✅ Archivos de datos encontrados"

# Crear tablas
echo "📋 Creando tablas..."
psql -h localhost -p 5432 -U admin -d educacionit -f scripts/create_tables.sql
if [ $? -eq 0 ]; then
    echo "✅ Tablas creadas exitosamente"
else
    echo "❌ Error al crear las tablas"
    exit 1
fi

# Cargar datos
echo "📋 Cargando datos..."
cd scripts
psql -h localhost -p 5432 -U admin -d educacionit -f load_data.sql
if [ $? -eq 0 ]; then
    echo "✅ Datos cargados exitosamente"
else
    echo "❌ Error al cargar los datos"
    exit 1
fi
cd ..

# Verificar datos cargados
echo "📋 Verificando datos cargados..."
psql -h localhost -p 5432 -U admin -d educacionit -c "
SELECT 'Canal de Venta' as tabla, COUNT(*) as registros FROM canal_venta 
UNION ALL SELECT 'Clientes', COUNT(*) FROM clientes 
UNION ALL SELECT 'Compras', COUNT(*) FROM compras 
UNION ALL SELECT 'Empleados', COUNT(*) FROM empleados 
UNION ALL SELECT 'Gastos', COUNT(*) FROM gastos 
UNION ALL SELECT 'Productos', COUNT(*) FROM productos 
UNION ALL SELECT 'Proveedores', COUNT(*) FROM proveedores 
UNION ALL SELECT 'Sucursales', COUNT(*) FROM sucursales 
UNION ALL SELECT 'Tipos de Gasto', COUNT(*) FROM tipos_gasto 
UNION ALL SELECT 'Ventas', COUNT(*) FROM ventas 
ORDER BY tabla;"

echo ""
echo "🎉 ¡Base de datos configurada exitosamente!"
echo "=================================================="
echo ""
echo "📚 Para conectar a la base de datos:"
echo "   psql -h localhost -p 5432 -U admin -d educacionit"
echo ""
echo "📝 Para ejecutar los ejercicios:"
echo "   psql -h localhost -p 5432 -U admin -d educacionit -f scripts/ejercicios_clase.sql"
echo ""
echo "🔍 Para ver las tablas disponibles:"
echo "   psql -h localhost -p 5432 -U admin -d educacionit -c \"\\dt\""
echo "" 