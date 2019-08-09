package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"time"

	kafka "github.com/segmentio/kafka-go"
)

func main() {
	log.SetFlags(log.LstdFlags | log.Llongfile)
	topic := "second_topic"
	partition := 0

	conn, err := kafka.DialLeader(context.Background(), "tcp", "localhost:9092", topic, partition)
	if err != nil {
		log.Println(err)
		os.Exit(1)
	}

	/*if err := conn.SetWriteDeadline(time.Now().Add(10 * time.Second)); err != nil {
		log.Println("error: ", err)
	}*/

	defer conn.Close()

	var i = 0

	for {
		i++
		key := fmt.Sprintf("%+v", i)
		value := fmt.Sprintf("%+v-%+v", i, i)
		n, err := conn.WriteMessages(
			kafka.Message{Key: []byte(key), Value: []byte(value)},
		)
		if err != nil {
			log.Printf("error: %+v", err)
		}
		log.Printf("written %+v bytes, key: %+v, value: %+v\n", n, key, value)
		time.Sleep(1000 * time.Millisecond)
	}
}
