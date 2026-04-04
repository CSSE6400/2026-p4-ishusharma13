terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["./credentials"]
  default_tags {
    tags = {
      Environment = "Dev"
      Course      = "CSSE6400"
      StudentID   = "s4921211"
    }
  }
}

resource "aws_security_group" "hextris_sg" {
  name        = "hextris-sg"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

resource "aws_instance" "hextris" {
  ami                    = "ami-0c02fb55956c7d316"  # Replace if your lab specifies a different AMI
  instance_type          = "t2.micro"
  key_name               = "labsuser"
  vpc_security_group_ids = [aws_security_group.hextris_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd git
              sudo systemctl enable httpd
              sudo systemctl start httpd
              cd /var/www/html
              sudo git clone https://github.com/Hextris/hextris .
              EOF

  tags = {
    Name = "HextrisLab"
  }
}