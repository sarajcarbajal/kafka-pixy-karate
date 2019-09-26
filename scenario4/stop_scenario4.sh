#!/bin/bash

RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${BLUE}#####Stopping Kafka-pixy#####"
pkill -n kafka-pixy
sleep 2
echo -e "${NC}"

echo -e "${RED}#####Stopping Kafka and Zookeeper dockers#####"
docker-compose -f ../docker-compose.yaml down -v
echo -e "${NC}"
