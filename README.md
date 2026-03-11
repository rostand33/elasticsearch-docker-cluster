# Elasticsearch Docker Cluster

This project provides a simple Elasticsearch cluster running with Docker Compose.
It allows developers to quickly start a multi-node Elasticsearch environment for testing, development, and learning purposes.

---

# Project Overview

This repository demonstrates how to deploy an Elasticsearch cluster using Docker.

The project includes:

* Elasticsearch nodes running in Docker containers
* Kibana for visualization
* Docker Compose for orchestration
* Scripts to manage the cluster lifecycle
* Example data loading

---

# Security

This project can run with Elasticsearch security enabled.

For multi-node clusters, transport layer TLS is required.
Certificates are generated automatically by the `setup` service and shared with the Elasticsearch nodes through a Docker volume.

Secrets such as passwords are not stored in the repository.

Environment variables are defined in:

```
.env
```

A template is provided:

```
.env.example
```

# Architecture

Example cluster architecture:

Elasticsearch Cluster

* es01 (master node)
* es02 (master node)
* es03 (master node)

All nodes communicate through an internal Docker network.

---

# Prerequisites

Before running this project, make sure you have installed:

* Docker
* Docker Compose

Check installation:

```
docker --version
docker compose version
```

---

# Project Structure

```
elasticsearch-docker-cluster
|
|-- docker-compose.yml
|-- README.md
|-- .env.example
|-- .gitignore
|
|-- scripts
|   |-- start-cluster.sh
|   |-- stop-cluster.sh
|   |-- check-cluster.sh
|   |-- reset.sh
|   |-- load-sample-data.sh
|   |-- create-indexes.sh
|   
|-- config
|
|-- mappings/
|   |-- users.json
|   |-- products.json
|   |-- orders.json
|   |-- app-logs.json
|   |-- security-logs.json
|
|-- data/
|   |-- users.ndjson
|   |-- products.ndjson
|   |-- orders.ndjson
|   |-- app-logs.ndjson
|   |-- security-logs.ndjson


```

---

# Setup

Clone the repository:

```
git clone https://github.com/YOUR_USERNAME/elasticsearch-docker-cluster.git
cd elasticsearch-docker-cluster
```

Create your environment configuration file:

```
cp .env.example .env
```

Edit the configuration:

```
nano .env
```

Example configuration:

```
CLUSTER_NAME=es-docker-cluster
ES_PORT=9200
KIBANA_PORT=5601
ELASTIC_PASSWORD=your_password
STACK_VERSION=8.12.2
```

---

# Start the Cluster

Start Elasticsearch and Kibana:

```
./scripts/start.sh
```

You can also start it manually:

```
docker compose up -d
```

---

# Initialize Indices

Run:

```
./scripts/create_indices.sh
```
This will ensure your "armoire" (the index) is perfectly built and labeled before you begin injecting your data.

---
# Check Cluster Status

Run:

```
./scripts/check-cluster.sh
```

This will display:

* cluster health
* active nodes

You can also test manually:

```
curl -u elastic:YOUR_PASSWORD http://localhost:9200/_cluster/health?pretty
```

---

# Access Elasticsearch

Open:

```
http://localhost:9200
```

Example request:

```
curl -u elastic:YOUR_PASSWORD http://localhost:9200
```

---

# Access Kibana

Open your browser:

```
http://localhost:5601
```

Login with:

```
username: elastic
password: YOUR_PASSWORD
```

---

# Load Sample Data

To populate your indices with initial data, run the following command. 
It uses the Elasticsearch **_bulk API** to efficiently load all files from the `/data` folder:

```
./scripts/load-sample-data.sh
```
The ingestion script:

* Loads all `.ndjson` files from the `data/` directory.
* Sends the documents to Elasticsearch using the **Bulk API** (`POST /_bulk`).
* Displays the number of **successfully indexed documents**.

---

# Stop the Cluster

```
./scripts/stop.sh
```

This stops the containers but keeps the data volumes.

---

# Reset the Cluster

To completely reset the environment, remove all data and recreate fresh indices with their mappings in one command:

```
./scripts/reset.sh
```

This command removes:

* containers
* networks
* volumes
* all Elasticsearch data
* Deletes existing indices to ensure no data pollution.
* Recreates all indices

---

## Data Format

The data format used in this project is NDJSON (Newline Delimited JSON) compatible with the Elasticsearch Bulk API.

Each document is indexed with the following structure:

{ "index": { "_index": "index-name" } }
{ document }
Indices and Fields


### 1. Users Index (users)
Bietet eine Übersicht der registrierten Benutzer und deren Rollen.

| Feld | Typ | Beschreibung |
| :--- | :--- | :--- |
| `user_id` | keyword | Eindeutige Kennung des Benutzers |
| `name` | text | Vollständiger Name (durchsuchbar) |
| `email` | keyword | E-Mail-Adresse für Logins |
| `role` | keyword | Benutzerrolle (admin, customer, etc.) |
| `country` | keyword | Herkunftsland |
| `created_at` | date | Registrierungsdatum |
Contains information about users.

---

##### Example document:

```json
{
  "user_id": "u1001",
  "name": "User 1",
  "email": "user1@example.com",
  "role": "customer",
  "country": "France",
  "created_at": "2025-02-10T10:00:00Z"
}
```

### 2.Products Index (products)

Contains product catalog information.


### 3. Orders Index (orders)

Contains purchase orders.

### 4. Application Logs (app-logs)

Simulated logs generated by different services.

### 5. Security Logs (security-logs)

Logs related to user authentication and security events.


### Data Volume

The dataset includes:

50 users

100 products

300 orders

200 security events

200 application logs

Total: 850+ indexed documents

---

# Useful Elasticsearch Commands                                                                                                             Cluster health:                                                                                                                             ```                                                                   curl -u elastic:YOUR_PASSWORD http://localhost:9200/_cluster/health?pretty                                                                  ```                                                                                                                                         List nodes:                                                                                                                                 ```                                                                   curl -u elastic:YOUR_PASSWORD http://localhost:9200/_cat/nodes?v      ```                                                                                                                                         List indices:                                                                                                                               ```                                                                   curl -u elastic:YOUR_PASSWORD http://localhost:9200/_cat/indices?v
`` 
---

# Learning Goals

This project demonstrates:

* Elasticsearch cluster deployment
* Docker container orchestration
* Environment configuration with `.env`
* Basic DevOps scripting
* Elasticsearch API usage

---
