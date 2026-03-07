#!/usr/bin/env bash

#call all Varible's .env
set -e

if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

echo "Starting Elasticsearch cluster..."
docker compose up -d
docker compose ps

echo "Waiting a few seconds for Elasticsearch to start..."
sleep 15

echo "Cluster health:"
curl -u elastic:$ELASTIC_PASSWORD http://localhost:9200/_cluster/health?pretty
