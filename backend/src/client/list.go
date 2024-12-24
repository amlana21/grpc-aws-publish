package main

import (
	"context"
	"log"

	pb "github.com/amlana21/grpc-aws/src/proto/proto"
	"google.golang.org/protobuf/types/known/emptypb"
)

func listUsers(c pb.UserServiceClient) []*pb.User {
	log.Println("---listUsers was invoked---")
	userRows, err := c.ListUsers(context.Background(), &emptypb.Empty{})
	if err != nil {
		log.Fatalf("Error while calling ListUsers: %v\n", err)
	}

	if err != nil {
		log.Fatalf("Unexpected error: %v\n", err)
	}

	userListResp := userRows.User

	
	log.Printf("User List: %v\n", userListResp)
	return userListResp
}
