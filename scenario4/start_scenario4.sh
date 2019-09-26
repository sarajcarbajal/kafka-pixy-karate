#!/bin/bash

RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${RED}#####Starting Kafka and Zookeeper dockers#####"
docker-compose -f ../docker-compose.yaml up -d
sleep 15
echo -e "${NC}"

echo -e "${BLUE}#####Starting Kafka-pixy#####"
kafka-pixy &
sleep 8
echo -e "${NC}"
