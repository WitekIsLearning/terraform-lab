terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.34.0"
    }
  }
}

locals {
  project_name = "witek_server"
}

provider "aws" {
  profile = "default"
  region = "eu-central-1"
  
}

resource "aws_instance" "witek_server" {
  ami           = "ami-05ff5eaef6149df49"
  instance_type = var.instance_type

  tags = {
    Name = "${local.project_name}"
  }
}

variable "instance_type" {
  type = string
}


output "public_ip" {
  value = aws_instance.witek_server.public_ip

}