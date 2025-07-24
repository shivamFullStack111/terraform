provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0c94855ba95c71c99"  # Replace with valid AMI for your region
  instance_type = "t2.micro"
  subnet_id     = "subnet-xxxxxxxx"        # Replace with your subnet ID
  key_name      = "your-key-name"          # Replace with your key pair name

  tags = {
    Name = "SelfExampleInstance"
  }

  lifecycle {
    # `self` refers to the resource after creation.
    # You can access attributes like id, availability_zone, public_ip, and tags.

    postcondition {
      # Ensure the instance is launched in the desired Availability Zone
      condition     = self.availability_zone == "us-east-1a"
      error_message = "Instance must be launched in us-east-1a"
    }
  }
}
