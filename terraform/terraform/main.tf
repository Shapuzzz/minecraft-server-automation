provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "minecraft_sg" {
  name = "minecraft-sg"

  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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
  ami           = "ami-05ffe3c48a9991133"
  instance_type = var.instance_type

  vpc_security_group_ids = [
    aws_security_group.minecraft_sg.id
  ]

  tags = {
    Name = "minecraft-server"
  }
}
