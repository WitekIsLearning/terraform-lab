
terraform {
  cloud {
    organization = "wekk"

    workspaces {
      name = "2-provisioners-cloud"
    }
  }

    required_providers {
        aws = {
        source = "hashicorp/aws"
        version = "4.34.0"
        }
    }
}

provider "aws" {
region = "eu-central-1"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDMcwTD1SesoFg4vy/ohzxJV7Fjqt2u4gd1epuP3iLnnp7hVveI7ryY64TzMSIBhExNpvEOfrsxVYTXPY1AQ6pL5BAdMquIvqHqfP8Oj9tgcJ3B5aqv8dV35mCFsMFhJbWT50HRRQEp98ULK0XavciHZ4Vt94Bf2RacoQ8QQlZ8IF4qA5j/DneVCsfBI5IY4kqPfehWEDSAq94Fxo8Jn3ZhGBUkMyV+K0y0MkyBeFdLGBhzy4+YckAe/ejOVxkHx9SzKTtZKobPVEJdxUMXGhlW0tGbi0m3uft9ln4SgubDZAQlPNsgJVxAfZXTj05TriCg67TgXuTK+DkAi29Jl2RVi+tpbhiHGS61uYM49gwVnp+HMjGNe0MFYrcSVETgFa8vJnQss3/CN6YShmqYOmuQzgX7aovnMshR9eeR0KjVwYkeJKx9XLdAvPFluXPEFTJnOl9cfO9n9XlReONhofONt5UnIZOACF3OoE5CXPkKwNxQD8KQ5Qd342Xisb9pROs= witek@LAPTOP-MMA7ERF7"
}

data "template_file" "user_data" {
	template = file("./userdata.yml")
}

data "aws_vpc" "main" {
  id = "vpc-09777b4e5d4086c1c"
}

resource "aws_instance" "witek_server" {
  ami           = "ami-05ff5eaef6149df49"
  instance_type = "t2.micro"
	    key_name = "${aws_key_pair.deployer.key_name}"
        vpc_security_group_ids = [aws_security_group.sg_witek_server.id] 
        user_data = data.template_file.user_data.rendered 
  tags = {
    Name = "witek_server"
  }
}

resource "aws_security_group" "sg_witek_server" {
  name        = "sg_witek_serwer"
  description = "witek_server security group"
  vpc_id      = data.aws_vpc.main.id

  ingress = [
    {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    			    prefix_list_ids  = []
			        security_groups = []
		        	self = false
  },
  {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["5.173.224.101/32"]
    ipv6_cidr_blocks = []
        			prefix_list_ids  = []
			        security_groups = []
		        	self = false
  }
  ]
  egress = [
    {
            description = "outgoing traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
        			prefix_list_ids  = []
			        security_groups = []
		        	self = false
  }
  ]
}

output "public_ip" {
  value = aws_instance.witek_server
}