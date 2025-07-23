# ------------------------------------------------------------------------------
# Terraform Block: Defines the required versions of Terraform & providers
# ------------------------------------------------------------------------------

terraform {
  # 👇 This tells Terraform CLI that minimum required version should be 1.0
  # If user's installed version is below 1.0, init or apply will fail.
  required_version = ">=1.0"

  # 👇 Provider requirements block
  required_providers {
    aws = {
      source  = "hashicorp/aws"   # 👈 Specifies the source of the AWS provider
      version = ">=6.4.0"         # 👈 Enforces minimum AWS provider version
    }
  }
}
