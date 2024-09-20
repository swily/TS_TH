terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.3.0"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_security_group" "tailscale_sg" {
  name        = "tailscale_sg"
  description = "Allow SSH and Tailscale traffic"

  ingress {
    from_port   = 22  # Allow SSH
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # all traffic since demo
  }

  ingress {
    from_port   = 41641  # Tailscale port
    to_port     = 41641
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_sg" {
  name        = "private_sg"
  description = "Allow only internal traffic"

  ingress {
    from_port   = 22  # Allow SSH from the Tailscale server
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.tailscale_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "tailscale" {
  source = "./modules/tailscale"
}

