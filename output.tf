output "print_public_ip" {
  value = aws_instance.my-instance-01.public_ip
}
