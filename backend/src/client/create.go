package main

import (
	"context"
	"log"

	pb "github.com/amlana21/grpc-aws/src/proto/proto"
)

func createUser(c pb.UserServiceClient) string {
	log.Println("---createUser was invoked---")

	user := &pb.User{
		Username: "TestUser",
		Email:    "abc@email.com",
		Role:     "admin",
	}

	res, err := c.CreateUser(context.Background(), user)

	if err != nil {
		log.Fatalf("Unexpected error: %v\n", err)
	}

	log.Printf("User has been created: %v\n", res)
	return res.Id
}
