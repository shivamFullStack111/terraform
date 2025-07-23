# ------------------------------------------------------------------
# Create VPC
# ------------------------------------------------------------------
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_config.cidr_block         # 👈 VPC ka CIDR block from input variable
  tags = {
    Name = var.vpc_config.name                   # 👈 VPC ka naam tag
  }
}

# ------------------------------------------------------------------
# Create Subnets using for_each
# Each subnet config is passed from subnet_config variable
# ------------------------------------------------------------------
resource "aws_subnet" "my-subnets" {
  for_each = { for sub in var.subnet_config : sub.cidr_block => sub }

  vpc_id            = aws_vpc.my_vpc.id                         # 👈 Subnet ka VPC ID
  cidr_block        = each.value.cidr_block                     # 👈 Subnet ka CIDR
  availability_zone = each.value.availability_zone             # 👈 AZ in which this subnet will be created

  tags = {
    Name = "${var.vpc_config.name}-subnet"                     # 👈 Common naming format
  }
}

# ------------------------------------------------------------------
# Local Value: Filter only public subnets (those having is_public = true)
# This will be used to create IGW and Route Table conditionally
# ------------------------------------------------------------------
locals {
  public_subnets = {
    for sub in var.subnet_config : sub.cidr_block => sub if sub.is_public
  }
}

# ------------------------------------------------------------------
# Internet Gateway (only if there are public subnets)
# ------------------------------------------------------------------
resource "aws_internet_gateway" "my_internet_gateway" {
  count  = length(local.public_subnets) > 0 ? 1 : 0              # 👈 IGW create only if any public subnet exists
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my_internet_gateway"
  }
}

# ------------------------------------------------------------------
# Route Table (for public subnets only)
# Adds route to IGW for 0.0.0.0/0
# ------------------------------------------------------------------
resource "aws_route_table" "my_route_table" {
  count  = length(local.public_subnets) > 0 ? 1 : 0              # 👈 Route Table only for public subnet
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"                                     # 👈 Internet route
    gateway_id = aws_internet_gateway.my_internet_gateway[0].id # 👈 Use IGW created above
  }

  tags = {
    Name = "my_route_table"
  }
}

# ------------------------------------------------------------------
# Route Table Association for all public subnets
# Link each public subnet to the public route table
# ------------------------------------------------------------------
resource "aws_route_table_association" "aws_route_table_association" {
  for_each = local.public_subnets                                # 👈 Associate only public subnets

  subnet_id      = aws_subnet.my-subnets[each.key].id            # 👈 Match by subnet CIDR key
  route_table_id = aws_route_table.my_route_table[0].id          # 👈 Use the only route table created
}
