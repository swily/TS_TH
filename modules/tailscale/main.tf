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

resource "aws_instance" "tailscale" {
  ami           = "ami-0171b34d29a6f3fef" # PublicSubnetTS
  instance_type = "t2.micro"
  key_name      = "TSKey"

  tags = {
    Name = "TailScaleSubnetServer"
  }

  vpc_security_group_ids = [aws_security_group.tailscale_sg.id]
}

resource "aws_instance" "private" {
  ami           = "ami-0205458429ac8ef1b" # PrivateSubnetTS
  instance_type = "t2.micro"
  key_name      = "TSKey"

  tags = {
    Name = "TailScalePrivateSubnet"
  }

  vpc_security_group_ids = [aws_security_group.private_sg.id]
}

