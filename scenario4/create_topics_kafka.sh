#!/bin/bash

docker exec kafka sh -c "kafka-topics --zookeeper zookeeper:2181 --create --topic events.xprivacy.configuration --partitions 1 --replication-factor 1" 2>&1
docker exec kafka sh -c "kafka-topics --zookeeper zookeeper:2181 --create --topic foo --partitions 1 --replication-factor 1" 2>&1
