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

resource "aws_instance" "my-instance" {
  ami           = "ami-0a1235697f4afa8a4"
  instance_type = "t2.micro"
  count = 2 // this line count = 2 create 2 instance means this line run this block 2 times
  tags = {
    Name = "my-instance-${count.index}" // count.index is index which starts from 0 to n-1 
  }
}
