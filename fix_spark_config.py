#!/usr/bin/env python3
"""
Script para optimizar la configuración de Spark en los notebooks
"""

import json
import os
import glob

def optimize_spark_config():
    """Optimizar la configuración de Spark para usar menos recursos"""
    
    # Buscar todos los notebooks .ipynb
    notebooks = glob.glob("jupyter/notebook/spark-tutorials/**/*.ipynb", recursive=True)
    
    for notebook_path in notebooks:
        print(f"🔧 Optimizando: {notebook_path}")
        
        # Leer el notebook
        with open(notebook_path, 'r', encoding='utf-8') as f:
            notebook = json.load(f)
        
        # Procesar cada celda
        for cell in notebook['cells']:
            if cell['cell_type'] == 'code' and 'source' in cell:
                source_lines = cell['source']
                
                # Buscar y reemplazar la configuración de Spark
                for i, line in enumerate(source_lines):
                    if ".config(\"spark.executor.memory\", \"800m\")" in line:
                        source_lines[i] = "    .config(\"spark.executor.memory\", \"512m\")\n"
                        print(f"  ✅ Reducida memoria de ejecutor a 512m")
                    elif ".config(\"spark.executor.cores\", \"1\")" in line:
                        source_lines[i] = "    .config(\"spark.executor.cores\", \"1\")\n"
                        print(f"  ✅ Cores por ejecutor: 1")
                    elif ".config(\"spark.executor.instances\", \"2\")" in line:
                        source_lines[i] = "    .config(\"spark.executor.instances\", \"1\")\n"
                        print(f"  ✅ Reducidas instancias de ejecutor a 1")
                    elif ".config(\"spark.driver.memory\", \"1g\")" in line:
                        source_lines[i] = "    .config(\"spark.driver.memory\", \"512m\")\n"
                        print(f"  ✅ Reducida memoria del driver a 512m")
        
        # Guardar el notebook optimizado
        with open(notebook_path, 'w', encoding='utf-8') as f:
            json.dump(notebook, f, indent=1, ensure_ascii=False)
        
        print(f"  💾 Guardado: {notebook_path}")

if __name__ == "__main__":
    optimize_spark_config()
    print("\n🎉 ¡Configuración de Spark optimizada!")
