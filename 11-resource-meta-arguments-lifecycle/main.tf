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
  ami           = "ami-05ff5eaef6149df49"
  instance_type = "t2.micro"
    lifecycle {
		prevent_destroy = false
	} 
  	tags = {
		Name = "witek_server"
    }
}

output "public_ip" {
  value = aws_instance.witek_server.public_ip
}