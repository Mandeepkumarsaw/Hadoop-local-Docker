# Running Hadoop Local Docker Cluster & Viewing Jobs in Hadoop UI

This guide explains how to start the Hadoop cluster from scratch, verify that all services are healthy, execute a sample MapReduce WordCount job, and view the job in the Hadoop Web UIs.

> **Prerequisite**
>
> The cluster was previously stopped using:
>
> ```bash
> docker compose down -v
> ```

---

# 1. Go to the Project Directory

```bash
cd "E:\Hadoop-local-Docker"
```

---

# 2. Start the Hadoop Cluster

```bash
./scripts/start.sh
```

Wait until you see:

```
All containers are healthy.

Cluster started.

HDFS NameNode UI : http://localhost:9870
YARN ResourceMgr : http://localhost:8088
Job History      : http://localhost:19888
```

---

# 3. Verify Cluster Health

Run:

```bash
./scripts/verify.sh
```

Expected output:

```
namenode         healthy
resourcemanager  healthy
historyserver    healthy
proxyserver      healthy
worker-1         healthy
worker-2         healthy
worker-3         healthy

NameNode UI reachable
YARN UI reachable
```

---

# 4. Run the Smoke Test

Run:

```bash
./scripts/smoke-test.sh
```

The script automatically performs the following:

- Waits for all containers
- Creates an HDFS directory
- Uploads `sample.txt`
- Reads the uploaded file
- Executes the Hadoop WordCount MapReduce example
- Displays the WordCount output

Expected output includes:

```
Creating HDFS directory...

Uploading sample file to HDFS...

Listing HDFS directory...

Reading uploaded file...

Running WordCount MapReduce Job...

Submitted application application_xxxxxxxxxx_0001

Job completed successfully

WordCount Output

cluster 1
docker 1
hadoop 1
hdfs 1
hello 3
local 1
mapreduce 1

Smoke Test Completed Successfully!
```

---

# 5. Open Hadoop Web UIs

## HDFS NameNode

```
http://localhost:9870
```

Used for:

- Browse HDFS
- Check storage
- View filesystem

---

## YARN ResourceManager

```
http://localhost:8088
```

Navigate to:

```
Cluster
    └── Applications
```

After running the smoke test, you should see:

- Application ID
- User
- Application Type
- Queue
- Start Time
- Finish Time
- State = FINISHED
- Final Status = SUCCEEDED

Example:

```
application_1783610771756_0001

User          hadoop

Application   MAPREDUCE

State         FINISHED

Final Status  SUCCEEDED
```

---

## Job History Server

```
http://localhost:19888
```

Navigate to:

```
Application
    └── Jobs
```

You should see:

- Job ID
- Job Name (word count)
- User
- Queue
- Maps
- Reduces
- Elapsed Time
- State = SUCCEEDED

Click the Job ID to view detailed execution information.

---

# 6. Verify from Terminal

Check running YARN applications:

```bash
docker exec -it resourcemanager yarn application -list
```

Example:

```
Application-Id
application_1783610771756_0001
```

---

Check uploaded HDFS file:

```bash
docker exec namenode hdfs dfs -ls /user/root/input
```

Expected:

```
sample.txt
```

---

View uploaded file:

```bash
docker exec namenode hdfs dfs -cat /user/root/input/sample.txt
```

---

View WordCount output:

```bash
docker exec namenode hdfs dfs -cat /user/root/output/wordcount/part-r-00000
```

---

# Why the Hadoop UI Was Empty Earlier

Initially, the cluster was healthy, but no MapReduce application had been submitted.

The smoke test stopped before the WordCount job due to file upload issues, so:

- Applications Submitted = 0
- Applications Completed = 0
- Job History = Empty

After successfully running the smoke test, the WordCount application was submitted and completed successfully.

As a result:

- ResourceManager UI displays the application.
- Job History UI displays the completed job.
- Hadoop cluster metrics are updated automatically.

---

# Stop the Cluster

To stop all containers:

```bash
docker compose down
```

To completely remove containers, networks, and volumes:

```bash
docker compose down -v
```

---

# Project Status

- ✅ Hadoop Cluster Running
- ✅ NameNode Healthy
- ✅ ResourceManager Healthy
- ✅ HistoryServer Healthy
- ✅ ProxyServer Healthy
- ✅ 3 Worker Nodes Healthy
- ✅ HDFS Working
- ✅ YARN Working
- ✅ MapReduce Working
- ✅ WordCount Executed Successfully
- ✅ Applications Visible in ResourceManager UI
- ✅ Jobs Visible in Job History UI