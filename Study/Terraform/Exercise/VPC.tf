# Main VPC us-west 2
resource "aws_vpc" "main_vpc" {
  cidr_block       = var.VPC
  instance_tenancy = var.profile

  tags = {
    Name = "main_vpc"
  }
}

#***********************************************Internet subnet and associated resources******************************************

# Internet subnet in multiple AZ, in order to support Application Load Balancer. Direct internet access through Internet gateway
# It is assumed in the example that length(var.internet_subnet_block) <= var.az_list[count.index]
resource "aws_subnet" "internet_subnet" {
  count             = length(var.internet_subnet_block)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.internet_subnet_block[count.index]
  availability_zone = join("", [var.aws_region, var.az_list[count.index]])

  tags = {
    Name = join("", ["Internet subnet ", var.aws_region, var.az_list[count.index]])
  }
}

# Internet Gateway
resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "internet_gw"
  }
}

# Route for internet subnet
resource "aws_route_table" "internet_subnet_routes" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw.id
  }

  tags = {
    Name = "internet_subnet_routes"
  }
}

# Internet subnet/internet route association
resource "aws_route_table_association" "internet_subnet_routes_association" {
  count          = length(var.internet_subnet_block)
  subnet_id      = aws_subnet.internet_subnet[count.index].id
  route_table_id = aws_route_table.internet_subnet_routes.id

}

# Security group to use for all resources in the internet facing subnet
resource "aws_security_group" "internet_subnet_sg" {
  name        = "internet_subnet_sg"
  description = "Allow http,https for all resources in the internet facing subnet"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
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
    Name = "internet_subnet_sg"
  }
}

#***********************************************Public subnet and associated resources******************************************

# Public subnet, internet access through NAT Gateway
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.public_subnet_block
  availability_zone = join("", [var.aws_region, var.az_list[0]])

  tags = {
    Name = "public_subnet"
  }
}

# Elastic IP for NAT GW 
resource "aws_eip" "nat_gateway_ip" {
  vpc = true
}

# NAT Gateway for public subnet, allowing internet traffic out for updates etc.
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway_ip.id
  subnet_id     = aws_subnet.internet_subnet[0].id
  tags = {
    "Name" = "nat_gateway"
  }

  depends_on = [aws_internet_gateway.internet_gw, aws_eip.nat_gateway_ip]
}

# Route for public subnet
resource "aws_route_table" "public_subnet_routes" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "public_subnet_routes"
  }
}

# Public subnet/public route association
resource "aws_route_table_association" "public_subnet_routes_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_subnet_routes.id

}

# Security group to use for all resources in the public subnet
resource "aws_security_group" "public_subnet_sg" {
  name        = "public_subnet_sg"
  description = "Allow http,https from internet subnet"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description     = "HTTP"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.internet_subnet_sg.id]
  }
  ingress {
    description     = "HTTPS"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.internet_subnet_sg.id]
  }
  ingress {
    description     = "SSH"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public_subnet_sg"
  }
}

#***********************************************Private subnet and associated resources******************************************

# Private subnet in multiple AZ, in order to support Amazon RDS. Internet access is forbidden
# It is assumed in the example that length(var.private_subnet_block) <= var.az_list[count.index]
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_block)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_block[count.index]
  availability_zone = join("", [var.aws_region, var.az_list[count.index]])

  tags = {
    Name = join("", ["Private subnet ", var.aws_region, var.az_list[count.index]])
  }
}

# Security group to use for all resources in the private subnet
resource "aws_security_group" "private_subnet_sg" {
  name        = "private_subnet_sg"
  description = "Allow 3306 TCP IN from Public Subnet"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description     = "MySQL"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.public_subnet_sg.id]
  }

  tags = {
    Name = "private_subnet_sg"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db_subnet_group"
  subnet_ids = [for subnet in aws_subnet.private_subnet : subnet.id]

  tags = {
    Name = "DB Subnet group"
  }
}