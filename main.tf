terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-west-2"
  shared_credentials_files = ["./credentials"]
}

resource "aws_key_pair" "deployer" {
  key_name   = "minecraft_ssh"
  public_key = file("[PATH TO YOUR PUBLIC KEY FILE HERE]")
}

resource "aws_security_group" "ssh_access" {
  name        = "ssh_access"
  description = "SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "minecraft_server" {
  ami           = "ami-0eb9d67c52f5c80e5"
  instance_type = "t2.large"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids        = [aws_security_group.ssh_access.id]

  tags = {
    Name = "minecraft-server"
  }
}


output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.minecraft_server.id
}
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.minecraft_server.public_ip
}

