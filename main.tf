terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.4.0"
    }

  }

  # this store .tfstate file in s3 and directly use from the bucket 
  backend "s3" {
    region = "ap-south-1"
    bucket = "my-buckert-483943" // bucket name 
    key    = "terraform.tfstate" // .tfstate filename that store in s3 
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "my-server" {
  ami           = "ami-0a1235697f4afa8a4"
  instance_type = "t2.nano"
}


