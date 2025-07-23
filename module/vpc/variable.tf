# ------------------------------------------------------------------
# Variable: vpc_config
# Purpose: Accepts basic VPC configuration
# Type: Object with 'cidr_block' and 'name'
# Example:
# vpc_config = {
#   cidr_block = "10.0.0.0/16"
#   name       = "my-vpc"
# }
# ------------------------------------------------------------------
variable "vpc_config" {
  type = object({
    cidr_block = string       # 👈 Entire VPC CIDR range
    name       = string       # 👈 VPC tag name
  })
}

# ------------------------------------------------------------------
# Variable: subnet_config
# Purpose: Accepts list of subnet definitions
# Type: List of objects with subnet details
# Optional Field: is_public (default = false)
#
# Example:
# subnet_config = [
#   {
#     cidr_block        = "10.0.1.0/24"
#     availability_zone = "ap-south-1a"
#     is_public         = true
#   },
#   {
#     cidr_block        = "10.0.2.0/24"
#     availability_zone = "ap-south-1b"
#     # is_public not provided => treated as false
#   }
# ]
# ------------------------------------------------------------------
variable "subnet_config" {
  type = list(object({
    cidr_block        = string            # 👈 Subnet CIDR
    availability_zone = string            # 👈 AZ in which subnet will be created
    is_public         = optional(bool, false)  # 👈 Optional, default = false
  }))
}


