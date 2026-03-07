#!/usr/bin/env bash
set -e

if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

echo "Checking cluster health..."
curl -u elastic:$ELASTIC_PASSWORD http://localhost:9200/_cluster/health?pretty

echo
echo "Nodes:"
curl -u elastic:$ELASTIC_PASSWORD http://localhost:9200/_cat/nodes?v
