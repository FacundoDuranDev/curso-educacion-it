#!/usr/bin/env python3
"""
Script para probar la conexión de Spark con Hive y leer los datos cargados
"""

from pyspark.sql import SparkSession

# Crear sesión de Spark con soporte para Hive
spark = SparkSession.builder \
    .appName("TestSparkHive") \
    .enableHiveSupport() \
    .getOrCreate()

print("=== SPARK + HIVE TEST ===")
print(f"Spark Version: {spark.version}")

# Cambiar a la base de datos educacionit
spark.sql("USE educacionit")

# Mostrar todas las bases de datos
print("\n📊 Bases de datos disponibles:")
spark.sql("SHOW DATABASES").show()

# Mostrar todas las tablas
print("\n📋 Tablas en educacionit:")
spark.sql("SHOW TABLES").show()

# Probar lectura de algunas tablas
print("\n🔍 Probando lectura de datos:")

try:
    # Canal de venta
    canal_df = spark.sql("SELECT * FROM canal_venta")
    print(f"✅ canal_venta: {canal_df.count()} registros")
    canal_df.show(5)
except Exception as e:
    print(f"❌ Error en canal_venta: {e}")

try:
    # Productos
    productos_df = spark.sql("SELECT * FROM productos LIMIT 5")
    print(f"✅ productos (primeros 5):")
    productos_df.show()
except Exception as e:
    print(f"❌ Error en productos: {e}")

try:
    # Clientes
    clientes_df = spark.sql("SELECT COUNT(*) as total FROM clientes")
    print(f"✅ clientes:")
    clientes_df.show()
except Exception as e:
    print(f"❌ Error en clientes: {e}")

# Cerrar sesión
spark.stop()
print("\n✅ Test completado!")

