terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.4.0"
    }
  }

  # this manage terraform state .tfstate file in s3 bucket 
  backend "s3" {
    bucket = "my-buckert-483943"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}

provider "aws" {
  region = "ap-south-1"
}

# create s3 bucket 
resource "aws_s3_bucket" "my-bucket" {
  bucket = "my-buckert-for-static-hosting-5667"
}

# upload index.html file to s3
resource "aws_s3_bucket_object" "index-html-file" {
  bucket       = aws_s3_bucket.my-bucket.bucket
  source       = "./index.html"
  key          = "index.html"
  content_type = "text/html" // this help to known s3 that file is html type and render correctly in static website hosting

}
# upload index.css file to s3 
resource "aws_s3_bucket_object" "index-css-file" {
  key          = "index.css"
  bucket       = aws_s3_bucket.my-bucket.bucket
  source       = "./index.css"
  content_type = "text/css" // this help to correctly apply css to index.html 

}

# change policy of s3 bucket to access static website
resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.my-bucket.id
  # jsondecode convert hcl to json and change polity in s3 bucket 
  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Sid       = "Statement1"
          Effect    = "Allow"
          Principal = "*"
          Action    = "s3:GetObject"
          Resource  = "arn:aws:s3:::${aws_s3_bucket.my-bucket.id}/*"
        }
      ]
    }
  )
}

# enable public access for static website hosting
resource "aws_s3_bucket_public_access_block" "example" {
  bucket                  = aws_s3_bucket.my-bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


# this block enable static website hosting and provide index.html as root for access 
resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.my-bucket.id
  index_document {
    suffix = "index.html"
  }
}

# this print endpoint/url of static website hosting
output "print-static-website-endpoint" {
  value = aws_s3_bucket_website_configuration.example.website_endpoint
}
