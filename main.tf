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

variable "list_0f_num" {
  type    = list(number)
  default = [0, 1, 2, 3, 4, 5]
}

variable "person" {
  type = object({
    name  = string
    class = string
  })
  default = {
    name  = "shivam"
    class = "+2 Arts"
  }
}


variable "map_var" {
  type = map(number)
  default = {
    ram   = 20
    sham  = 40
    karan = 38
  }
}


locals {
  list_of_num_double = [for num in var.list_0f_num : num * 2]
  # this loop again create map by doubling the current value 
  map_var_double = { for key, value in var.map_var : key => value * 2 }
}


output "list_of_num_double" {
  value = local.list_of_num_double
}
output "map_var_double" {
  value = local.map_var_double
}
