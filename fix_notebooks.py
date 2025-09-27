#!/usr/bin/env python3
"""
Script para corregir la configuración de Spark en los notebooks
"""

import json
import os
import glob

def fix_spark_notebooks():
    """Corregir la configuración de Spark en todos los notebooks"""
    
    # Buscar todos los notebooks .ipynb
    notebooks = glob.glob("jupyter/notebook/spark-tutorials/**/*.ipynb", recursive=True)
    
    for notebook_path in notebooks:
        print(f"🔧 Procesando: {notebook_path}")
        
        # Leer el notebook
        with open(notebook_path, 'r', encoding='utf-8') as f:
            notebook = json.load(f)
        
        # Procesar cada celda
        for cell in notebook['cells']:
            if cell['cell_type'] == 'code' and 'source' in cell:
                source_lines = cell['source']
                
                # Buscar y reemplazar la función get_spark_master
                for i, line in enumerate(source_lines):
                    if "if 'jupyter' in hostname or 'master' in hostname:" in line:
                        source_lines[i] = "        if 'jupyter' in hostname or 'master' in hostname or 'jupyterlab' in hostname:\n"
                        print(f"  ✅ Corregida línea de detección de hostname")
                    elif "executors = status.getExecutorInfos()" in line:
                        # Reemplazar toda la celda problemática
                        cell['source'] = [
                            "# Información del cluster (versión corregida)\n",
                            "print(\"🔍 Información del SparkContext:\")\n",
                            "print(f\"  Versión de Spark: {spark.version}\")\n",
                            "print(f\"  App Name: {spark.sparkContext.appName}\")\n",
                            "print(f\"  App ID: {spark.sparkContext.applicationId}\")\n",
                            "print(f\"  Master URL: {spark.sparkContext.master}\")\n",
                            "print(f\"  Número de cores disponibles: {spark.sparkContext.defaultParallelism}\")\n",
                            "\n",
                            "# Información de ejecutores (método compatible)\n",
                            "try:\n",
                            "    status = spark.sparkContext.statusTracker()\n",
                            "    executors = status.getExecutorInfos()\n",
                            "    print(f\"\\n👥 Número de ejecutores: {len(executors)}\")\n",
                            "    print(\"\\n💾 Información de ejecutores:\")\n",
                            "    \n",
                            "    for i, executor in enumerate(executors, 1):\n",
                            "        print(f\"  {i}. ID: {executor.executorId}\")\n",
                            "        print(f\"     Host: {executor.executorHost}\")\n",
                            "        print(f\"     Cores: {executor.totalCores}\")\n",
                            "        print(f\"     Memoria máxima: {executor.maxMemory}\")\n",
                            "        print(f\"     Estado: {executor.isActive}\")\n",
                            "        print()\n",
                            "        \n",
                            "except AttributeError:\n",
                            "    print(\"\\n👥 Información de ejecutores (API moderna):\")\n",
                            "    print(f\"  Número de cores: {spark.sparkContext.defaultParallelism}\")\n",
                            "    print(f\"  Master: {spark.sparkContext.master}\")\n"
                        ]
                        print(f"  ✅ Corregida celda con getExecutorInfos()")
                        break
        
        # Guardar el notebook corregido
        with open(notebook_path, 'w', encoding='utf-8') as f:
            json.dump(notebook, f, indent=1, ensure_ascii=False)
        
        print(f"  💾 Guardado: {notebook_path}")

if __name__ == "__main__":
    fix_spark_notebooks()
    print("\n🎉 ¡Todos los notebooks han sido corregidos!")
