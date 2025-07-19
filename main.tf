

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.4.0"
    }

    random = { // for random provider
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# random id generate 
resource "random_id" "randomId" {
  byte_length = 4
}

# test the random id by print 
output "random-id-output" {
  value = random_id.randomId.dec
}


resource "aws_s3_bucket" "my-bucket" {
  bucket = "my-bucket-${random_id.randomId.b64_url}" // use random id to avoid duplicate s3 bucket
}

resource "aws_s3_object" "my-object" {
  bucket = aws_s3_bucket.my-bucket.bucket
  source = "./myTextfile"
  key    = "myfile"
}
