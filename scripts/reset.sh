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

echo "Cluster reset and restarted."
