/* move to main.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.34.0"
    }
  }
}

*/

/* move to providers.tf

provider "aws" {
    profile = "default"
    region  = "eu-central-1"
}

*/

/* move to variables.tf

variable "instance_type" {
  type = string
}

*/

/* move to main.tf
locals {
  project_name = "WitekServer"
}

*/

resource "aws_instance" "witek_server" {
  ami           = "ami-05ff5eaef6149df49"
  instance_type = var.instance_type

  tags = {
    Name = "${local.project_name}"
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

/* move to outputs.tf

output "public_ip" {
    value = aws_instance.witek_server.public_ip
  
}

*/