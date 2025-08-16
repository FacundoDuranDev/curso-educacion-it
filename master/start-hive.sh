#!/bin/bash

# Start Hive Services Script
set -e

echo "Starting Hive services..."

# Source environment variables
source /opt/hive/conf/hive-env.sh

# Wait for metastore to be ready
echo "Waiting for metastore to be ready..."
until nc -z localhost 9083; do
    echo "Metastore not ready, waiting..."
    sleep 2
done
echo "Metastore is ready!"

# Start Hive Metastore if not running
if ! pgrep -f "hive-metastore" > /dev/null; then
    echo "Starting Hive Metastore..."
    hive --service metastore &
    sleep 10
else
    echo "Hive Metastore already running"
fi

# Wait for metastore to be fully initialized
echo "Waiting for metastore to be fully initialized..."
sleep 15

# Start HiveServer2 if not running
if ! pgrep -f "hiveserver2" > /dev/null; then
    echo "Starting HiveServer2..."
    hiveserver2 &
    sleep 15
else
    echo "HiveServer2 already running"
fi

# Verify HiveServer2 is listening
echo "Verifying HiveServer2 is listening on port 10000..."
if netstat -tlnp | grep ":10000" > /dev/null; then
    echo "✅ HiveServer2 is running and listening on port 10000"
else
    echo "❌ HiveServer2 is not listening on port 10000"
    echo "Checking HiveServer2 logs..."
    ps aux | grep hiveserver2
fi

echo "Hive services startup complete!"
