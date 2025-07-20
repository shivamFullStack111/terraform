resource "aws_security_group" "my_security_group" {
  vpc_id = aws_vpc.my_vps_01.id
  tags = {
    Name = "my_security_group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "inbound-role" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
