.PHONY: help up down status build clean

# Comando por defecto - construir Y levantar todo automáticamente
all: build up

# Construir todas las imágenes
build:
	@echo "🔨 Construyendo imágenes Docker..."
	docker build -t hadoop-hive-spark-base ./base
	docker build -t hadoop-hive-spark-master ./master
	docker build -t hadoop-hive-spark-worker ./worker
	docker build -t hadoop-hive-spark-history ./history
	docker build -t hadoop-hive-spark-jupyter ./jupyter
	docker build -t hadoop-hive-spark-jupyterlab ./jupyterlab
	@echo "✅ Imágenes construidas correctamente"

# Levantar todo el entorno
up:
	@echo "🚀 Levantando todo el entorno..."
	docker-compose up -d
	@echo "⏳ Esperando a que los servicios estén listos..."
	@sleep 60
	@echo "🔍 Verificando estado de los servicios..."
	@make status
	@echo ""
	@echo "🎉 ¡Entorno completamente instalado y funcionando!"
	@echo "📊 Servicios disponibles:"
	@echo "   • PostgreSQL: localhost:5432 (admin/admin123) - Base de datos: educacionit"
	@echo "   • HDFS Web UI: http://localhost:9870"
	@echo "   • Spark Master: http://localhost:8080"
	@echo "   • Jupyter Lab: http://localhost:8888"

# Detener todo
down:
	@echo "🛑 Deteniendo todo el entorno..."
	docker-compose down
	@echo "✅ Entorno detenido"

# Ver estado
status:
	@echo "📊 Estado de los servicios:"
	docker-compose ps

# Limpiar imágenes Docker
clean:
	@echo "🧹 Limpiando imágenes Docker..."
	docker rmi hadoop-hive-spark-base hadoop-hive-spark-master hadoop-hive-spark-worker hadoop-hive-spark-history hadoop-hive-spark-jupyter || true
	@echo "✅ Imágenes limpiadas"

# Mostrar ayuda
help:
	@echo "🚀 Comandos disponibles para el Curso Data Engineering:"
	@echo ""
	@echo "make        - INSTALAR TODO (construir + levantar) - RECOMENDADO"
	@echo "make build  - Solo construir imágenes Docker"
	@echo "make up     - Solo levantar entorno (si ya construiste)"
	@echo "make down   - Detener todo el entorno"
	@echo "make status - Ver estado de los servicios"
	@echo "make clean  - Limpiar imágenes Docker"
	@echo "make help   - Mostrar esta ayuda"
	@echo ""
	@echo "💡 Para estudiantes: SOLO usa 'make' y listo!"
	@echo ""
	@echo "⚠️  IMPORTANTE:"
	@echo "   • PostgreSQL se levanta automáticamente"
	@echo "   • Para tener datos en la base 'educacionit', sigue GUIA_INSTALACION_POSTGRESQL.md"
	@echo "   • O usa 'make clean' para limpiar y reconstruir desde cero"
