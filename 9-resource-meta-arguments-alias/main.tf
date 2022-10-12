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
  region  = "eu-west-1"
	alias = "west"
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
	alias = "central"
}

data "aws_ami" "west-amazon-linux-2" {
	provider = aws.west
 	most_recent = true
	owners = ["amazon"]
	filter {
		name   = "owner-alias"
		values = ["amazon"]
	}
	filter {
		name   = "name"
		values = ["amzn2-ami-hvm*"]
	}
}

resource "aws_instance" "my_west_server" {
  ami           = "${data.aws_ami.west-amazon-linux-2.id}"
  instance_type = "t2.micro"
	provider = aws.west
	tags = {
		Name = "Server-West"
	}
}

output "west_public_ip" {
  value = aws_instance.my_west_server.public_ip
}

data "aws_ami" "central-amazon-linux-2" {
	provider = aws.central
 	most_recent = true
	owners = ["amazon"]
	filter {
		name   = "owner-alias"
		values = ["amazon"]
	}
	filter {
		name   = "name"
		values = ["amzn2-ami-hvm*"]
	}
}

resource "aws_instance" "my_central_server" {
  ami           = "${data.aws_ami.central-amazon-linux-2.id}"
  instance_type = "t2.micro"
	provider = aws.central
	tags = {
		Name = "Server-central"
	}
}

output "central_public_ip" {
  value = aws_instance.my_central_server.public_ip
}