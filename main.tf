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

# this is simple variable
variable "aws_bucket" {
  type    = string
  default = "my-bucket-049438"
}

# default value is not provided this will ask you value in terminal with their description as a message 
# or we can provide value in terminal using ENV by writting =>     $env:TF_VAR_aws_ami = "ami-1234567890abcdef" (Windows) ,  export TF_VAR_aws_ami=ami-833773374 (Linux,macOS)  
variable "aws_ami" {
  type        = string
  description = "Enter aws ami for instance"
}

# when we have to store multiple data in same varibale then use object ACCESS: var.aws_block.name
variable "aws_block" {
  type = object({
    name  = string
    class = string
  })

  default = {
    name  = "Shivam"
    class = "+2 Arts"
  }
}

# map which is key value pair 
variable "map_variable" {
  type = map(string)
  default = {
    "this_is_key" = "this_is_value"
  }
}





# outputs-----------------------------------------------------------------------

output "ami" {
  value = var.aws_ami
}
output "aws_block" {
  value = "studnet details => Name: ${var.aws_block.name}, Class: ${var.aws_block.class}"
}
output "map_variable" {
  value = var.map_variable
}

# ------------------------------------------------------------------------------
