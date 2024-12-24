export interface UserType {
  id: number;
  name: string;
  email: string;
  role: string;
}

export interface CreateUserInputType {
  name: string;
  email: string;
  role: string;
}