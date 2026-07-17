# Hadoop Local Docker Cluster – HDFS & MapReduce

------------------------------------------------PART 1------------------------------------------------


<p align="center">

![Hadoop](https://img.shields.io/badge/Apache-Hadoop%203.3.6-yellow?logo=apache)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)
![HDFS](https://img.shields.io/badge/HDFS-Distributed%20Storage-success)
![YARN](https://img.shields.io/badge/YARN-Resource%20Manager-blue)
![MapReduce](https://img.shields.io/badge/MapReduce-WordCount-orange)
![Platform](https://img.shields.io/badge/Platform-Windows%2011-informational)
![Status](https://img.shields.io/badge/Project-Completed-brightgreen)

</p>

---

# 📖 Table of Contents

- Project Overview
- Architecture
- Technology Stack
- Features
- Prerequisites
- Repository Structure
- Hadoop Cluster Components
- Installation & Setup
- Starting the Hadoop Cluster
- Cluster Verification
- HDFS Directory Creation
- Dataset Upload to HDFS
- Dataset Verification
- Storage Verification
- MapReduce WordCount
- Output Verification
- Hadoop Web UI Verification
- Troubleshooting
- Learning Outcomes
- Future Improvements
- References

---

# 📌 Project Overview

This project demonstrates how to deploy a **fully functional Apache Hadoop cluster locally** using **Docker Compose** on **Windows**.

The environment includes:

- Apache Hadoop 3.3.6
- HDFS
- YARN
- MapReduce
- Job History Server
- Three Worker Nodes
- Docker Compose based deployment

After deploying the cluster, sample e-commerce datasets are uploaded into HDFS, verified using HDFS commands, and processed using the classic Hadoop **WordCount** MapReduce application.

This project provides practical experience with:

- Distributed storage
- HDFS operations
- Dockerized Hadoop
- MapReduce execution
- Hadoop cluster monitoring
- YARN application management

---

# 🏗 Architecture

```text
                     +----------------------------------+
                     |        Windows Host Machine      |
                     |                                  |
                     | Docker Desktop + Git Bash        |
                     +---------------+------------------+
                                     |
                                     |
                          Docker Compose Network
                                     |
     ----------------------------------------------------------------
     |                 Hadoop Cluster                               |
     |                                                              |
     |   +----------------------+                                   |
     |   |      NameNode        |                                   |
     |   |     Port : 9870      |                                   |
     |   +----------------------+                                   |
     |                                                              |
     |   +----------------------+                                   |
     |   |   ResourceManager    |                                   |
     |   |     Port : 8088      |                                   |
     |   +----------------------+                                   |
     |                                                              |
     |   +----------------------+                                   |
     |   |    History Server    |                                   |
     |   |     Port : 19888     |                                   |
     |   +----------------------+                                   |
     |                                                              |
     |   +-------------+   +-------------+   +-------------+        |
     |   | Worker-1    |   | Worker-2    |   | Worker-3    |        |
     |   +-------------+   +-------------+   +-------------+        |
     ----------------------------------------------------------------
                                     |
                                     |
                                  HDFS Storage
                                     |
             /shopstream
                |
                +-- raw
                |     |
                |     +-- orders
                |     +-- reviews
                |     +-- clickstream
                |
                +-- processed
                |
                +-- output
                      |
                      +-- wordcount
```

---

# 🚀 Features

- Deploy Hadoop locally using Docker
- Multi-node Hadoop Cluster
- HDFS Operations
- Distributed Storage
- Dataset Upload
- Dataset Verification
- MapReduce WordCount
- Hadoop Web Interfaces
- Job History
- Resource Monitoring
- Windows Compatible
- Git Bash Compatible

---

# 💻 Technology Stack

| Component | Version |
|------------|----------|
| Apache Hadoop | 3.3.6 |
| Docker Desktop | Latest |
| Docker Compose | v2 |
| Git Bash | MINGW64 |
| Windows | 11 |
| Java | 11 |
| HDFS | Included |
| YARN | Included |
| MapReduce | Included |

---

# ✅ Prerequisites

Before starting, install the following software.

| Software | Required |
|-----------|----------|
| Windows 10 / 11 | ✅ |
| Docker Desktop | ✅ |
| Docker Compose | ✅ |
| Git | ✅ |
| Git Bash | ✅ |
| Java 11+ | ✅ |
| Internet Connection | ✅ |

---

## Verify Installation

### Docker

```bash
docker --version
```

Expected

```text
Docker version 29.x.x
```

---

### Docker Compose

```bash
docker compose version
```

---

### Git

```bash
git --version
```

---

### Verify Docker Engine

```bash
docker ps
```

If Docker is running successfully, the command should execute without errors.

---

# 📁 Repository Structure

```text
Hadoop-local-Docker
│
├── data
│   └── ecommerce
│       ├── orders.csv
│       ├── product_reviews.txt
│       └── clickstream.csv
│
├── scripts
│   ├── start.sh
│   ├── verify.sh
│   └── smoke-test.sh
│
├── docker-compose.yml
│
├── README.md
│
└── docs
```

---

# ⚙ Hadoop Cluster Components

| Container | Purpose |
|------------|----------|
| NameNode | HDFS Metadata |
| ResourceManager | YARN Resource Scheduling |
| History Server | Completed Job Logs |
| Worker-1 | DataNode + NodeManager |
| Worker-2 | DataNode + NodeManager |
| Worker-3 | DataNode + NodeManager |

---

# 📥 Clone Repository

```bash
git clone <YOUR_GITHUB_REPOSITORY_URL>
```

Example

```bash
git clone https://github.com/<username>/Hadoop-local-Docker.git
```

---

# 📂 Navigate into Project

```bash
cd Hadoop-local-Docker
```

---

# ▶ Start Hadoop Cluster

Start the complete Hadoop cluster using the provided startup script.

```bash
./scripts/start.sh
```

The script performs the following tasks:

- Pulls Docker images (if not available locally)
- Creates the Docker network
- Starts all Hadoop services
- Waits until every container becomes healthy
- Displays the Hadoop Web UI URLs

Expected output:

```text
Cluster started

HDFS NameNode
http://localhost:9870

YARN ResourceManager
http://localhost:8088

Job History
http://localhost:19888
```

---

# 📋 Verify Running Containers

```bash
docker compose ps
```

Expected:

| Container | Status |
|------------|--------|
| namenode | Healthy |
| resourcemanager | Healthy |
| historyserver | Healthy |
| worker-1 | Healthy |
| worker-2 | Healthy |
| worker-3 | Healthy |
| proxyserver | Healthy |

---

➡️ **End of Part 1**

The next part will cover:

- Cluster Verification
- HDFS Configuration
- Creating HDFS Directories
- Uploading the Ecommerce Dataset
- Dataset Validation
- Storage Verification
- Git Bash (`No FileSystem for scheme "C"`) troubleshooting


------------------------------------------------PART 2------------------------------------------------




# ✅ Cluster Verification

After the cluster starts successfully, verify that all Hadoop services are functioning correctly.

---

## Verify HDFS Default Filesystem

```bash
docker exec namenode hdfs getconf -confKey fs.defaultFS
```

Expected Output

```text
hdfs://namenode:9000
```

---

## Verify YARN Worker Nodes

```bash
docker exec resourcemanager yarn node -list
```

Expected Output

```text
Total Nodes: 3

Node-State
worker-1   RUNNING
worker-2   RUNNING
worker-3   RUNNING
```

---

# 🌐 Hadoop Web Interfaces

Verify that all web interfaces are accessible.

| Service | URL | Purpose |
|----------|-----|----------|
| NameNode | http://localhost:9870 | HDFS Management |
| ResourceManager | http://localhost:8088 | Running Applications |
| Job History | http://localhost:19888 | Completed Jobs |

---

# 📂 Create HDFS Directory Structure

Create the required folders for storing the e-commerce datasets.

```bash
docker exec namenode hdfs dfs -mkdir -p /shopstream/raw/orders
```

```bash
docker exec namenode hdfs dfs -mkdir -p /shopstream/raw/reviews
```

```bash
docker exec namenode hdfs dfs -mkdir -p /shopstream/raw/clickstream
```

```bash
docker exec namenode hdfs dfs -mkdir -p /shopstream/processed
```

---

## Verify HDFS Directory Structure

```bash
docker exec namenode hdfs dfs -ls -R /shopstream
```

Expected Structure

```text
/shopstream
├── raw
│   ├── orders
│   ├── reviews
│   └── clickstream
└── processed
```

---

# ⚠ Git Bash Path Conversion Issue (Windows)

While executing HDFS commands from Git Bash, Windows may automatically convert Linux paths.

Example Error

```text
mkdir: No FileSystem for scheme "C"
```

---

## Temporary Fix

```bash
MSYS_NO_PATHCONV=1 MSYS2_ARG_CONV_EXCL="*" docker exec namenode hdfs dfs -mkdir -p /shopstream/raw/orders
```

---

## Permanent Fix (Current Git Bash Session)

```bash
export MSYS_NO_PATHCONV=1
export MSYS2_ARG_CONV_EXCL="*"
```

Verify

```bash
echo $MSYS_NO_PATHCONV
```

Expected

```text
1
```

---

# 📤 Copy Dataset to NameNode Container

Orders

```bash
docker cp data/ecommerce/orders.csv namenode:/tmp/orders.csv
```

Reviews

```bash
docker cp data/ecommerce/product_reviews.txt namenode:/tmp/product_reviews.txt
```

Clickstream

```bash
docker cp data/ecommerce/clickstream.csv namenode:/tmp/clickstream.csv
```

---

# 📥 Upload Files into HDFS

Orders

```bash
docker exec namenode hdfs dfs -put -f /tmp/orders.csv /shopstream/raw/orders/
```

Reviews

```bash
docker exec namenode hdfs dfs -put -f /tmp/product_reviews.txt /shopstream/raw/reviews/
```

Clickstream

```bash
docker exec namenode hdfs dfs -put -f /tmp/clickstream.csv /shopstream/raw/clickstream/
```

---

# 📋 Verify Uploaded Files

```bash
docker exec namenode hdfs dfs -ls -R /shopstream
```

Expected Output

```text
/shopstream/raw/orders/orders.csv

/shopstream/raw/reviews/product_reviews.txt

/shopstream/raw/clickstream/clickstream.csv
```

---

# 📖 Verify Dataset Contents

Orders

```bash
docker exec namenode hdfs dfs -cat /shopstream/raw/orders/orders.csv
```

Reviews

```bash
docker exec namenode hdfs dfs -cat /shopstream/raw/reviews/product_reviews.txt
```

Clickstream

```bash
docker exec namenode hdfs dfs -cat /shopstream/raw/clickstream/clickstream.csv
```

---

# 💾 Verify HDFS Storage Usage

```bash
docker exec namenode hdfs dfs -du -h /shopstream/raw
```

Example Output

```text
1.1 K   /shopstream/raw/clickstream
1.2 K   /shopstream/raw/orders
808 B   /shopstream/raw/reviews
```

---

# 🔎 Locate Hadoop MapReduce Examples JAR

```bash
docker exec namenode find /opt -name "hadoop-mapreduce-examples*.jar"
```

Located File

```text
/opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar
```

Verify

```bash
docker exec namenode ls -lh /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar
```


------------------------------------------------PART 3------------------------------------------------


# 🚀 MapReduce – WordCount Example

Remove any previous output directory.

```bash
docker exec namenode hdfs dfs -rm -r -f /shopstream/output/wordcount
```

Run the WordCount MapReduce job.

```bash
docker exec namenode hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar wordcount /shopstream/raw/reviews /shopstream/output/wordcount
```

---

## Successful Execution

The terminal should display progress similar to:

```text
map 0%
map 100%
reduce 0%
reduce 100%

Job Finished Successfully
```

The job statistics include:

- Map Tasks
- Reduce Tasks
- Input Records
- Output Records
- CPU Time
- Memory Usage
- HDFS Read/Write Statistics

---

# 📋 Verify WordCount Output

```bash
docker exec namenode hdfs dfs -ls /shopstream/output/wordcount
```

Expected Output

```text
_SUCCESS
part-r-00000
```

---

# 📄 Display WordCount Results

```bash
docker exec namenode hdfs dfs -cat /shopstream/output/wordcount/part-r-00000 | head -20
```

Example

```text
again 1
battery 1
customer 2
delivery 2
excellent 2
headphones 3
quality 2
```

---

# 🌐 Verify MapReduce in Hadoop UI

## NameNode

```
http://localhost:9870
```

Verify

- Browse HDFS
- View uploaded datasets
- Check directory structure

---

## ResourceManager

```
http://localhost:8088
```

Verify

- Applications
- Running/Completed Jobs
- Nodes
- Scheduler
- Cluster Metrics

The WordCount application should appear with the status **FINISHED**.

---

## Job History

```
http://localhost:19888
```

Verify

- Completed Jobs
- Job Counters
- Map Tasks
- Reduce Tasks
- Task Attempts
- Logs

---

# 📁 Final HDFS Structure

```text
/shopstream
│
├── raw
│   ├── orders
│   │   └── orders.csv
│   ├── reviews
│   │   └── product_reviews.txt
│   └── clickstream
│       └── clickstream.csv
│
├── processed
│
└── output
    └── wordcount
        ├── _SUCCESS
        └── part-r-00000
```

---

# 🛠 Troubleshooting

| Issue | Solution |
|--------|----------|
| `mkdir: No FileSystem for scheme "C"` | Export `MSYS_NO_PATHCONV=1` and `MSYS2_ARG_CONV_EXCL="*"` |
| Output directory already exists | Remove with `hdfs dfs -rm -r -f` |
| Containers not healthy | Restart using `./scripts/start.sh` |
| UI not opening | Verify containers with `docker compose ps` |

---

# 🎯 Learning Outcomes

Through this project, I learned how to:

- Deploy a multi-node Hadoop cluster locally using Docker Compose.
- Configure and verify HDFS and YARN services.
- Manage HDFS directories and files using CLI commands.
- Upload and validate datasets in HDFS.
- Execute a MapReduce WordCount job.
- Monitor Hadoop jobs using ResourceManager and Job History Server.
- Resolve Windows Git Bash path conversion issues when working with Docker and HDFS.

---

# 📸 Suggested Screenshots

Include screenshots for:

1. Docker containers running (`docker compose ps`)
2. NameNode UI (`9870`)
3. ResourceManager UI (`8088`)
4. Job History UI (`19888`)
5. HDFS directory structure
6. WordCount terminal output
7. WordCount results (`part-r-00000`)

---

# 📚 References

- Apache Hadoop Documentation
- Docker Documentation
- Hadoop Local Docker Course Repository

---

# 📄 License

This project is intended for educational and learning purposes.

---

# 👨‍💻 Author

**Mandeep Kumar**

If you found this project useful, consider giving the repository a ⭐ on GitHub.