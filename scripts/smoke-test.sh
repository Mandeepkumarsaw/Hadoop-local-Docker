#!/usr/bin/env bash
set -euo pipefail

# Prevent Git Bash (MSYS2) path conversion on Windows
export MSYS_NO_PATHCONV=1
export MSYS2_ARG_CONV_EXCL="*"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# shellcheck source=lib.sh
source "$ROOT_DIR/scripts/lib.sh"

SAMPLE_FILE="$ROOT_DIR/data/sample.txt"
HDFS_PATH="/user/root/input/sample.txt"
OUTPUT_PATH="/user/root/output/wordcount"

# Convert Git Bash path to Windows path for docker cp
if command -v cygpath >/dev/null 2>&1; then
    SAMPLE_FILE_WIN="$(cygpath -w "$SAMPLE_FILE")"
else
    SAMPLE_FILE_WIN="$SAMPLE_FILE"
fi
cd "$ROOT_DIR"
require_docker

if [[ ! -f "$SAMPLE_FILE" ]]; then
    echo "Missing sample file: $SAMPLE_FILE"
    exit 1
fi

wait_for_cluster 300

echo
echo "========================================"
echo "Creating HDFS directory..."
echo "========================================"

docker exec namenode bash -lc "hdfs dfs -mkdir -p /user/root/input"

echo
echo "========================================"
echo "Uploading sample file to HDFS..."
echo "========================================"

cat "$SAMPLE_FILE" | MSYS_NO_PATHCONV=1 MSYS2_ARG_CONV_EXCL="*" \
docker exec -i namenode bash -lc "cat > /opt/hadoop/sample.txt"

MSYS_NO_PATHCONV=1 MSYS2_ARG_CONV_EXCL="*" \
docker exec namenode bash -lc "hdfs dfs -put -f /opt/hadoop/sample.txt $HDFS_PATH"
echo
echo "========================================"
echo "Listing HDFS directory..."
echo "========================================"

docker exec namenode bash -lc "hdfs dfs -ls /user/root/input"

echo
echo "========================================"
echo "Reading uploaded file..."
echo "========================================"

docker exec namenode bash -lc "hdfs dfs -cat $HDFS_PATH"

echo
echo "========================================"
echo "Running WordCount MapReduce Job..."
echo "========================================"

docker exec namenode bash -lc "hdfs dfs -rm -r -f $OUTPUT_PATH >/dev/null 2>&1 || true"

docker exec namenode bash -lc \
"hadoop jar \$(ls \$HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar | head -1) wordcount $HDFS_PATH $OUTPUT_PATH"

echo
echo "========================================"
echo "WordCount Output"
echo "========================================"

docker exec namenode bash -lc "hdfs dfs -cat $OUTPUT_PATH/part-r-00000"

echo
echo "========================================"
echo "Smoke Test Completed Successfully!"
echo "========================================"

echo
echo "Open the Hadoop UIs:"
echo "----------------------------------------"
echo "NameNode      : http://localhost:9870"
echo "YARN          : http://localhost:8088"
echo "Job History   : http://localhost:19888"
echo "----------------------------------------"