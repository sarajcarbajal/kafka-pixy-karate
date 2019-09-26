#!/bin/bash

RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${RED}#####Starting Landoop docker#####"
docker run -d --rm -p 2181:2181 -p 3030:3030 -p 8081-8083:8081-8083 -p 9581-9585:9581-9585 -p 9092:9092 -e ADV_HOST=localhost --name landoop landoop/fast-data-dev:latest
sleep 10
echo -e "${NC}"

echo -e "${BLUE}#####Starting Kafka-pixy#####"
kafka-pixy &
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

echo -e "${RED}#####Stopping Landoop docker#####"
docker stop landoop
echo -e "${NC}"