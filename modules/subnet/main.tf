# ======================================================
# PUBLIC SUBNET
# ======================================================
resource "aws_subnet" "public" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.az1
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet"
  }
}

# ======================================================
# PRIVATE SUBNET 1
# ======================================================
resource "aws_subnet" "private1" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnet1_cidr
  availability_zone = var.az1

  tags = {
    Name = "Private-Subnet-1"
  }
}

# ======================================================
# PRIVATE SUBNET 2
# ======================================================
resource "aws_subnet" "private2" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnet2_cidr
  availability_zone = var.az2

  tags = {
    Name = "Private-Subnet-2"
  }
}

# ======================================================
# PUBLIC ROUTE TABLE
# ======================================================
resource "aws_route_table" "public_rt" {
  vpc_id = var.vpc_id

  tags = {
    Name = "Public-RT"
  }
}

#  Route → IGW (from VPC module)
resource "aws_route" "public_internet_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.igw_id
 }

# Associate Public Subnet to Public RT
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# ======================================================
# PRIVATE ROUTE TABLE
# ======================================================
resource "aws_route_table" "private_rt" {
  vpc_id = var.vpc_id

  tags = {
    Name = "Private-RT"
  }
}

#  Route → NAT Gateway (from NAT module)
resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gw_id
 }

# Associate Private Subnets with Private RT
resource "aws_route_table_association" "private1_assoc_rt" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private2_assoc_rt" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private_rt.id
}

# ======================================================
# PRIVATE SUBNET NACL
# ======================================================
resource "aws_network_acl" "private_nacl" {
  vpc_id = var.vpc_id

  ingress {
    rule_no    = 100
    protocol   = "tcp"
    from_port  = 22
    to_port    = 22
    cidr_block = "172.31.0.0/16"
    action     = "allow"
  }

  ingress {
    rule_no    = 110
    protocol   = "tcp"
    from_port  = 22
    to_port    = 22
    cidr_block = "10.0.1.0/24"
    action     = "allow"
  }

  ingress {
    rule_no    = 120
    protocol   = "tcp"
    from_port  = 3306
    to_port    = 3306
    cidr_block = "172.31.0.0/16"
    action     = "allow"
  }

  ingress {
    rule_no    = 130
    protocol   = "tcp"
    from_port  = 3306
    to_port    = 3306
    cidr_block = "10.0.1.0/24"
    action     = "allow"
  }
  ingress {
   rule_no    = 140
   protocol   = "tcp"
   from_port  = 3306
   to_port    = 3306
   cidr_block = "10.0.2.0/24"   # master subnet
   action     = "allow"
  }

  ingress {
   rule_no    = 150
   protocol   = "tcp"
   from_port  = 3306
   to_port    = 3306
   cidr_block = "10.0.3.0/24"   # slave subnet
   action     = "allow"
  }

  ingress {
    rule_no    = 160
    protocol   = "tcp"
    from_port  = 1024
    to_port    = 65535
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }
 
  egress {
    rule_no    = 100
    protocol   = "-1"
    from_port  = 0
    to_port    = 0
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }
  

  tags = {
    Name = "Private-NACL"
  }
}

resource "aws_network_acl_association" "nacl_assoc_private1" {
  network_acl_id = aws_network_acl.private_nacl.id
  subnet_id      = aws_subnet.private1.id
}

resource "aws_network_acl_association" "nacl_assoc_private2" {
  network_acl_id = aws_network_acl.private_nacl.id
  subnet_id      = aws_subnet.private2.id
}
