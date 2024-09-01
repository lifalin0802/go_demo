package main

import (
	"context"
	"fmt"
	"log"

	pb "grpc/server/proto"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

func main() {
	conn, err := grpc.Dial("172.0.0.1:9090",
		grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}

	defer conn.Close()

	client := pb.NewSayHelloClient(conn)

	resp, err := client.SayHello(context.Background(), &pb.HelloRequest{RequestName: "hello i'm client"})

	fmt.Println(resp.GetResponseMsg())
}
