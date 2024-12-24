package main

import (
	"log"

	pb "github.com/amlana21/grpc-aws/src/proto/proto"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

var addr string = "grpc_server:50051"

func main() {
	conn, err := grpc.Dial(addr, grpc.WithTransportCredentials(insecure.NewCredentials()))

	if err != nil {
		log.Fatalf("Couldn't connect to client: %v\n", err)
	}

	defer conn.Close()
	c := pb.NewUserServiceClient(conn)

	id := createUser(c)

	log.Printf("User ID: %v\n", id)

	
	listUsers(c)

	
}
