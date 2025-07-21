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

# fetch vpc 
data "aws_vpc" "my-vpc" {
  tags = {
    Name = "my-vpc"
  }
}
# fetch security group NOTE: security must be in same vpc in which subnet is 
data "aws_security_group" "my-security-group" {
  tags = {
    Name = "my-security-group"
  }
}

# fetch subnet  NOTE: subnet must be in same vpc in which security group is 
data "aws_subnet" "vpc-public-subnet" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.my-vpc.id]
  }
  tags = {
    Name = "public-subnet"
  }
}

# creating instance by using data source data 
resource "aws_instance" "my-instance-01" {
  ami             = "ami-0a1235697f4afa8a4"
  instance_type   = "t2.nano"
  security_groups = [data.aws_security_group.my-security-group.id]
  subnet_id       = data.aws_subnet.vpc-public-subnet.id
}




# outputs ----------------------------------------------------------------------
output "name" {
  value = data.aws_security_group.my-security-group.id
}
output "namee" {
  value = data.aws_vpc.my-vpc.id
}
output "nameee" {
  value = data.aws_subnet.vpc-public-subnet.id
}
# -------------------------------------------------------------------------------
