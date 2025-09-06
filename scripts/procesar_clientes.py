#!/usr/bin/env python3
"""
Script para procesar datos de clientes y subirlos a HDFS
Permite agregar nuevos clientes y modificar existentes
"""

import pandas as pd
import os
from datetime import datetime

def procesar_nuevos_clientes():
    """Procesa el archivo de nuevos clientes"""
    print("📋 Procesando nuevos clientes...")
    
    # Leer archivo de nuevos clientes
    df_nuevos = pd.read_csv('data/nuevos_clientes.csv', sep=';')
    
    print(f"✅ Leídos {len(df_nuevos)} nuevos clientes")
    print("📊 Muestra de datos:")
    print(df_nuevos.head(3))
    
    return df_nuevos

def procesar_modificaciones():
    """Procesa el archivo de modificaciones"""
    print("\n📋 Procesando modificaciones de clientes...")
    
    # Leer archivo de modificaciones
    df_modificaciones = pd.read_csv('data/modificaciones_clientes.csv', sep=';')
    
    print(f"✅ Leídas {len(df_modificaciones)} modificaciones")
    print("📊 Muestra de datos:")
    print(df_modificaciones.head(3))
    
    return df_modificaciones

def validar_datos(df):
    """Valida que los datos tengan el formato correcto"""
    print("\n🔍 Validando datos...")
    
    # Verificar columnas requeridas
    columnas_requeridas = [
        'ID', 'Provincia', 'Nombre_y_Apellido', 'Domicilio', 
        'Telefono', 'Edad', 'Localidad', 'X', 'Y',
        'Fecha_Alta', 'Usuario_Alta', 'Fecha_Ultima_Modificacion',
        'Usuario_Ultima_Modificacion', 'Marca_Baja', 'col10'
    ]
    
    for col in columnas_requeridas:
        if col not in df.columns:
            print(f"❌ Columna faltante: {col}")
            return False
    
    # Verificar que no haya IDs duplicados
    if df['ID'].duplicated().any():
        print("❌ Se encontraron IDs duplicados")
        return False
    
    # Verificar rangos de edad
    if (df['Edad'] < 0).any() or (df['Edad'] > 120).any():
        print("❌ Edades fuera del rango válido (0-120)")
        return False
    
    print("✅ Datos validados correctamente")
    return True

def generar_archivo_hdfs(df, nombre_archivo):
    """Genera archivo para subir a HDFS"""
    print(f"\n📤 Generando archivo para HDFS: {nombre_archivo}")
    
    # Crear directorio de salida si no existe
    os.makedirs('output', exist_ok=True)
    
    # Guardar archivo
    ruta_archivo = f'output/{nombre_archivo}'
    df.to_csv(ruta_archivo, sep=';', index=False)
    
    print(f"✅ Archivo generado: {ruta_archivo}")
    return ruta_archivo

def main():
    """Función principal"""
    print("=== PROCESADOR DE DATOS DE CLIENTES ===")
    print(f"📅 Fecha: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    
    try:
        # Procesar nuevos clientes
        df_nuevos = procesar_nuevos_clientes()
        if validar_datos(df_nuevos):
            generar_archivo_hdfs(df_nuevos, 'nuevos_clientes_hdfs.csv')
        
        # Procesar modificaciones
        df_modificaciones = procesar_modificaciones()
        if validar_datos(df_modificaciones):
            generar_archivo_hdfs(df_modificaciones, 'modificaciones_clientes_hdfs.csv')
        
        print("\n🎯 PROCESAMIENTO COMPLETADO")
        print("📁 Archivos generados en el directorio 'output/'")
        print("📋 Próximos pasos:")
        print("   1. Subir archivos a HDFS")
        print("   2. Procesar con Hive/Spark")
        print("   3. Aplicar triggers de auditoría")
        
    except Exception as e:
        print(f"❌ Error durante el procesamiento: {e}")

if __name__ == "__main__":
    main()
