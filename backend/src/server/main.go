//go:build !test
// +build !test

package main

import (
	"context"
	"log"
	"net"
	"os"

	pb "github.com/amlana21/grpc-aws/src/proto/proto"
	"google.golang.org/grpc"

	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

var addr string = "0.0.0.0:50051"
var collection *mongo.Collection
var mongo_uri string = os.Getenv("MONGO_URI")

type Server struct {
	pb.UserServiceServer
}

func main() {
	client, err := mongo.NewClient(options.Client().ApplyURI(mongo_uri))
	if err != nil {
		log.Fatal(err)
	}
	err = client.Connect(context.Background())
	if err != nil {
		log.Fatal(err)
	}

	collection = client.Database("usersdb").Collection("users")
	log.Println("Connected to MongoDB")
	// log.Printf("This is mongo uri: %v", mongo_uri)

	lis, err := net.Listen("tcp", addr)
	if err != nil {
		log.Fatalf("Failed to listen: %v\n", err)
	}

	log.Printf("Listening at this %s\n", addr)

	s := grpc.NewServer()
	pb.RegisterUserServiceServer(s, &Server{})

	if err := s.Serve(lis); err != nil {
		log.Fatalf("Failed to serve: %v\n", err)
	}

}
