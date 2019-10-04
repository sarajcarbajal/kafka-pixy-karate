Feature: first test of poc kafka pixy

  Background:
    * url 'http://localhost:19092'

      # pretty print the request/response payload
    * configure logPrettyRequest = true
    * configure logPrettyResponse = true

  Scenario: Create topics in kafka
    * def topics = karate.exec("bash -x create_topics_kafka.sh")
    * print topics

  Scenario: Initialize group offsets
    * path '/topics/foo/messages'
    * param group = 'group0'
    * method get
    * path '/topics/events.xprivacy.configuration/messages'
    * param group = 'group1'
    * method get

  @Stories=ORXQA-17
  Scenario: Produce message to Kafka
    Given path '/topics/foo/messages'
    And param sync = ''
    And header Content-Type = 'application/json'
    And request msg='May the force be with you'
    When method post
    Then status 200

  @Stories=ORXQA-17
  Scenario: Produce another message to Kafka
    Given path '/topics/events.xprivacy.configuration/messages'
    And param sync = ''
    And header Content-Type = 'application/json'
    And request read('file.json')
    When method post
    Then status 200

  @Stories=ORXQA-17
  Scenario: Consume message from Kafka
    Given path '/topics/events.xprivacy.configuration/messages'
    And param group = 'group1'
    When method get
    Then status 200
