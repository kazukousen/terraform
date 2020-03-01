provider "aws" {
  region = "ap-northeast-1"
}

variable "example_instance_type" {
  default = "t3.micro"
}

locals {
  example_tags_name = "example"
}

resource "aws_security_group" "example_ec2" {
  name = "example-ec2"

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_instance" "example" {
  ami                    = "ami-0af1df87db7b650f4"
  instance_type          = var.example_instance_type
  vpc_security_group_ids = [aws_security_group.example_ec2.id]

  tags = {
    Name = local.example_tags_name
  }

  user_data = file("./user_data.sh")
}

output "example_instance_id" {
  value = aws_instance.example.id
}

output "example_public_dns" {
  value = aws_instance.example.public_dns
}
