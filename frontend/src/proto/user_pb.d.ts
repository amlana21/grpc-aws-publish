import * as jspb from 'google-protobuf'

import * as google_protobuf_empty_pb from 'google-protobuf/google/protobuf/empty_pb'; // proto import: "google/protobuf/empty.proto"


export class User extends jspb.Message {
  getId(): string;
  setId(value: string): User;

  getUsername(): string;
  setUsername(value: string): User;

  getEmail(): string;
  setEmail(value: string): User;

  getRole(): string;
  setRole(value: string): User;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): User.AsObject;
  static toObject(includeInstance: boolean, msg: User): User.AsObject;
  static serializeBinaryToWriter(message: User, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): User;
  static deserializeBinaryFromReader(message: User, reader: jspb.BinaryReader): User;
}

export namespace User {
  export type AsObject = {
    id: string,
    username: string,
    email: string,
    role: string,
  }
}

export class UserId extends jspb.Message {
  getId(): string;
  setId(value: string): UserId;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): UserId.AsObject;
  static toObject(includeInstance: boolean, msg: UserId): UserId.AsObject;
  static serializeBinaryToWriter(message: UserId, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): UserId;
  static deserializeBinaryFromReader(message: UserId, reader: jspb.BinaryReader): UserId;
}

export namespace UserId {
  export type AsObject = {
    id: string,
  }
}

export class UserList extends jspb.Message {
  getUserList(): Array<User>;
  setUserList(value: Array<User>): UserList;
  clearUserList(): UserList;
  addUser(value?: User, index?: number): User;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): UserList.AsObject;
  static toObject(includeInstance: boolean, msg: UserList): UserList.AsObject;
  static serializeBinaryToWriter(message: UserList, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): UserList;
  static deserializeBinaryFromReader(message: UserList, reader: jspb.BinaryReader): UserList;
}

export namespace UserList {
  export type AsObject = {
    userList: Array<User.AsObject>,
  }
}

