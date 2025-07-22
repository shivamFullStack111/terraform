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

# this block fetch users from users.yaml file 
# using file() function it require users but it comes in yaml format 
# yamldecode() function decode yaml code to HCL and it return an array 
# toset() is used to create set of users username 
locals {
  users = toset(yamldecode(file("./users.yaml")).users[*].username)
}

# this block create users by using for_each to create multiple users 
resource "aws_iam_user" "users" {
  for_each      = local.users
  name          = each.key
  force_destroy = true

}

# this block create password of users 
resource "aws_iam_user_login_profile" "users_login_data" {
  for_each        = aws_iam_user.users
  user            = each.key
  password_length = 8 // password generate automatically of length 8


  # this block avoid changes fields that mention below when code run again 
  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
    ]
  }
}

output "users" {
  value = aws_iam_user.users
}

output "users_logins" {
  value = aws_iam_user_login_profile.users_login_data
}



# NOTE:  password will store in terraform.tfstate 