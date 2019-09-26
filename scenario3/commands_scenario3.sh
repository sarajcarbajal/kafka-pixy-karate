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
kafka-pixy --config config.yaml &
sleep 8
echo -e "${NC}"

echo -e "${GREEN}#####Check connection with Kafka through Kafka-pixy#####"
curl -X POST 'localhost:19092/topics/foo/messages?sync' -d msg='May the Force be with you!' -v
sleep 5
echo -e "${NC}"

echo -e "${BLUE}#####Stopping Kafka-pixy#####"
pkill -n kafka-pixy
sleep 2
echo -e "${NC}"

echo -e "${RED}#####Stopping Kafka and Zookeeper dockers#####"
docker-compose -f ../docker-compose.yaml down -v
echo -e "${NC}"