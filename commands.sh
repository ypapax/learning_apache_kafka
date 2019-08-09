#!/usr/bin/env bash
set -ex

run() {
  docker run --rm -it \
    -p 2181:2181 -p 3030:3030 -p 8081:8081 \
    -p 8082:8082 -p 8083:8083 -p 9092:9092 \
    -e ADV_HOST=127.0.0.1 \
    landoop/fast-data-dev
}

produce(){
  command kafka-console-producer --broker-list 127.0.0.1:9092 --topic second_topic
}

commandLineTools(){
  command bash
}

command(){
  docker run --rm -it --net=host landoop/fast-data-dev "$@"
}

createTopic(){
  command kafka-topics --zookeeper 127.0.0.1:2181 --create --topic second_topic --partitions 3 --replication-factor 1
#  command kafka-topics | grep partition
}

listTopics(){
  command kafka-topics --zookeeper 127.0.0.1:2181 --list
}

describeTopic(){
  command kafka-topics --zookeeper 127.0.0.1:2181 --describe --topic second_topic
}

runr(){
  cd kafka_reader
  go install
  kafka_reader
}

runw(){
  cd kafka_writer
  go install
  kafka_writer
}


"$@"