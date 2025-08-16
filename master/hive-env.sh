#!/bin/bash

# Hive Environment Configuration
export HADOOP_HOME=/opt/hadoop
export HIVE_HOME=/opt/hive
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# Hive Metastore Configuration
export HIVE_METASTORE_OPTS="-Xmx512m -XX:MaxPermSize=256m"

# HiveServer2 Configuration
export HIVE_SERVER2_OPTS="-Xmx1g -XX:MaxPermSize=512m"

# Hive Client Configuration
export HADOOP_OPTS="$HADOOP_OPTS -XX:NewRatio=12 -Xms10m -XX:MaxHeapFreeRatio=40 -XX:MinHeapFreeRatio=15 -XX:+UseParNewGC -XX:-UseGCOverheadLimit"

# Hive Heap Size
export HADOOP_HEAPSIZE=1024

# Hive Configuration Directory
export HIVE_CONF_DIR=/opt/hive/conf

# Hive Logging
export HADOOP_ROOT_LOGGER=INFO,console
export HADOOP_ROOT_LOGGER=INFO,console

# Hive on Spark Configuration
export HADOOP_CLASSPATH=$HADOOP_CLASSPATH:$HIVE_HOME/lib/*

# Set permissions for Hive
export HADOOP_USER_NAME=jupyter
