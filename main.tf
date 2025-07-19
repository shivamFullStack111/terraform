// output start ----------------

output "my-instence-id" {
  value = aws_instance.my-instence.id
}

// output end ----------------------------



terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.4.0"
    }
  }
}


provider "aws" {
  region = "ap-south-1" // use custom variable 
}

resource "aws_instance" "my-instence" {
  ami           = "ami-0a1235697f4afa8a4"
  instance_type = "t2.micro"
  tags = {
    Name = "my-instence"
  }
}
