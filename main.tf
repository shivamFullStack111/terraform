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

# fetch AMI from AWS using data source
data "aws_ami" "example" {
  most_recent = true
  owners      = ["amazon"]
}

# fetch my security groups using data source
data "aws_security_group" "my_security_group" {
  tags = {
    sg = "my-sg"
  }
}
# fetch default VPC using data source
data "aws_vpc" "default_vpc" {
  tags = {
    default = "default-vpc"
  }
}

output "AMI-ID" {
  value = data.aws_ami.example.name
}
output "my-SG" {
  value = data.aws_security_group.my_security_group.id
}
output "default-vpc" {
  value = data.aws_vpc.default_vpc.id
}
