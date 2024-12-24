package main

import (
	"context"
	"fmt"
	"log"

	pb "github.com/amlana21/grpc-aws/src/proto/proto"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/emptypb"
)

func (*Server) ListUsers(ctx context.Context, in *emptypb.Empty) (*pb.UserList, error) {
	log.Println("ListUsers was invoked")

	
	cur, err := collection.Find(ctx, primitive.D{{}})
	if err != nil {
		return nil, status.Errorf(
			codes.Internal,
			fmt.Sprintf("Unknown internal error: %v", err),
		)
	}
	defer cur.Close(ctx)

	var users []*pb.User
	var usersResp = &pb.UserList{}

	for cur.Next(ctx) {
		data := &UserItem{}
		err := cur.Decode(data)

		if err != nil {
			return nil, status.Errorf(
				codes.Internal,
				fmt.Sprintf("Error while decoding data from MongoDB: %v", err),
			)
		}

		users = append(users, documentToUser(data))

	}
	usersResp.User = users

	if err = cur.Err(); err != nil {
		return nil, status.Errorf(
			codes.Internal,
			fmt.Sprintf("Unknown internal error: %v", err),
		)
	}

	return usersResp, nil
}
