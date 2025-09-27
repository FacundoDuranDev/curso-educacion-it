#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
🗄️ SPARK TUTORIAL 03: SPARK SQL
================================

🎯 OBJETIVO: Dominar Spark SQL para consultas complejas

📋 CONTENIDO:
- Creación de vistas temporales
- Consultas SQL complejas
- Funciones SQL avanzadas
- Integración con Hive
- Optimización de consultas

⚡ EJECUTAR: python 03_spark_sql.py
"""

from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import StructType, StructField, StringType, IntegerType, DoubleType, DateType

def crear_spark_session():
    """
    🔧 Crear SparkSession con soporte SQL y Hive
    """
    print("🚀 Creando SparkSession para Spark SQL...")
    
    spark = SparkSession.builder \
        .appName("EducacionIT-Spark-SQL") \
        .master("spark://spark-master:7077") \
        .config("spark.executor.memory", "800m") \
        .config("spark.executor.cores", "1") \
        .config("spark.executor.instances", "2") \
        .config("spark.driver.memory", "1g") \
        .config("spark.sql.adaptive.enabled", "true") \
        .config("spark.sql.adaptive.coalescePartitions.enabled", "true") \
        .config("spark.sql.warehouse.dir", "/user/hive/warehouse") \
        .config("spark.sql.catalogImplementation", "hive") \
        .enableHiveSupport() \
        .getOrCreate()
    
    print("✅ SparkSession creada con soporte SQL y Hive")
    return spark

def crear_datos_ejemplo(spark):
    """
    📊 Crear tablas de ejemplo para consultas SQL
    """
    print("\n" + "="*60)
    print("📊 CREANDO TABLAS DE EJEMPLO")
    print("="*60)
    
    # Tabla de clientes
    clientes_data = [
        (1, "Juan Pérez", "juan.perez@email.com", "Madrid", "2020-01-15", "Premium"),
        (2, "María García", "maria.garcia@email.com", "Barcelona", "2019-03-20", "Standard"),
        (3, "Carlos López", "carlos.lopez@email.com", "Madrid", "2021-06-10", "Premium"),
        (4, "Ana Martínez", "ana.martinez@email.com", "Valencia", "2018-11-05", "Basic"),
        (5, "Luis Rodríguez", "luis.rodriguez@email.com", "Sevilla", "2017-09-12", "Premium"),
        (6, "Laura Sánchez", "laura.sanchez@email.com", "Barcelona", "2022-02-28", "Standard"),
        (7, "Pedro González", "pedro.gonzalez@email.com", "Madrid", "2020-07-15", "Basic"),
        (8, "Carmen Ruiz", "carmen.ruiz@email.com", "Bilbao", "2021-04-03", "Premium"),
        (9, "Miguel Torres", "miguel.torres@email.com", "Valencia", "2019-12-10", "Standard"),
        (10, "Isabel Díaz", "isabel.diaz@email.com", "Sevilla", "2020-08-22", "Basic")
    ]
    
    clientes_schema = StructType([
        StructField("cliente_id", IntegerType(), True),
        StructField("nombre", StringType(), True),
        StructField("email", StringType(), True),
        StructField("ciudad", StringType(), True),
        StructField("fecha_registro", StringType(), True),
        StructField("tipo_cliente", StringType(), True)
    ])
    
    df_clientes = spark.createDataFrame(clientes_data, clientes_schema)
    df_clientes = df_clientes.withColumn("fecha_registro", col("fecha_registro").cast(DateType()))
    
    # Tabla de productos
    productos_data = [
        (1, "Laptop Gaming", "Electrónicos", 1200.00, 50),
        (2, "Smartphone Pro", "Electrónicos", 800.00, 100),
        (3, "Silla Ergonómica", "Oficina", 300.00, 25),
        (4, "Monitor 4K", "Electrónicos", 600.00, 30),
        (5, "Mesa Escritorio", "Oficina", 450.00, 15),
        (6, "Auriculares", "Electrónicos", 150.00, 200),
        (7, "Teclado Mecánico", "Electrónicos", 120.00, 150),
        (8, "Mouse Inalámbrico", "Electrónicos", 80.00, 180),
        (9, "Lámpara LED", "Hogar", 60.00, 100),
        (10, "Organizador", "Oficina", 40.00, 120)
    ]
    
    productos_schema = StructType([
        StructField("producto_id", IntegerType(), True),
        StructField("nombre", StringType(), True),
        StructField("categoria", StringType(), True),
        StructField("precio", DoubleType(), True),
        StructField("stock", IntegerType(), True)
    ])
    
    df_productos = spark.createDataFrame(productos_data, productos_schema)
    
    # Tabla de ventas
    ventas_data = [
        (1, 1, 1, 1, 1200.00, "2024-01-15"),
        (2, 2, 2, 2, 1600.00, "2024-01-16"),
        (3, 3, 3, 1, 300.00, "2024-01-17"),
        (4, 1, 4, 1, 600.00, "2024-01-18"),
        (5, 4, 5, 1, 450.00, "2024-01-19"),
        (6, 2, 6, 3, 450.00, "2024-01-20"),
        (7, 5, 7, 2, 240.00, "2024-01-21"),
        (8, 1, 8, 1, 80.00, "2024-01-22"),
        (9, 3, 9, 2, 120.00, "2024-01-23"),
        (10, 2, 10, 5, 200.00, "2024-01-24"),
        (11, 6, 1, 1, 1200.00, "2024-01-25"),
        (12, 7, 2, 1, 800.00, "2024-01-26"),
        (13, 8, 3, 1, 300.00, "2024-01-27"),
        (14, 9, 4, 1, 600.00, "2024-01-28"),
        (15, 10, 5, 1, 450.00, "2024-01-29")
    ]
    
    ventas_schema = StructType([
        StructField("venta_id", IntegerType(), True),
        StructField("cliente_id", IntegerType(), True),
        StructField("producto_id", IntegerType(), True),
        StructField("cantidad", IntegerType(), True),
        StructField("total", DoubleType(), True),
        StructField("fecha", StringType(), True)
    ])
    
    df_ventas = spark.createDataFrame(ventas_data, ventas_schema)
    df_ventas = df_ventas.withColumn("fecha", col("fecha").cast(DateType()))
    
    print("👥 Tabla clientes:")
    df_clientes.show()
    
    print("📦 Tabla productos:")
    df_productos.show()
    
    print("💰 Tabla ventas:")
    df_ventas.show()
    
    return df_clientes, df_productos, df_ventas

def crear_vistas_temporales(spark, df_clientes, df_productos, df_ventas):
    """
    👁️ Crear vistas temporales para consultas SQL
    """
    print("\n" + "="*60)
    print("👁️ CREANDO VISTAS TEMPORALES")
    print("="*60)
    
    # Crear vistas temporales
    df_clientes.createOrReplaceTempView("clientes")
    df_productos.createOrReplaceTempView("productos")
    df_ventas.createOrReplaceTempView("ventas")
    
    print("✅ Vistas temporales creadas:")
    print("- clientes")
    print("- productos") 
    print("- ventas")
    
    # Mostrar todas las tablas
    print("\n📋 Tablas disponibles:")
    spark.sql("SHOW TABLES").show()

def consultas_sql_basicas(spark):
    """
    🔍 Consultas SQL básicas
    """
    print("\n" + "="*60)
    print("🔍 CONSULTAS SQL BÁSICAS")
    print("="*60)
    
    # Consulta simple
    print("1️⃣ Todos los clientes premium:")
    spark.sql("""
        SELECT cliente_id, nombre, ciudad, fecha_registro
        FROM clientes 
        WHERE tipo_cliente = 'Premium'
        ORDER BY fecha_registro DESC
    """).show()
    
    # Consulta con agregaciones
    print("2️⃣ Ventas por categoría de producto:")
    spark.sql("""
        SELECT p.categoria, 
               COUNT(v.venta_id) as total_ventas,
               SUM(v.total) as ingresos_totales,
               AVG(v.total) as promedio_venta
        FROM ventas v
        JOIN productos p ON v.producto_id = p.producto_id
        GROUP BY p.categoria
        ORDER BY ingresos_totales DESC
    """).show()
    
    # Consulta con subconsulta
    print("3️⃣ Clientes que han comprado productos caros (>500€):")
    spark.sql("""
        SELECT DISTINCT c.nombre, c.tipo_cliente, c.ciudad
        FROM clientes c
        WHERE c.cliente_id IN (
            SELECT v.cliente_id 
            FROM ventas v 
            JOIN productos p ON v.producto_id = p.producto_id
            WHERE p.precio > 500
        )
        ORDER BY c.nombre
    """).show()

def consultas_sql_avanzadas(spark):
    """
    🚀 Consultas SQL avanzadas
    """
    print("\n" + "="*60)
    print("🚀 CONSULTAS SQL AVANZADAS")
    print("="*60)
    
    # Window functions con SQL
    print("1️⃣ Ranking de productos por ingresos:")
    spark.sql("""
        SELECT p.nombre, p.categoria, 
               SUM(v.total) as ingresos_totales,
               RANK() OVER (PARTITION BY p.categoria ORDER BY SUM(v.total) DESC) as ranking_categoria,
               RANK() OVER (ORDER BY SUM(v.total) DESC) as ranking_general
        FROM ventas v
        JOIN productos p ON v.producto_id = p.producto_id
        GROUP BY p.producto_id, p.nombre, p.categoria
        ORDER BY ingresos_totales DESC
    """).show()
    
    # CTE (Common Table Expressions)
    print("2️⃣ Análisis de clientes con CTE:")
    spark.sql("""
        WITH ventas_cliente AS (
            SELECT v.cliente_id, 
                   COUNT(v.venta_id) as total_compras,
                   SUM(v.total) as gasto_total,
                   AVG(v.total) as promedio_compra
            FROM ventas v
            GROUP BY v.cliente_id
        ),
        clientes_activos AS (
            SELECT c.nombre, c.tipo_cliente, c.ciudad,
                   vc.total_compras, vc.gasto_total, vc.promedio_compra
            FROM clientes c
            JOIN ventas_cliente vc ON c.cliente_id = vc.cliente_id
            WHERE vc.total_compras >= 2
        )
        SELECT * FROM clientes_activos
        ORDER BY gasto_total DESC
    """).show()
    
    # CASE statements
    print("3️⃣ Clasificación de clientes por gasto:")
    spark.sql("""
        SELECT c.nombre, c.tipo_cliente,
               COALESCE(SUM(v.total), 0) as gasto_total,
               CASE 
                   WHEN COALESCE(SUM(v.total), 0) >= 2000 THEN 'Alto Gasto'
                   WHEN COALESCE(SUM(v.total), 0) >= 1000 THEN 'Medio Gasto'
                   WHEN COALESCE(SUM(v.total), 0) > 0 THEN 'Bajo Gasto'
                   ELSE 'Sin Compras'
               END as clasificacion_gasto
        FROM clientes c
        LEFT JOIN ventas v ON c.cliente_id = v.cliente_id
        GROUP BY c.cliente_id, c.nombre, c.tipo_cliente
        ORDER BY gasto_total DESC
    """).show()

def funciones_sql_avanzadas(spark):
    """
    🔧 Funciones SQL avanzadas
    """
    print("\n" + "="*60)
    print("🔧 FUNCIONES SQL AVANZADAS")
    print("="*60)
    
    # Funciones de fecha
    print("1️⃣ Análisis temporal de ventas:")
    spark.sql("""
        SELECT 
            DATE_FORMAT(fecha, 'yyyy-MM') as mes,
            COUNT(*) as total_ventas,
            SUM(total) as ingresos_mes,
            AVG(total) as promedio_venta
        FROM ventas
        GROUP BY DATE_FORMAT(fecha, 'yyyy-MM')
        ORDER BY mes
    """).show()
    
    # Funciones de string
    print("2️⃣ Análisis de emails de clientes:")
    spark.sql("""
        SELECT 
            nombre,
            email,
            SPLIT(email, '@')[1] as dominio_email,
            LENGTH(nombre) as longitud_nombre,
            UPPER(SUBSTRING(nombre, 1, 1)) as inicial_nombre
        FROM clientes
        WHERE email IS NOT NULL
        ORDER BY longitud_nombre DESC
    """).show()
    
    # Funciones de agregación avanzadas
    print("3️⃣ Estadísticas avanzadas por ciudad:")
    spark.sql("""
        SELECT c.ciudad,
               COUNT(DISTINCT c.cliente_id) as total_clientes,
               COUNT(v.venta_id) as total_ventas,
               SUM(v.total) as ingresos_totales,
               AVG(v.total) as promedio_venta,
               MIN(v.total) as venta_minima,
               MAX(v.total) as venta_maxima,
               STDDEV(v.total) as desviacion_ventas
        FROM clientes c
        LEFT JOIN ventas v ON c.cliente_id = v.cliente_id
        GROUP BY c.ciudad
        ORDER BY ingresos_totales DESC
    """).show()

def integracion_hive(spark):
    """
    🐝 Integración con Hive
    """
    print("\n" + "="*60)
    print("🐝 INTEGRACIÓN CON HIVE")
    print("="*60)
    
    # Crear tabla Hive
    print("1️⃣ Creando tabla en Hive:")
    spark.sql("""
        CREATE TABLE IF NOT EXISTS clientes_hive (
            cliente_id INT,
            nombre STRING,
            email STRING,
            ciudad STRING,
            fecha_registro DATE,
            tipo_cliente STRING
        )
        STORED AS PARQUET
        LOCATION '/user/hive/warehouse/clientes_hive'
    """)
    
    # Insertar datos en tabla Hive
    print("2️⃣ Insertando datos en tabla Hive:")
    spark.sql("""
        INSERT OVERWRITE TABLE clientes_hive
        SELECT * FROM clientes
    """)
    
    # Verificar datos en Hive
    print("3️⃣ Verificando datos en Hive:")
    spark.sql("SELECT COUNT(*) as total_registros FROM clientes_hive").show()
    spark.sql("SELECT * FROM clientes_hive LIMIT 5").show()
    
    # Mostrar tablas Hive
    print("4️⃣ Tablas disponibles en Hive:")
    spark.sql("SHOW TABLES").show()

def optimizacion_consultas(spark):
    """
    ⚡ Optimización de consultas
    """
    print("\n" + "="*60)
    print("⚡ OPTIMIZACIÓN DE CONSULTAS")
    print("="*60)
    
    # Habilitar cache
    print("1️⃣ Habilitando cache para optimización:")
    spark.sql("CACHE TABLE clientes")
    spark.sql("CACHE TABLE productos")
    spark.sql("CACHE TABLE ventas")
    
    # Ejecutar consulta compleja
    print("2️⃣ Ejecutando consulta compleja optimizada:")
    import time
    
    start_time = time.time()
    resultado = spark.sql("""
        WITH ventas_por_cliente AS (
            SELECT v.cliente_id, 
                   SUM(v.total) as gasto_total,
                   COUNT(v.venta_id) as total_compras
            FROM ventas v
            GROUP BY v.cliente_id
        ),
        ranking_clientes AS (
            SELECT c.nombre, c.ciudad, c.tipo_cliente,
                   vpc.gasto_total, vpc.total_compras,
                   RANK() OVER (ORDER BY vpc.gasto_total DESC) as ranking_gasto,
                   RANK() OVER (ORDER BY vpc.total_compras DESC) as ranking_compras
            FROM clientes c
            JOIN ventas_por_cliente vpc ON c.cliente_id = vpc.cliente_id
        )
        SELECT * FROM ranking_clientes
        WHERE ranking_gasto <= 5 OR ranking_compras <= 5
        ORDER BY gasto_total DESC
    """)
    
    resultado.show()
    end_time = time.time()
    
    print(f"⏱️ Tiempo de ejecución: {end_time - start_time:.3f} segundos")
    
    # Mostrar plan de ejecución
    print("3️⃣ Plan de ejecución de la consulta:")
    resultado.explain(True)

def main():
    """
    🎯 Función principal del tutorial
    """
    print("🗄️ SPARK TUTORIAL 03: SPARK SQL")
    print("="*60)
    
    try:
        # Crear SparkSession
        spark = crear_spark_session()
        
        # Crear datos de ejemplo
        df_clientes, df_productos, df_ventas = crear_datos_ejemplo(spark)
        
        # Crear vistas temporales
        crear_vistas_temporales(spark, df_clientes, df_productos, df_ventas)
        
        # Consultas SQL básicas
        consultas_sql_basicas(spark)
        
        # Consultas SQL avanzadas
        consultas_sql_avanzadas(spark)
        
        # Funciones SQL avanzadas
        funciones_sql_avanzadas(spark)
        
        # Integración con Hive
        integracion_hive(spark)
        
        # Optimización de consultas
        optimizacion_consultas(spark)
        
        print("\n" + "="*60)
        print("🎉 TUTORIAL COMPLETADO EXITOSAMENTE!")
        print("="*60)
        print("📚 Conceptos SQL aprendidos:")
        print("✅ Creación de vistas temporales")
        print("✅ Consultas SQL básicas y avanzadas")
        print("✅ Window Functions en SQL")
        print("✅ CTE (Common Table Expressions)")
        print("✅ Funciones SQL avanzadas")
        print("✅ Integración con Hive")
        print("✅ Optimización de consultas")
        print("✅ Plan de ejecución")
        
    except Exception as e:
        print(f"❌ Error en el tutorial: {str(e)}")
        import traceback
        traceback.print_exc()
    
    finally:
        # Cerrar SparkSession
        try:
            spark.stop()
            print("\n🔒 SparkSession cerrada correctamente")
        except:
            pass

if __name__ == "__main__":
    main()
