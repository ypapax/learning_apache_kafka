package main

import (
	"context"
	"log"

	kafka "github.com/segmentio/kafka-go"
)

func main() {
	log.SetFlags(log.LstdFlags | log.Llongfile)
	conf := kafka.ReaderConfig{
		Brokers:   []string{"localhost:9092"},
		Topic:     "second_topic",
		Partition: 0,
		MinBytes:  10e3, // 10KB
		MaxBytes:  10e6, // 10MB
	}
	// make a new reader that consumes from topic-A, partition 0, at offset 42
	r := kafka.NewReader(conf)
	//r.SetOffset(42)

	log.Println("conf", conf)

	for {
		m, err := r.ReadMessage(context.Background())
		if err != nil {
			log.Println(err)
			break
		}
		log.Printf("message at offset %d: %s = %s\n", m.Offset, string(m.Key), string(m.Value))
	}

	r.Close()
}
