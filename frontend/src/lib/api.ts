import { CreateUserInputType, UserType } from "@/types/usertype";
import { Empty } from "google-protobuf/google/protobuf/empty_pb";

import { UserServiceClient } from "../proto/UserServiceClientPb";
import { UserList,User } from "../proto/user_pb";

const API_URL = "http://localhost:50054"; // Replace with your actual API URL
const usersClient = new UserServiceClient(API_URL);



export async function getUsers(): Promise<User[]> {
  const allUsers:UserList=await usersClient.listUsers(new Empty(), {});
  console.log(allUsers.getUserList());
  const userObject = allUsers.getUserList();
  let userObjArray:User[]= [];
  userObject.forEach((user)=>{
    userObjArray.push(user);
  });
  return userObjArray;
}

export async function createUser(data: User): Promise<String> {
  const response = await usersClient.createUser(data, {});
  console.log(response);
  const UserID=response.getId();
  return UserID;
}