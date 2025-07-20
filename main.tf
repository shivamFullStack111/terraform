terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.4.0"
    }

  }
  backend "s3" {
    region = "ap-south-1"
    bucket = "my-bucket-987789"
    key    = "terraform.tfstate"
  }
}

provider "aws" {
  region = "ap-south-1"
}


resource "aws_instance" "my-instance-01" {
  ami                         = "ami-0a1235697f4afa8a4"
  instance_type               = "t2.nano"
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.my_security_group.id]
  associate_public_ip_address = true
  user_data                   = <<-EOF
  #!/bin/bash
  sudo yum update -y 
  sudo yum install nginx -y
  sudo systemctl start nginx
  EOF

  tags = {
    Name = "my-instance-01"
  }
}
