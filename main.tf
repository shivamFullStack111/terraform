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

# this is local values block in this block we can declare a variables. 
# in this variables we cannot provide values outside the file.
locals {
  instance_type = "t2.nano"
}

output "instance-type" {
  value = local.instance_type
}
