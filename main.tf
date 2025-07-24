provider "aws" {
  region = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"

  validation {
    condition     = contains(["t2.micro", "t3.micro"], var.instance_type)
    error_message = "Only 't2.micro' or 't3.micro' instance types are allowed."
  }
}

resource "aws_instance" "validated_instance" {
  ami                    = "ami-0c94855ba95c71c99" # Replace with a valid AMI for your region
  instance_type          = var.instance_type
  subnet_id              = "subnet-xxxxxxxx"       # Replace with your actual subnet
  vpc_security_group_ids = ["sg-xxxxxxxx"]         # Replace with your actual security group
  key_name               = "your-key-name"         # Replace with your key pair

  tags = {
    Name = "ValidatedEC2"
  }

  lifecycle {
    # ✅ Precondition: restrict allowed instance types before creation
    precondition {
      condition     = contains(["t2.micro", "t3.micro"], var.instance_type)
      error_message = "Precondition failed: instance_type must be 't2.micro' or 't3.micro'"
    }

    # ✅ Postcondition: ensure instance is created in specific AZ
    postcondition {
      condition     = self.availability_zone == "us-east-1a"
      error_message = "Postcondition failed: instance must be created in us-east-1a"

      # ⚠️ NOTE: If this condition fails, Terraform will destroy the EC2 instance immediately.
      #         It will not remain in the final state, even though it was temporarily created.
    }
  }
}
