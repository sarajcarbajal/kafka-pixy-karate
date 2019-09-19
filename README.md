# PoC Kafka Pixy Service

To download the docker image

```[bash]
docker pull mailgun/kafka-pixy
```

To run this image

```[bash]
docker run -d -p 19091:19091 -p 19092:19092 -v $CONFIG_PATH:/etc/kafka-pixy.yaml mailgun/kafka-pixy --config /etc/kafka-pixy.yaml
```
