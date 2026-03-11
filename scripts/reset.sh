#!/usr/bin/env bash

set -e
echo "WARNING: This will remove containers, networks, and Elasticsearch volumes,and generated certificates."
read -p "Are you sure you want to continue? (y/N): " confirm

if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "Reset cancelled."
  exit 0
fi

echo "Removing existing cluster..."
docker compose down -v --remove-orphans

echo "Starting fresh cluster..."
docker compose up -d

echo "Waiting for Elasticsearch to start..."
sleep 20

echo "Creating indices..."
./scripts/create-indexes.sh

echo "Loading sample data..."
./scripts/load-sample-data.sh

echo "Checking indexed documents..."

curl -s localhost:9200/users/_count
curl -s localhost:9200/products/_count
curl -s localhost:9200/orders/_count
curl -s localhost:9200/app-logs/_count
curl -s localhost:9200/security-logs/_count

echo "Cluster reset and data reloaded successfully."
