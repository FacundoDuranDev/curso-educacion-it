.PHONY: all clean

all:
	docker build -t hadoop-hive-spark-base ./base
	docker build -t hadoop-hive-spark-master ./master
	docker build -t hadoop-hive-spark-worker ./worker
	docker build -t hadoop-hive-spark-history ./history
	docker build -t hadoop-hive-spark-jupyter ./jupyter

clean:
	docker rmi hadoop-hive-spark-base hadoop-hive-spark-master hadoop-hive-spark-worker hadoop-hive-spark-history hadoop-hive-spark-jupyter || true

up:
	docker-compose up -d

down:
	docker-compose down

logs:
	docker-compose logs -f

status:
	docker-compose ps
