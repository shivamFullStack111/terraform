resource "aws_instance" "this" {
  ami           = var.instance_config.ami
  instance_type = var.instance_config.instance_type
  tags = {
    Name = var.instance_config.name
  }
}
