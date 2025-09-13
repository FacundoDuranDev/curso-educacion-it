# Dockerfile para JupyterLab con Spark + Hive preconfigurado
FROM hadoop-hive-spark-base

# Información del mantenedor
LABEL maintainer="EducacionIT"
LABEL description="JupyterLab con Spark 3.5.3 + Hive preconfigurado"

# Cambiar al usuario jupyter
USER jupyter

# Instalar JupyterLab y dependencias Python
RUN pip install --user --no-cache-dir \
    jupyterlab==4.4.7 \
    notebook==7.4.5 \
    ipykernel==6.30.1 \
    findspark \
    pandas \
    matplotlib \
    seaborn \
    plotly \
    numpy \
    scipy

# Agregar el directorio local/bin al PATH
ENV PATH="/home/jupyter/.local/bin:$PATH"

# Variables de entorno para PySpark
ENV PYSPARK_PYTHON=python3
ENV PYSPARK_DRIVER_PYTHON=python3
ENV SPARK_HOME=/opt/spark
ENV PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.9.7-src.zip:$PYTHONPATH

# Crear directorio para notebooks
RUN mkdir -p /home/jupyter/notebook

# Crear directorio de configuración de Jupyter
RUN mkdir -p /home/jupyter/.jupyter

# Crear archivo de configuración de JupyterLab
RUN echo "c.ServerApp.ip = '0.0.0.0'" > /home/jupyter/.jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.port = 8888" >> /home/jupyter/.jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.token = ''" >> /home/jupyter/.jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.password = ''" >> /home/jupyter/.jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.allow_origin = '*'" >> /home/jupyter/.jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.root_dir = '/home/jupyter/notebook'" >> /home/jupyter/.jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.allow_root = True" >> /home/jupyter/.jupyter/jupyter_lab_config.py

# Exponer puerto 8888 para JupyterLab
EXPOSE 8888

# Comando por defecto para iniciar JupyterLab
CMD ["jupyter", "lab", "--config=/home/jupyter/.jupyter/jupyter_lab_config.py"]
