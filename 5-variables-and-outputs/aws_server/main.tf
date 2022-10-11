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

variable "instance_type" {
  type = string
  description = "The size of VM"
  # sensitive = true
  validation {
    condition     = can(regex("^t2.",var.instance_type))
    error_message = "The instance must be a t2 type"
	}
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

output "public_ip" {
  value = aws_instance.witek_server.public_ip
  sensitive = false
}