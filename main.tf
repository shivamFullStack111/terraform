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

variable "ami_map" {
  type = map(object({
    ami           = string
    instance_type = string
  }))

  default = {
    "amazon" = {
      ami           = "ami-0b32d400456908bf9"
      instance_type = "t2.nano"
    }
    "ubuntu" = {
      ami           = "ami-0f918f7e67a3323f0"
      instance_type = "t2.nano"
    }
  }
}


resource "aws_instance" "my-instance" {
  for_each      = var.ami_map // for each work with only set or map
  ami           = each.value.ami
  instance_type = each.value.instance_type
  tags = {
    "Name" = "my-instance-${index(keys(var.ami_map), each.key)}-ami=>${each.key}" // in this we find index of current iteration key keys() get all keys from map and index find(map,single_key) this find current key index from map
  }
}
