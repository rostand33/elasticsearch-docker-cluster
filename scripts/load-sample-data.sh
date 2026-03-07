#!/usr/bin/env bash

set -e

if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

echo "Creating test index..."
curl -u elastic:$ELASTIC_PASSWORD -X PUT http://localhost:9200/test-index

echo
echo "Adding a sample document..."
curl -u elastic:$ELASTIC_PASSWORD -X POST http://localhost:9200/test-index/_doc \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Elasticsearch Docker Project",
    "category": "devops",
    "created_at": "2026-03-07"
  }'

echo
echo "Sample data loaded."
