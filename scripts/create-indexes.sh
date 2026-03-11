#!/usr/bin/env bash

set -e

ELASTIC_URL="${ELASTIC_URL:-https://localhost:9200}"
ELASTIC_USER="${ELASTIC_USER:-elastic}"
ELASTIC_PASSWORD="${ELASTIC_PASSWORD:-changeme}"
CURL_TLS_OPTION="${CURL_TLS_OPTION:--k}"

INDEXES=("users" "products" "orders" "app-logs" "security-logs")

echo "Checking Elasticsearch availability..."
curl -s $CURL_TLS_OPTION -u "$ELASTIC_USER:$ELASTIC_PASSWORD" "$ELASTIC_URL" > /dev/null

for index in "${INDEXES[@]}"; do
  echo "Creating index: $index"
  curl -s $CURL_TLS_OPTION -X PUT "$ELASTIC_URL/$index" \
    -u "$ELASTIC_USER:$ELASTIC_PASSWORD" \
    -H "Content-Type: application/json" \
    -d @"mappings/$index.json"
  echo
done

echo "Indices created:"
curl -s $CURL_TLS_OPTION -u "$ELASTIC_USER:$ELASTIC_PASSWORD" "$ELASTIC_URL/_cat/indices?v"
