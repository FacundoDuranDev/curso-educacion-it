#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
📊 SPARK TUTORIAL 02: DATAFRAMES AVANZADOS
==========================================

🎯 OBJETIVO: Dominar operaciones avanzadas con DataFrames de Spark

📋 CONTENIDO:
- Transformaciones complejas
- Funciones de agregación
- Joins y operaciones relacionales
- Window Functions
- Optimización y caching

⚡ EJECUTAR: python 02_dataframes_avanzado.py
"""

from pyspark.sql import SparkSession
from pyspark.sql.functions import (
    col, when, lit, coalesce, regexp_replace, split, explode,
    count, sum as spark_sum, avg, max as spark_max, min as spark_min,
    row_number, rank, dense_rank, lag, lead, first, last,
    date_format, year, month, dayofmonth, datediff, current_date,
    collect_list, collect_set, array_contains, size, sort_array,
    struct, create_map, get_json_object, to_json
)
from pyspark.sql.window import Window
from pyspark.sql.types import StructType, StructField, StringType, IntegerType, DoubleType, DateType

def crear_spark_session():
    """
    🔧 Crear SparkSession optimizada para DataFrames
    """
    print("🚀 Creando SparkSession para DataFrames...")
    
    spark = SparkSession.builder \
        .appName("EducacionIT-Spark-DataFrames") \
        .master("spark://spark-master:7077") \
        .config("spark.executor.memory", "800m") \
        .config("spark.executor.cores", "1") \
        .config("spark.executor.instances", "2") \
        .config("spark.driver.memory", "1g") \
        .config("spark.sql.adaptive.enabled", "true") \
        .config("spark.sql.adaptive.coalescePartitions.enabled", "true") \
        .config("spark.serializer", "org.apache.spark.serializer.KryoSerializer") \
        .enableHiveSupport() \
        .getOrCreate()
    
    print("✅ SparkSession creada con optimizaciones")
    return spark

def crear_datos_ejemplo(spark):
    """
    📊 Crear DataFrames de ejemplo para el tutorial
    """
    print("\n" + "="*60)
    print("📊 CREANDO DATOS DE EJEMPLO")
    print("="*60)
    
    # DataFrame de empleados
    empleados_data = [
        (1, "Juan Pérez", "IT", 50000, "2020-01-15", "Madrid"),
        (2, "María García", "Marketing", 45000, "2019-03-20", "Barcelona"),
        (3, "Carlos López", "IT", 55000, "2021-06-10", "Madrid"),
        (4, "Ana Martínez", "HR", 40000, "2018-11-05", "Valencia"),
        (5, "Luis Rodríguez", "IT", 60000, "2017-09-12", "Sevilla"),
        (6, "Laura Sánchez", "Marketing", 48000, "2022-02-28", "Barcelona"),
        (7, "Pedro González", "Sales", 42000, "2020-07-15", "Madrid"),
        (8, "Carmen Ruiz", "IT", 52000, "2021-04-03", "Bilbao"),
        (9, "Miguel Torres", "HR", 38000, "2019-12-10", "Valencia"),
        (10, "Isabel Díaz", "Sales", 46000, "2020-08-22", "Sevilla")
    ]
    
    empleados_schema = StructType([
        StructField("id", IntegerType(), True),
        StructField("nombre", StringType(), True),
        StructField("departamento", StringType(), True),
        StructField("salario", IntegerType(), True),
        StructField("fecha_ingreso", StringType(), True),
        StructField("ciudad", StringType(), True)
    ])
    
    df_empleados = spark.createDataFrame(empleados_data, empleados_schema)
    df_empleados = df_empleados.withColumn("fecha_ingreso", col("fecha_ingreso").cast(DateType()))
    
    # DataFrame de ventas
    ventas_data = [
        (1, 1, "Producto A", 100.50, 5, "2024-01-15"),
        (2, 2, "Producto B", 200.75, 3, "2024-01-16"),
        (3, 1, "Producto C", 150.00, 4, "2024-01-17"),
        (4, 3, "Producto A", 100.50, 2, "2024-01-18"),
        (5, 4, "Producto B", 200.75, 1, "2024-01-19"),
        (6, 2, "Producto D", 300.25, 6, "2024-01-20"),
        (7, 5, "Producto C", 150.00, 3, "2024-01-21"),
        (8, 1, "Producto E", 250.00, 2, "2024-01-22"),
        (9, 3, "Producto A", 100.50, 7, "2024-01-23"),
        (10, 2, "Producto B", 200.75, 4, "2024-01-24")
    ]
    
    ventas_schema = StructType([
        StructField("venta_id", IntegerType(), True),
        StructField("empleado_id", IntegerType(), True),
        StructField("producto", StringType(), True),
        StructField("precio", DoubleType(), True),
        StructField("cantidad", IntegerType(), True),
        StructField("fecha", StringType(), True)
    ])
    
    df_ventas = spark.createDataFrame(ventas_data, ventas_schema)
    df_ventas = df_ventas.withColumn("fecha", col("fecha").cast(DateType()))
    df_ventas = df_ventas.withColumn("total", col("precio") * col("cantidad"))
    
    print("👥 DataFrame empleados:")
    df_empleados.show()
    
    print("💰 DataFrame ventas:")
    df_ventas.show()
    
    return df_empleados, df_ventas

def transformaciones_avanzadas(df_empleados):
    """
    🔄 Transformaciones avanzadas con DataFrames
    """
    print("\n" + "="*60)
    print("🔄 TRANSFORMACIONES AVANZADAS")
    print("="*60)
    
    # Agregar columnas calculadas
    print("📊 Agregando columnas calculadas:")
    df_transformado = df_empleados \
        .withColumn("años_antigüedad", 
                   datediff(current_date(), col("fecha_ingreso")) / 365) \
        .withColumn("salario_categoria", 
                   when(col("salario") >= 55000, "Alto")
                   .when(col("salario") >= 45000, "Medio")
                   .otherwise("Bajo")) \
        .withColumn("inicial_nombre", 
                   split(col("nombre"), " ")[0]) \
        .withColumn("ciudad_mayuscula", 
                   regexp_replace(col("ciudad"), "ñ", "n"))
    
    df_transformado.show()
    
    # Operaciones con strings
    print("\n🔤 Operaciones con strings:")
    df_strings = df_empleados \
        .withColumn("nombre_completo", col("nombre")) \
        .withColumn("nombre_parts", split(col("nombre"), " ")) \
        .withColumn("primer_nombre", split(col("nombre"), " ")[0]) \
        .withColumn("apellido", split(col("nombre"), " ")[1]) \
        .withColumn("nombre_length", size(split(col("nombre"), " ")))
    
    df_strings.select("nombre", "nombre_parts", "primer_nombre", "apellido", "nombre_length").show()
    
    # Filtros complejos
    print("\n🔍 Filtros complejos:")
    df_filtrado = df_empleados \
        .filter((col("departamento") == "IT") & (col("salario") > 50000)) \
        .filter(col("ciudad").isin(["Madrid", "Barcelona"])) \
        .filter(col("fecha_ingreso") >= "2020-01-01")
    
    print("Empleados IT con salario > 50000 en Madrid/Barcelona desde 2020:")
    df_filtrado.show()

def agregaciones_avanzadas(df_empleados, df_ventas):
    """
    📊 Agregaciones avanzadas
    """
    print("\n" + "="*60)
    print("📊 AGREGACIONES AVANZADAS")
    print("="*60)
    
    # Agregaciones por departamento
    print("📈 Estadísticas por departamento:")
    stats_departamento = df_empleados.groupBy("departamento").agg(
        count("*").alias("total_empleados"),
        spark_sum("salario").alias("salario_total"),
        avg("salario").alias("salario_promedio"),
        spark_max("salario").alias("salario_maximo"),
        spark_min("salario").alias("salario_minimo")
    ).orderBy("departamento")
    
    stats_departamento.show()
    
    # Agregaciones por ciudad
    print("\n🏙️ Estadísticas por ciudad:")
    stats_ciudad = df_empleados.groupBy("ciudad").agg(
        count("*").alias("empleados"),
        avg("salario").alias("salario_promedio")
    ).orderBy(col("salario_promedio").desc())
    
    stats_ciudad.show()
    
    # Agregaciones con condiciones
    print("\n🎯 Agregaciones con condiciones:")
    df_empleados.withColumn("salario_alto", when(col("salario") > 50000, 1).otherwise(0)) \
                .groupBy("departamento") \
                .agg(
                    count("*").alias("total"),
                    spark_sum("salario_alto").alias("salarios_altos"),
                    (spark_sum("salario_alto") / count("*") * 100).alias("porcentaje_salarios_altos")
                ).show()

def joins_y_relaciones(df_empleados, df_ventas):
    """
    🔗 Joins y operaciones relacionales
    """
    print("\n" + "="*60)
    print("🔗 JOINS Y OPERACIONES RELACIONALES")
    print("="*60)
    
    # Inner Join
    print("🔗 Inner Join - Empleados y sus ventas:")
    df_inner = df_empleados.join(df_ventas, 
                                df_empleados.id == df_ventas.empleado_id, 
                                "inner")
    df_inner.select("nombre", "departamento", "producto", "total").show()
    
    # Left Join
    print("\n⬅️ Left Join - Todos los empleados (incluso sin ventas):")
    df_left = df_empleados.join(df_ventas, 
                               df_empleados.id == df_ventas.empleado_id, 
                               "left")
    
    # Agregar columna para mostrar si tiene ventas
    df_left_show = df_left.withColumn("tiene_ventas", 
                                     when(col("venta_id").isNotNull(), "Sí")
                                     .otherwise("No")) \
                          .select("nombre", "departamento", "tiene_ventas") \
                          .distinct()
    df_left_show.show()
    
    # Agregaciones después del join
    print("\n📊 Ventas totales por empleado:")
    ventas_por_empleado = df_inner.groupBy("id", "nombre", "departamento").agg(
        count("venta_id").alias("total_ventas"),
        spark_sum("total").alias("ventas_totales"),
        avg("total").alias("venta_promedio")
    ).orderBy(col("ventas_totales").desc())
    
    ventas_por_empleado.show()
    
    # Join con agregaciones
    print("\n🏢 Ventas por departamento:")
    ventas_departamento = df_inner.groupBy("departamento").agg(
        count("venta_id").alias("total_ventas"),
        spark_sum("total").alias("ventas_totales"),
        avg("total").alias("venta_promedio"),
        countDistinct("id").alias("empleados_activos")
    ).orderBy(col("ventas_totales").desc())
    
    ventas_departamento.show()

def window_functions(df_empleados, df_ventas):
    """
    🪟 Window Functions
    """
    print("\n" + "="*60)
    print("🪟 WINDOW FUNCTIONS")
    print("="*60)
    
    # Ranking por departamento
    print("🏆 Ranking de empleados por salario dentro de cada departamento:")
    window_departamento = Window.partitionBy("departamento").orderBy(col("salario").desc())
    
    df_ranking = df_empleados.withColumn("rank_salario", rank().over(window_departamento)) \
                            .withColumn("dense_rank_salario", dense_rank().over(window_departamento)) \
                            .withColumn("row_number_salario", row_number().over(window_departamento))
    
    df_ranking.select("nombre", "departamento", "salario", 
                     "rank_salario", "dense_rank_salario", "row_number_salario").show()
    
    # Funciones de ventana con lag/lead
    print("\n📈 Comparación con empleado anterior (por salario):")
    window_salario = Window.orderBy(col("salario").desc())
    
    df_lag = df_empleados.withColumn("salario_anterior", 
                                    lag("salario", 1).over(window_salario)) \
                         .withColumn("diferencia_salario", 
                                    col("salario") - col("salario_anterior"))
    
    df_lag.select("nombre", "salario", "salario_anterior", "diferencia_salario").show()
    
    # Agregaciones con ventana
    print("\n📊 Salario promedio del departamento para cada empleado:")
    window_avg_dep = Window.partitionBy("departamento")
    
    df_avg_dep = df_empleados.withColumn("promedio_departamento", 
                                        avg("salario").over(window_avg_dep)) \
                             .withColumn("diferencia_promedio", 
                                        col("salario") - col("promedio_departamento"))
    
    df_avg_dep.select("nombre", "departamento", "salario", 
                     "promedio_departamento", "diferencia_promedio").show()

def optimizacion_y_caching(df_empleados, df_ventas):
    """
    ⚡ Optimización y caching
    """
    print("\n" + "="*60)
    print("⚡ OPTIMIZACIÓN Y CACHING")
    print("="*60)
    
    # Cachear DataFrame
    print("💾 Cacheando DataFrame de empleados...")
    df_empleados.cache()
    
    # Forzar evaluación del cache
    count_empleados = df_empleados.count()
    print(f"📊 Total de empleados en cache: {count_empleados}")
    
    # Persistir con nivel de almacenamiento
    print("💾 Persistiendo DataFrame de ventas en memoria y disco...")
    df_ventas.persist()
    
    # Múltiples operaciones para demostrar el beneficio del cache
    print("\n🔄 Ejecutando múltiples operaciones (cache debería acelerar):")
    
    # Primera operación (popula el cache)
    print("1️⃣ Primera operación:")
    start_time = time.time()
    df_empleados.groupBy("departamento").count().show()
    first_time = time.time() - start_time
    print(f"⏱️ Tiempo primera operación: {first_time:.3f}s")
    
    # Segunda operación (usa el cache)
    print("2️⃣ Segunda operación (usando cache):")
    start_time = time.time()
    df_empleados.groupBy("ciudad").count().show()
    second_time = time.time() - start_time
    print(f"⏱️ Tiempo segunda operación: {second_time:.3f}s")
    
    # Mostrar estadísticas de storage
    print("\n📊 Estadísticas de almacenamiento:")
    print(f"💾 Empleados en cache: {spark.catalog.isCached('empleados')}")
    print(f"💾 Ventas en cache: {spark.catalog.isCached('ventas')}")
    
    # Unpersist
    df_empleados.unpersist()
    df_ventas.unpersist()
    print("🗑️ Cache limpiado")

def main():
    """
    🎯 Función principal del tutorial
    """
    print("📊 SPARK TUTORIAL 02: DATAFRAMES AVANZADOS")
    print("="*60)
    
    try:
        # Crear SparkSession
        spark = crear_spark_session()
        
        # Crear datos de ejemplo
        df_empleados, df_ventas = crear_datos_ejemplo(spark)
        
        # Transformaciones avanzadas
        transformaciones_avanzadas(df_empleados)
        
        # Agregaciones avanzadas
        agregaciones_avanzadas(df_empleados, df_ventas)
        
        # Joins y relaciones
        joins_y_relaciones(df_empleados, df_ventas)
        
        # Window Functions
        window_functions(df_empleados, df_ventas)
        
        # Optimización y caching
        import time
        optimizacion_y_caching(df_empleados, df_ventas)
        
        print("\n" + "="*60)
        print("🎉 TUTORIAL COMPLETADO EXITOSAMENTE!")
        print("="*60)
        print("📚 Conceptos avanzados aprendidos:")
        print("✅ Transformaciones complejas")
        print("✅ Agregaciones avanzadas")
        print("✅ Joins y operaciones relacionales")
        print("✅ Window Functions")
        print("✅ Optimización y caching")
        print("✅ Manejo de tipos de datos")
        
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
