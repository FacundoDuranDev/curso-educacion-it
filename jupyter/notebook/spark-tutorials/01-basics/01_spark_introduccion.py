#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
🚀 SPARK TUTORIAL 01: INTRODUCCIÓN BÁSICA
==========================================

🎯 OBJETIVO: Aprender los conceptos fundamentales de Apache Spark

📋 CONTENIDO:
- ¿Qué es Apache Spark?
- Configuración de SparkSession
- Conceptos básicos: RDD, DataFrames, Datasets
- Primeras operaciones

⚡ EJECUTAR: python 01_spark_introduccion.py
"""

from pyspark.sql import SparkSession
from pyspark.sql.functions import col, count, sum as spark_sum
import os

def crear_spark_session():
    """
    🔧 Crear y configurar SparkSession para el curso
    """
    print("🚀 Creando SparkSession...")
    
    spark = SparkSession.builder \
        .appName("EducacionIT-Spark-Basics") \
        .master("spark://spark-master:7077") \
        .config("spark.executor.memory", "800m") \
        .config("spark.executor.cores", "1") \
        .config("spark.executor.instances", "2") \
        .config("spark.driver.memory", "1g") \
        .config("spark.driver.cores", "1") \
        .config("spark.sql.adaptive.enabled", "false") \
        .config("spark.sql.warehouse.dir", "/user/hive/warehouse") \
        .enableHiveSupport() \
        .getOrCreate()
    
    print("✅ SparkSession creada exitosamente")
    return spark

def mostrar_info_spark(spark):
    """
    📊 Mostrar información del cluster Spark
    """
    print("\n" + "="*60)
    print("📊 INFORMACIÓN DEL CLUSTER SPARK")
    print("="*60)
    
    # Información de la aplicación
    print(f"🔧 Nombre de la aplicación: {spark.sparkContext.appName}")
    print(f"🆔 ID de la aplicación: {spark.sparkContext.applicationId}")
    print(f"🌐 URL de la UI: {spark.sparkContext.uiWebUrl}")
    
    # Información de la versión
    print(f"📦 Versión de Spark: {spark.version}")
    print(f"🐍 Versión de Python: {spark.sparkContext.pythonVer}")
    
    # Información del cluster
    print(f"👥 Número de ejecutores: {len(spark.sparkContext.statusTracker().getExecutorInfos())}")
    
    # Memoria disponible
    status = spark.sparkContext.statusTracker()
    for executor in status.getExecutorInfos():
        print(f"💾 Memoria del ejecutor {executor.executorId}: {executor.maxMemory} bytes")

def crear_rdd_basico(spark):
    """
    📚 Crear y operar con RDD básico
    """
    print("\n" + "="*60)
    print("📚 TRABAJANDO CON RDDS (Resilient Distributed Datasets)")
    print("="*60)
    
    # Crear RDD desde una lista
    numeros = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    rdd_numeros = spark.sparkContext.parallelize(numeros)
    
    print(f"🔢 RDD creado con {rdd_numeros.count()} elementos")
    
    # Operaciones básicas
    print(f"➕ Suma total: {rdd_numeros.sum()}")
    print(f"📊 Promedio: {rdd_numeros.mean():.2f}")
    print(f"📈 Máximo: {rdd_numeros.max()}")
    print(f"📉 Mínimo: {rdd_numeros.min()}")
    
    # Transformaciones
    rdd_pares = rdd_numeros.filter(lambda x: x % 2 == 0)
    print(f"🔢 Números pares: {rdd_pares.collect()}")
    
    rdd_cuadrados = rdd_numeros.map(lambda x: x ** 2)
    print(f"📐 Cuadrados: {rdd_cuadrados.collect()}")

def crear_dataframe_basico(spark):
    """
    📊 Crear y operar con DataFrame básico
    """
    print("\n" + "="*60)
    print("📊 TRABAJANDO CON DATAFRAMES")
    print("="*60)
    
    # Crear DataFrame desde datos de ejemplo
    datos_empleados = [
        ("Juan", "IT", 50000, 25),
        ("María", "Marketing", 45000, 30),
        ("Carlos", "IT", 55000, 28),
        ("Ana", "HR", 40000, 35),
        ("Luis", "IT", 60000, 32),
        ("Laura", "Marketing", 48000, 27)
    ]
    
    columnas = ["nombre", "departamento", "salario", "edad"]
    df_empleados = spark.createDataFrame(datos_empleados, columnas)
    
    print("👥 DataFrame de empleados creado:")
    df_empleados.show()
    
    print("📋 Schema del DataFrame:")
    df_empleados.printSchema()
    
    # Operaciones básicas
    print("\n🔍 EMPLEADOS DEL DEPARTAMENTO IT:")
    df_empleados.filter(col("departamento") == "IT").show()
    
    print("\n💰 EMPLEADOS CON SALARIO > 50000:")
    df_empleados.filter(col("salario") > 50000).show()
    
    print("\n📊 ESTADÍSTICAS POR DEPARTAMENTO:")
    df_empleados.groupBy("departamento").agg(
        count("nombre").alias("total_empleados"),
        spark_sum("salario").alias("salario_total"),
        spark_sum("edad").alias("edad_total")
    ).show()
    
    return df_empleados

def trabajar_con_archivos(spark):
    """
    📁 Trabajar con archivos de datos
    """
    print("\n" + "="*60)
    print("📁 TRABAJANDO CON ARCHIVOS")
    print("="*60)
    
    # Verificar si hay archivos CSV disponibles
    archivos_csv = [
        "/opt/spark/data/ventas.csv",
        "/user/hive/warehouse/ventas",
        "data/etapa1/Venta.csv"
    ]
    
    for archivo in archivos_csv:
        try:
            if archivo.endswith('.csv'):
                df = spark.read.option("header", "true").csv(archivo)
                print(f"✅ Archivo encontrado: {archivo}")
                print(f"📊 Registros: {df.count()}")
                print("🔍 Primeras 5 filas:")
                df.show(5)
                break
        except Exception as e:
            print(f"❌ No se pudo leer {archivo}: {str(e)[:100]}...")
    
    # Si no hay archivos, crear uno de ejemplo
    else:
        print("📝 Creando archivo de ejemplo...")
        datos_ventas = [
            ("2024-01-01", "Producto A", 100.50, 5),
            ("2024-01-02", "Producto B", 200.75, 3),
            ("2024-01-03", "Producto A", 100.50, 2),
            ("2024-01-04", "Producto C", 150.00, 4),
            ("2024-01-05", "Producto B", 200.75, 1)
        ]
        
        columnas_ventas = ["fecha", "producto", "precio", "cantidad"]
        df_ventas = spark.createDataFrame(datos_ventas, columnas_ventas)
        
        print("📊 DataFrame de ventas creado:")
        df_ventas.show()
        
        # Guardar como CSV
        df_ventas.coalesce(1).write.mode("overwrite").option("header", "true").csv("/tmp/ventas_ejemplo")
        print("💾 Archivo guardado en /tmp/ventas_ejemplo")

def demostrar_lazy_evaluation(spark):
    """
    ⚡ Demostrar Lazy Evaluation de Spark
    """
    print("\n" + "="*60)
    print("⚡ LAZY EVALUATION EN SPARK")
    print("="*60)
    
    # Crear DataFrame
    numeros = list(range(1, 1001))
    df_numeros = spark.createDataFrame([(x,) for x in numeros], ["numero"])
    
    print("🔢 DataFrame con 1000 números creado")
    
    # Transformaciones (lazy)
    df_transformado = df_numeros \
        .filter(col("numero") % 2 == 0) \
        .filter(col("numero") > 100) \
        .filter(col("numero") < 500) \
        .select((col("numero") * 2).alias("doble"))
    
    print("🔄 Transformaciones aplicadas (sin ejecutar)")
    print("⚡ Las transformaciones son 'lazy' - no se ejecutan hasta ahora")
    
    # Acción (triggers execution)
    print("🚀 Ejecutando acción - esto dispara el procesamiento...")
    resultado = df_transformado.collect()
    
    print(f"✅ Resultado: {len(resultado)} elementos")
    print(f"📊 Primeros 10: {[r.doble for r in resultado[:10]]}")

def main():
    """
    🎯 Función principal del tutorial
    """
    print("🚀 SPARK TUTORIAL 01: INTRODUCCIÓN BÁSICA")
    print("="*60)
    
    try:
        # Crear SparkSession
        spark = crear_spark_session()
        
        # Mostrar información
        mostrar_info_spark(spark)
        
        # Tutorial con RDDs
        crear_rdd_basico(spark)
        
        # Tutorial con DataFrames
        df_empleados = crear_dataframe_basico(spark)
        
        # Trabajar con archivos
        trabajar_con_archivos(spark)
        
        # Lazy Evaluation
        demostrar_lazy_evaluation(spark)
        
        print("\n" + "="*60)
        print("🎉 TUTORIAL COMPLETADO EXITOSAMENTE!")
        print("="*60)
        print("📚 Conceptos aprendidos:")
        print("✅ SparkSession y configuración")
        print("✅ RDDs básicos")
        print("✅ DataFrames básicos")
        print("✅ Operaciones de transformación y acción")
        print("✅ Lazy evaluation")
        print("✅ Trabajo con archivos")
        
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
