Feature: first test of poc kafka pixy

  Background:
    * url 'http://localhost:19092'

      # pretty print the request/response payload
    * configure logPrettyRequest = true
    * configure logPrettyResponse = true

  Scenario: Produce message to Kafka
    Given path '/topics/foo/messages'
    And param sync = ''
    And header Content-Type = 'x-www-form-urlencoded'
    And request msg='May the force be with you'
    When method post
    Then status 200

  Scenario: Produce another message to Kafka
    Given path '/topics/events.xprivacy.configuration/messages'
    And param sync = ''
    And header Content-Type = 'application/json'
    And request read('file.json')
    When method post
    Then status 200

  Scenario: Consume message from Kafka
    Given path '/topics/events.xprivacy.configuration/consumers'
    When method get
    Then status 200
