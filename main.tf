provider "aws" {
  region = "ap-south-1"
}

# this block use module that i create
module "my-module" {
   source = "./module/instance"// in source we have to provide location of custom module 

  instance_config = { 
    ami = "ami-0b32d400456908bf9"
    instance_type = "t2.nano"
    name = "my-instance"
  }
}