package main

import (
	"context"
	"fmt"
	"log"

	pb "github.com/amlana21/grpc-aws/src/proto/proto"

	"go.mongodb.org/mongo-driver/bson/primitive"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (*Server) CreateUser(ctx context.Context, in *pb.User) (*pb.UserId, error) {
	log.Printf("CreateUser was invoked with %v\n", in)

	data := UserItem{
		Username: in.Username,
		Email:    in.Email,
		Role:     in.Role,
	}

	res, err := collection.InsertOne(ctx, data)
	if err != nil {
		return nil, status.Errorf(
			codes.Internal,
			fmt.Sprintf("Internal error: %v", err),
		)
	}

	oid, ok := res.InsertedID.(primitive.ObjectID)

	if !ok {
		return nil, status.Errorf(
			codes.Internal,
			"Cannot convert to OID",
		)
	}

	return &pb.UserId{
		Id: oid.Hex(),
	}, nil
}
