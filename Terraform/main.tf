terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

  backend "s3" {
    bucket         = "shreyas-terraform-state-bucket-123456"
    key            = "networking/vpc/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "git::https://github.com/Ramprasadvaral13/terraform-infra-module.git//modules/vpc_module?ref=main"

  vpc_cidr   = var.vpc_cidr
  route_cidr = var.route_cidr
  subnets    = var.subnets
}

module "compute" {
  source = "git::https://github.com/Ramprasadvaral13/terraform-infra-module.git//modules/compute_module?ref=main"

  name_prefix      = "webapp"
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.vpc.private_subnet_ids
  ami_id           = var.ami_id
  instance_type    = var.instance_type
  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity
  root_volume_size = var.root_volume_size
  user_data        = var.user_data
}

