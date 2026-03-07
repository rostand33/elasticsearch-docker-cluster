#!/usr/bin/env bash

set -e

echo "Stopping Elasticsearch cluster..."

docker compose down

echo "Containers status:"
docker ps

echo "Cluster stopped."
