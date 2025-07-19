terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.4.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "my-server-01" {
  ami           = "ami-0a1235697f4afa8a4"
  instance_type = "t2.micro"

  tags = {
    Name = "my-tag"
    
  }
}

