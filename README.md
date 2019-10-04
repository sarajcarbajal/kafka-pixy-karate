# PoC Kafka Pixy Service

Kafka-Pixy is a dual API (gRPC and REST) proxy for Kafka with automatic consumer group control. It is designed to hide the complexity of the Kafka client protocol and provide a stupid simple API that is trivial to implement in any language.

## Prerequisites

- Golang
- Kafka environment deployment

## Getting Started Kafka-pixy

To download Kafka pixy we only run the following command:

```[bash]
go get github.com/mailgun/kafka-pixy
```

**NOTE:** it is necessary to add kafka-pixy path to PATH environment variable

```[bash]
export PATH=$PATH:$GOPATH/bin
```

To run this tool, execute the command below:

```[bash]
kafka-pixy
```

You should see a log as below:

```[bash]
info "Starting with config: &{GRPCAddr:0.0.0.0:19091 TCPAddr:0.0.0.0:19092 UnixAddr: Proxies:map[default:0xc00015a000] DefaultCluster:default TLS:{CertPath: KeyPath:}}"
info "Initializing new client" category=sarama
info "client/metadata fetching metadata for all topics from broker localhost:9092" category=sarama
info "Connected to broker at localhost:9092 (unregistered)" category=sarama
info "Successfully initialized new client" category=sarama
info "Initializing new client" category=sarama
info "client/metadata fetching metadata for all topics from broker localhost:9092" category=sarama
info </default.0/offset_mgr_f.0/mapper.0> Started
info "Connected to broker at localhost:9092 (unregistered)" category=sarama
info "client/brokers registered new broker #0 at localhost:9092" category=sarama
info "Successfully initialized new client" category=sarama
info "Initializing new client" category=sarama
info "client/metadata fetching metadata for all topics from broker localhost:9092" category=sarama
info </default.0/prod_merg.0> Started
info </default.0/prod_disp.0> Started
info "Connected to broker at localhost:9092 (unregistered)" category=sarama
info "client/brokers registered new broker #0 at localhost:9092" category=sarama
info "Successfully initialized new client" category=sarama
info </default.0/cons.0/disp.0> Started
info </service.0> Started
info </0.0.0.0:19092.0> Started
info </grpc://0.0.0.0:19091.0> Started
info "Connected to 127.0.0.1:2181" category=zk
info "authenticated: id=72057956397678593, timeout=15000" category=zk
info "re-submitting `0` credentials after reconnect" category=zk
```

### Scenario 1 - Landoop docker and kafka-pixy from local

The process explain below is included in `commands_scenario1.sh` script inside `scenario1` folder.

First of all, you need to download **Landoop docker image** from <https://hub.docker.com/r/landoop/fast-data-dev> and run the command belows

```[bash]
docker run -d --rm -p 2181:2181 -p 3030:3030 -p 8081-8083:8081-8083 -p 9581-9585:9581-9585 -p 9092:9092 -e ADV_HOST=localhost landoop/fast-data-dev:latest
```

After that, you run `kafka-pixy` in a terminal to start the proxy. Once running, in other terminal you can run the following command to verify that the communication between **kafka-pixy** and **landoop docker** is correct.

```[bash]
curl -X POST 'localhost:19092/topics/foo/messages?sync' -d msg='May the Force be with you!'
```

To check that the message has been sent to kafka correctly you can verify it through a Kafka client, for example, [Conduktor](https://www.conduktor.io/) or [Kafka development environment](http://localhost:3030/) launched with Landoop docker image.

### Scenario 2 - Kafka y ZK from docker-compose and kafka-pixy from local

The process explain below is included in `commands_scenario2.sh` script inside `scenario2` folder.

First of all, you need to start **Kafka** and **Zookeeper** containers with the command belows:

```[bash]
docker-compose up -d
```

After that, you run `kafka-pixy` in a terminal to start the proxy. Once running, in other terminal you can run the following command to verify that the communication between **kafka-pixy**, **Kafka docker** and **Zookeeper docker** is correct.

```[bash]
curl -X POST 'localhost:19092/topics/foo/messages?sync' -d msg='May the Force be with you!'
```

To check that the message has been sent to kafka correctly you can verify it through a Kafka client, for example, [Conduktor](https://www.conduktor.io/)

### Scenario 3 - Kafka-pixy with config file as parameter

The process explain below is included in `commands_scenario3.sh` script inside `scenario3` folder.

First of all, you need to start **Kafka** and **Zookeeper** containers with the command belows:

```[bash]
docker-compose up -d
```

After that, you run `kafka-pixy --config config.yaml` in a terminal to start the proxy. Once running, in other terminal you can run the following command to verify that the communication between **kafka-pixy**, **Kafka docker** and **Zookeeper docker** is correct.

```[bash]
curl -X POST 'localhost:19092/topics/foo/messages?sync' -d msg='May the Force be with you!'
```

To check that the message has been sent to kafka correctly you can verify it through a Kafka client, for example, [Conduktor](https://www.conduktor.io/)

### Scenario 4 - Run tests with Karate framework

All scripts for this scenario are included inside `scenario4` folder.

First of all, you need to start **Kafka**, **Zookeeper** and **Kafka-pixy** running `start_scenario4.sh`

After that, you should run `java -jar karate.jar firstTest.feature` to start the test with [Karate Framework](https://github.com/intuit/karate).

Once tests have been finished, run `stop_scenario4.sh` to stop **Kafka** and **Zookeeper** dockers and **kafka-pixy**

### Reporting Karate Test results to Zephyr JIRA

If you need to report the results obtained of karate tests to Zephyr JIRA, you can use [Zephyr Sync](https://github.com/ctco/zephyr-sync) to do it. (Run with JAVA 8)

First of all, you need to add `@Stories=XXXX` to the Feature Scenario of Karate test

After that, run the command with a series of parameters described below:

| Parameter        | Description                                                                                                                                               | Is mandatory? |
| ---------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- |
| --username       | Username of JIRA                                                                                                                                          | yes           |
| --password       | Password of Jira                                                                                                                                          | yes           |
| --reportType     | Type of report that will be synchronized to Zephyr (cucumber, allure, junit, nunit)                                                                       | yes           |
| --projectKey     | Key of project in JIRA                                                                                                                                    | yes           |
| --releaseVersion | Release version to link Test results to                                                                                                                   | yes           |
| --jiraUrl        | Url of JIRA followed by `/rest/`                                                                                                                          | yes           |
| --reportPath     | Path on the file system where reports are stored                                                                                                          | yes           |
| --testCycle      | Zephyr test cycle where the results will be linked to                                                                                                     | yes           |
| --linkType       | Link type between Test issue and related story (used in combination with @Stories annotation inside Karate Test Feature/Scenarios. eg `@Stories=ABC-XXX`) | no            |
| --forceStoryLink | If set to true, sync will be failed in case at least one test doesn't have `@Stories=ABC-XXX` annotation                                                  | no            |

```[bash]
java -jar zephyr-sync-cli-${zephyr-sync.version}-all-in-one.jar --username=${username_jira} --password={pass_jira} --reportType=cucumber --projectKey=${key_project-jira} --releaseVersion=${release_version_jira} --jiraUrl=https://${url_jira}/rest/ --reportPath=${build_target}/surefire-reports/report.json --testCycle=${zephyr_test_cycle} --linkType=Tests --forceStoryLink=false
```

Once executing have been finished, you could see test results reported in Zephyr Test task and in the User Story associated to the Karate test.
