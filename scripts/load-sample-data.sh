#!/usr/bin/env bash

# 1. Wir setzen die URL, falls sie nicht definiert ist
ELASTIC_URL="http://localhost:9200"
ELASTIC_USER="elastic"
ELASTIC_PASSWORD="Rostand26"  # Ersetze dies durch eine Variable, wenn du möchtest

# 2. Überprüfen, ob das Verzeichnis data existiert
if [ ! -d "data" ]; then
  echo "Fehler: Das Verzeichnis data/ wurde nicht gefunden (aktueller Pfad: $(pwd))"
  exit 1
fi

TOTAL_SUCCESS=0
INDEXES=("users" "products" "orders" "app-logs" "security-logs")

for index in "${INDEXES[@]}"; do
  file="data/${index}.ndjson"

  if [ ! -f "$file" ]; then
    echo "Datei nicht gefunden: $file"
    continue
  fi

  echo "Importing $index from $file ..."

  # Ausführung des CURL-Befehls zur Datenübertragung an Elasticsearch
  RESPONSE=$(curl -s -u "$ELASTIC_USER:$ELASTIC_PASSWORD" \
    -X POST "$ELASTIC_URL/_bulk" \
    -H "Content-Type: application/x-ndjson" \
    --data-binary @"$file")

  # Robustes Zählen der erfolgreich indizierten Dokumente
  # Wir suchen nach Statuscodes 200 oder 201 im JSON-Response
  SUCCESS_COUNT=$(echo "$RESPONSE" | grep -oE '"status":(200|201)' | wc -l)
  TOTAL_SUCCESS=$((TOTAL_SUCCESS + SUCCESS_COUNT))

  echo "Successfully indexed in $index: $SUCCESS_COUNT documents"
done

# Kurze Pause, damit Elasticsearch Zeit hat, die Indizes zu aktualisieren
  echo "Waiting for refresh..."
sleep 2

  echo "Verifying counts..."

# Wir definieren die Liste der Indizes erneut, um sicherzugehen
CHECK_INDEXES=("users" "products" "orders" "app-logs" "security-logs")

for idx in "${CHECK_INDEXES[@]}"; do

  # Verwendung der Elasticsearch _count API
  FINAL_COUNT=$(curl -s -u "$ELASTIC_USER:$ELASTIC_PASSWORD" "$ELASTIC_URL/$idx/_count" \
    | grep -oE '"count":[0-9]+' | cut -d: -f2)

  echo "$idx -> ${FINAL_COUNT:-0} documents found in cluster"
done

echo
echo " Total successfully indexed: $TOTAL_SUCCESS documents"
echo "Ingestion process complete."
