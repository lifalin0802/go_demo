package main

import (
	"context"
	"fmt"
	"net"

	pb "grpc/server/proto"

	"google.golang.org/grpc"
)

type server struct {
	pb.UnimplementedSayHelloServer
}

func (s *server) SayHello(ctx context.Context, req *pb.HelloRequest) (*pb.HelloResponse, error) {

	fmt.Println(req.RequestName)
	return &pb.HelloResponse{ResponseMsg: "hello" + req.RequestName}, nil
	// return nil, status.Errorf(codes.Unimplemented, "method SayHello not implemented")
}

func main() {
	listen, _ := net.Listen("tcp", ":9090")

	//create grpc server
	grpcServer := grpc.NewServer()

	//register our service to grpc server
	pb.RegisterSayHelloServer(grpcServer, &server{}) //&server{} 是引用注册

	//if grpcServer == nil {
	//	log.Fatal("grpcServer is nil")
	//}
	//if listen == nil {
	//	log.Fatalf("listener is nil,  err: %v", err_listen)
	//}

	//start server
	err := grpcServer.Serve(listen)
	if err != nil {
		fmt.Printf("failed to serve: %v", err)
		return
	}
}
