#!/usr/bin/env bash
set -ex

containerName=kafka-cluster
zoo="--zookeeper 127.0.0.1:2181"

run() {
  docker run --rm -it \
    -p 2181:2181 -p 3030:3030 -p 8081:8081 \
    -p 8082:8082 -p 8083:8083 -p 9092:9092 \
    -e ADV_HOST=127.0.0.1 \
    --name $containerName \
    landoop/fast-data-dev

}

command(){
  docker run --rm -it --net=host landoop/fast-data-dev "$@"
}


produce(){
  command kafka-console-producer --broker-list 127.0.0.1:9092 --topic second_topic
}

commandLineTools(){
  command bash
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

cleanupPolicyCompact(){
  command kafka-topics --create --topic test_cleanup --zookeeper 127.0.0.1:2181 --config cleanup.policy=compact --partitions 3 --replication-factor 1
}

descr2(){
  command kafka-topics --topic test_cleanup --describe --zookeeper 127.0.0.1:2181
}


alter(){
  command kafka-topics --alter --topic test_cleanup --config cleanup.policy=delete
}

logs(){
  docker exec -ti $containerName tail -f /var/log/broker.log
}

topicWithOftenCompactions(){
  command kafka-topics "$zoo" --create \
    --topic employee-salary-compact \
    --partitions 1 --replication-factor 1 \
    --config cleanup.policy=compact \
    --config min.cleanable.dirty.ratio=0.005 \
    --config segment.ms=10000
}

bootstrap="--bootstrap-server 127.0.0.1:9092"

consumer(){
  command kafka-console-consumer $bootstrap \
    --topic employee-salary-compact \
    --from-beginning \
    --property print.key=true \
    --property key.separator=,
}

producer(){
  command kafka-console-producer --broker-list 127.0.0.1:9092 \
    --topic employee-salary-compact \
    --property parse.key=true \
    --property key.separator=,

#  '123,{"John": "80000"}'
}

"$@"