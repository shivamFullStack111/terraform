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



# create vpc 
resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my-vpc"
  }
}

# create private subnet 
resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "private-subnet"
  }
}

# create public subnet 
resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "public-subnet"
  }
}

# create internet gateway 
resource "aws_internet_gateway" "my-internet-gateway" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "my-internet-gateway"
  }
}

# create route table 
resource "aws_route_table" "my-route-table" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-internet-gateway.id
  }
  tags = {
    Name = "my-route-table"
  }
}

# route table association  connect route table with public subnet and internet gateway
resource "aws_route_table_association" "my-route-table-association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.my-route-table.id
}

# creating ec2 instance in vpc
resource "aws_instance" "my-instance" {
  ami           = "ami-0a1235697f4afa8a4"
  instance_type = "t2.nano"
  subnet_id = aws_subnet.public-subnet.id
  tags = {
    Name = "my-instance-01"
  }
}
