resource "aws_vpc" "my_vps_01" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my_vps_01"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.my_vps_01.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "private_subnet"
  }
}
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vps_01.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "public_subnet"
  }
}

resource "aws_internet_gateway" "my-internet-gateway" {
  vpc_id = aws_vpc.my_vps_01.id
  tags = {
    Name = "my-internet-gateway"
  }
}

resource "aws_route_table" "my-route-table" {
  vpc_id = aws_vpc.my_vps_01.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-internet-gateway.id
  }
  tags = {
    Name = "my-route-table"
  }
}

resource "aws_route_table_association" "route-table-association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.my-route-table.id
}
