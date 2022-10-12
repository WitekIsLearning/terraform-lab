terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.34.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region = "eu-central-1"
}

resource "aws_instance" "witek_server" {
  for_each = {
    nano = "t2.nano"
    micro = "t2.micro"
    smal = "t2.small"
  }
  ami           = "ami-05ff5eaef6149df49"
  instance_type = "each.value"
    tags = {Name = "Server-$(each.key)"
    }
}

output "public_ip" {
  value = values(aws_instance.witek_server)[*].public_ip
}

