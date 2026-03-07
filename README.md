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
│
├── docker-compose.yml
├── README.md
├── .env.example
├── .gitignore
│
├── scripts
│   ├── start-cluster.sh
│   ├── stop-cluster.sh
│   ├── check-cluster.sh
│   ├── reset.sh
│   └── load-sample-data.sh
│
└── config
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

You can load a sample index and document:

```
./scripts/load-sample-data.sh
```

---

# Stop the Cluster

```
./scripts/stop.sh
```

This stops the containers but keeps the data volumes.

---

# Reset the Cluster

To completely reset the environment and remove all data:

```
./scripts/reset.sh
```

This command removes:

* containers
* networks
* volumes
* all Elasticsearch data

---

# Useful Elasticsearch Commands

Cluster health:

```
curl -u elastic:YOUR_PASSWORD http://localhost:9200/_cluster/health?pretty
```

List nodes:

```
curl -u elastic:YOUR_PASSWORD http://localhost:9200/_cat/nodes?v
```

List indices:

```
curl -u elastic:YOUR_PASSWORD http://localhost:9200/_cat/indices?v
```

---

# Security

Secrets such as passwords are not stored in the repository.

Environment variables are defined in:

```
.env
```

A template is provided:

```
.env.example
```

---

# Learning Goals

This project demonstrates:

* Elasticsearch cluster deployment
* Docker container orchestration
* Environment configuration with `.env`
* Basic DevOps scripting
* Elasticsearch API usage

---

