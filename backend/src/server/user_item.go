package main

import (
	pb "github.com/amlana21/grpc-aws/src/proto/proto"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type UserItem struct {
	ID       primitive.ObjectID `bson:"_id,omitempty"`
	Username string             `bson:"username"`
	Email    string             `bson:"email"`
	Role     string             `bson:"role"`
}

func documentToUser(data *UserItem) *pb.User {
	return &pb.User{
		Id:       data.ID.Hex(),
		Username: data.Username,
		Email:    data.Email,
		Role:     data.Role,
	}
}
