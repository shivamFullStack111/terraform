# ----------------------------------------
# AWS Provider Block
# ----------------------------------------
provider "aws" {
  region = "ap-south-1"  # 👈 This sets the AWS region where all resources will be deployed (Mumbai region)
}

# ----------------------------------------
# VPC Module Block
# ----------------------------------------
module "vpc_module" {
  source = "./module/vpc"  # 👈 Refers to a local Terraform module located in 'module/vpc' directory

  # -------------------------------
  # List of Subnets to be created
  # -------------------------------
  subnet_config = [
    {
      availability_zone = "ap-south-1a",     # 👈 First subnet in AZ 'a'
      cidr_block        = "10.0.0.0/24"      # 👈 256 IPs in this range
    },
    {
      availability_zone = "ap-south-1b",     # 👈 Second subnet in AZ 'b'
      cidr_block        = "10.0.1.0/24"
    },
    {
      availability_zone = "ap-south-1c",     # 👈 Third subnet in AZ 'c'
      cidr_block        = "10.0.2.0/24",
      is_public         = true              # ✅ This subnet is marked public. Useful for EC2s that need internet
    },
  ]

  # -------------------------------
  # VPC Configuration
  # -------------------------------
  vpc_config = {
    cidr_block = "10.0.0.0/16",   # 👈 Full VPC has 65536 IPs (large private IP block)
    name       = "vpc-test"       # 👈 Name tag used in resources for identification
  }
}
