// variable 
variable "reusable_region" {
  type        = string
  description = "this is reusable region"
  default     = "ap-south-1"

}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.4.0"
    }
  }
}

provider "aws" {
  region = var.reusable_region // use custom variable 
}

resource "aws_instance" "my-instence" {
  ami           = "ami-0a1235697f4afa8a4"
  instance_type = "t2.micro"
  tags = {
    Name = "my-instence"
  }
}
