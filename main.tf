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

# ---------------------------------------------
# Step 1: users.yaml file ko read karna
# Format of users.yaml:
# users:
#   - username: "shivam"
#     roles: ["AdministratorAccess", "AmazonS3FullAccess"]
#   - username: "ram"
#     roles: ["AmazonEC2FullAccess"]
#   - username: "sham"
#     roles: ["AmazonS3FullAccess"]
# ---------------------------------------------
locals {
  users = yamldecode(file("./users.yaml")).users

  # Step 2: flatten ka matlab har (user, role) pair ko ek entry banana
  # Taaki har role ke liye ek alag resource ban sake
  #
  # Expected Output of flatten_users:
  # [
  #   { name = "shivam", role = "AdministratorAccess" },
  #   { name = "shivam", role = "AmazonS3FullAccess" },
  #   { name = "ram",    role = "AmazonEC2FullAccess" },
  #   { name = "sham",   role = "AmazonS3FullAccess" }
  # ]
  #
  flatten_users = flatten([
    for user in local.users : [
      for role in user.roles : {
        name = user.username
        role = role
      }
    ]
  ])
}

# ---------------------------------------------
# Step 3: IAM User banane ka resource
# Hum har unique username ke liye IAM user banayenge
# Expected usernames:
# ["shivam", "ram", "sham"]
# Isme roles ka lena-dena nahi, ek user sirf ek baar banega
# ---------------------------------------------
resource "aws_iam_user" "users" {
  for_each = toset(local.users[*].username)

  name = each.key

  # Output Example:
  # aws_iam_user.users["shivam"] => creates IAM user with name "shivam"
  # aws_iam_user.users["ram"]    => creates IAM user with name "ram"
  # aws_iam_user.users["sham"]   => creates IAM user with name "sham"
}

# ---------------------------------------------
# Step 4: IAM Policy Attachments
# Har user-role pair ke liye ek resource banega
# for_each me key banai: "shivam-AdministratorAccess"
# Har key se user ka naam aur role milta hai
# uske basis par policy attach hoti hai
# ---------------------------------------------
resource "aws_iam_user_policy_attachment" "user_policies" {
  for_each = {
    for pair in local.flatten_users :
    "${pair.name}-${pair.role}" => pair
  }

  user       = aws_iam_user.users[each.value.name].name
  policy_arn = "arn:aws:iam::aws:policy/${each.value.role}"

  # Output Example:
  # aws_iam_user_policy_attachment.user_policies["shivam-AdministratorAccess"]
  # => attaches AdministratorAccess to shivam
  #
  # aws_iam_user_policy_attachment.user_policies["shivam-AmazonS3FullAccess"]
  # => attaches AmazonS3FullAccess to shivam
  #
  # aws_iam_user_policy_attachment.user_policies["ram-AmazonEC2FullAccess"]
  # => attaches AmazonEC2FullAccess to ram
  #
  # aws_iam_user_policy_attachment.user_policies["sham-AmazonS3FullAccess"]
  # => attaches AmazonS3FullAccess to sham
}

# ---------------------------------------------
# Final Output: Sabhi policy attachments ka output
# Isme key-value pair aayega: key = "username-policyname"
# ---------------------------------------------
output "users" {
  value = aws_iam_user_policy_attachment.user_policies
}
