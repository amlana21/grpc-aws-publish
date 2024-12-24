terraform {
  required_version = ">= 1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.11.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "grpc-post"
}


module "security" {
  source = "./security"
}

module "storage_module" {
  source               = "./storage"
  frontend_bucket_name = "<bucket_name>"
}

module "networking_module" {
  source         = "./networking"
  region         = "us-east-1"
  s3_bucket_name = "<bucket_name>"
  depends_on     = [module.storage_module]
}

module "compute" {
  source         = "./compute"
  task_role_arn  = module.security.task_execution_role_arn
  subnet_ids     = module.networking_module.subnet_ids
  vpc_id         = module.networking_module.vpc_id
  mongo_sg_id    = module.networking_module.mongo_sg_id
  task_sg_id     = module.networking_module.task_sg_id
  target_grp_arn = module.networking_module.tg_arn
  mongo_username = "mongoadmin"
  docdb_password = "mongopassword"
}
