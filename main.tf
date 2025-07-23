terraform {
  required_providers {
    name = {
      source  = "hashicorp/aws"
      version = "6.4.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}


variable "my_var" {
  type    = bool
  default = true
}

resource "aws_instance" "my-instance" {
  # In this line, if the value of `my_var` is true, then count will be set to 1,
  # which means the resource block will execute once and one instance will be created.
  # If the value of `my_var` is false, then count will be set to 0,
  # which means this resource block will not run and no instance will be created.

  count = var.my_var == true ? 1 : 0

  ami           = "ami-0b32d400456908bf9"
  instance_type = "t2.nano"
  tags = {
    Name = "my-instance"
  }
}

