'use client'
import Image from "next/image";
import React, { useState, useEffect } from "react";
import { Empty } from "google-protobuf/google/protobuf/empty_pb";

import { UserServiceClient } from "../../proto/UserServiceClientPb";
import { UserList, User } from "../../proto/user_pb";

import { getUsers } from "@/lib/api";

import { Button } from "../../components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "../../components/ui/card";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { UserType } from "@/types/usertype";
import { PlusCircle, Users } from "lucide-react";
import Link from "next/link";

export default function Home() {

  const [userRows, setUserRw] = useState<User[]>([]);

  useEffect(() => {
    getUsers().then((users) => {
      console.log('the users are');
      console.log(users);
      setUserRw(users);

    }).catch((error) => {
      console.error(error);
    }
    )


  }, []);



  return (
    <div className="container mx-auto py-10">
      <Card>
        <CardHeader className="flex flex-row items-center justify-between">
          <CardTitle className="flex items-center gap-2">
            <Users className="h-5 w-5" />
            Users
          </CardTitle>
          <Link href="/users/create">
            <Button>
              <PlusCircle className="mr-2 h-4 w-4" />
              Create User
            </Button>
          </Link>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Name</TableHead>
                <TableHead>Email</TableHead>
                <TableHead>Role</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {userRows.map((user) => (
                <TableRow key={user.getId()}>
                  <TableCell>{user.getUsername()}</TableCell>
                  <TableCell>{user.getEmail()}</TableCell>
                  <TableCell className="capitalize">{user.getRole()}</TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </div>
  );
}
