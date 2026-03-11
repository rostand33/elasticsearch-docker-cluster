#!/usr/bin/env bash

set -e

# ==========================================
# Script: load-sample-data.sh
# Description: Bulk import sample data into
# Elasticsearch indices
# ==========================================

ELASTIC_URL="${ELASTIC_URL:-https://localhost:9200}"
ELASTIC_USER="${ELASTIC_USER:-elastic}"
ELASTIC_PASSWORD="${ELASTIC_PASSWORD:-changeme}"

# Pour TLS local auto-signé, garder -k.
# Si tu utilises un vrai CA, remplace par:
# CURL_TLS_OPTION="--cacert config/certs/ca/ca.crt"
CURL_TLS_OPTION="${CURL_TLS_OPTION:--k}"

declare -A DATA_FILES=(
  ["users"]="data/users.ndjson"
  ["products"]="data/products.ndjson"
  ["orders"]="data/orders.ndjson"
  ["app-logs"]="data/app-logs.ndjson"
  ["security-logs"]="data/security-logs.ndjson"
)

INDEXES=("users" "products" "orders" "app-logs" "security-logs")

echo "Checking Elasticsearch connection..."
curl -s $CURL_TLS_OPTION -u "$ELASTIC_USER:$ELASTIC_PASSWORD" \
  "$ELASTIC_URL" > /dev/null

echo "Starting bulk ingestion..."
TOTAL_SUCCESS=0

for index in "${INDEXES[@]}"; do
  file="${DATA_FILES[$index]}"

  if [[ ! -f "$file" ]]; then
    echo "File not found: $file"
    exit 1
  fi

  echo
  echo "Importing $index from $file ..."

  RESPONSE=$(curl -s $CURL_TLS_OPTION \
    -u "$ELASTIC_USER:$ELASTIC_PASSWORD" \
    -X POST "$ELASTIC_URL/_bulk" \
    -H "Content-Type: application/x-ndjson" \
    --data-binary @"$file")

  if echo "$RESPONSE" | grep -q '"errors":true'; then
    echo "Bulk import failed for index: $index"
    echo "$RESPONSE"
    exit 1
  fi

  SUCCESS_COUNT=$(echo "$RESPONSE" | grep -o '"result":"created"\|"result":"updated"' | wc -l | tr -d ' ')
  TOTAL_SUCCESS=$((TOTAL_SUCCESS + SUCCESS_COUNT))

  echo "Successfully indexed in $index: $SUCCESS_COUNT documents"
done

echo
echo "Verifying document counts..."
for index in "${INDEXES[@]}"; do
  COUNT=$(curl -s $CURL_TLS_OPTION \
    -u "$ELASTIC_USER:$ELASTIC_PASSWORD" \
    "$ELASTIC_URL/$index/_count" \
    | grep -o '"count":[0-9]*' | cut -d: -f2)

  echo "$index -> $COUNT documents"
done

echo
echo "Total successfully indexed documents: $TOTAL_SUCCESS"
echo "Bulk ingestion completed successfully."
