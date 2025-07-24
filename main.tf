provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "shivam-lifecycle-demo-bucket"
  force_destroy = false

  tags = {
    Name        = "LifecycleBucket"
    Environment = "Dev"
  }

  lifecycle {
    # 🛑 prevent_destroy:
    # Prevents accidental deletion of the S3 bucket.
    # If someone tries to delete this bucket using 'terraform destroy', an error will be thrown.
    prevent_destroy = true

    # 🔁 create_before_destroy:
    # When changes require replacing this bucket, Terraform will create the new one first,
    # then destroy the old one. This avoids service downtime.
    create_before_destroy = true

    # 🎯 ignore_changes:
    # If the tags are changed manually (e.g., via AWS Console),
    # Terraform will ignore those changes during future plans.
    ignore_changes = [
      tags
    ]

    # 🔄 replace_triggered_by:
    # This forces the S3 bucket to be recreated if the "tags.Name" value changes.
    replace_triggered_by = ["tags.Name"]
  }
}
