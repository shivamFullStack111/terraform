provider "aws" {
  region = "us-east-1"
}

# Step 1: Create a Security Group
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = "vpc-xxxxxxxx" # <-- replace with your actual VPC ID

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WebSG"
  }
}

# Step 2: Launch EC2 instance that depends explicitly on the security group
resource "aws_instance" "web_server" {
  ami           = "ami-0c94855ba95c71c99" # <-- Amazon Linux 2 AMI (update per region)
  instance_type = "t2.micro"
  subnet_id     = "subnet-xxxxxxxx"      # <-- replace with your actual Subnet ID
  key_name      = "your-key-name"        # <-- replace with your EC2 key pair name

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "DependsOnEC2"
  }

  # 👇 Explicit dependency
  depends_on = [aws_security_group.web_sg]
}
