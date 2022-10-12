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
  count         = 2
  ami           = "ami-05ff5eaef6149df49"
  instance_type = "t2.micro"
    tags = {Name = "Server-$(count.index)"
    }
}

output "public_ip" {
  value = aws_instance.witek_server[*].public_ip
}

