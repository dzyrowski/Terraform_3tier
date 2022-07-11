##networking2##
# Create a VPC
resource "aws_vpc" "week22vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "week22vpc"
  }
}

# Create Web Public Subnet
resource "aws_subnet" "web-subnet" {
  count                   = var.item_count
  vpc_id                  = aws_vpc.week22vpc.id
  cidr_block              = var.web_subnet_cidr[count.index]
  availability_zone       = var.availability_zone_names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Web-${count.index}"
  }
}

# Create Application Public Subnet
resource "aws_subnet" "application-subnet" {
  count                   = var.item_count
  vpc_id                  = aws_vpc.week22vpc.id
  cidr_block              = var.application_subnet_cidr[count.index]
  availability_zone       = var.availability_zone_names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "Application-${count.index}"
  }
}

# Create Database Private Subnet
resource "aws_subnet" "database-subnet" {
  count             = var.item_count
  vpc_id            = aws_vpc.week22vpc.id
  cidr_block        = var.database_subnet_cidr[count.index]
  availability_zone = var.availability_zone_names[count.index]

  tags = {
    Name = "Database-${count.index}"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.week22vpc.id

  tags = {
    Name = "Week22IG"
  }
}

#Create Nat Gateway
resource "aws_nat_gateway" "ngw" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.web-subnet[1].id
}

# Create Web layer route table
resource "aws_route_table" "web-rt" {
  vpc_id = aws_vpc.week22vpc.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "WebRT"
  }
}

# Create Web Subnet association with Web route table
resource "aws_route_table_association" "web_rt_association" {
  count          = var.item_count
  subnet_id      = aws_subnet.web-subnet[count.index].id
  route_table_id = aws_route_table.web-rt.id
}

# Create application layer route table
resource "aws_route_table" "app-rt" {
  vpc_id = aws_vpc.week22vpc.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = "appRT"
  }
}

# Create App Subnet association with App route table
resource "aws_route_table_association" "app_rt_association" {
  count          = var.item_count
  subnet_id      = aws_subnet.application-subnet[count.index].id
  route_table_id = aws_route_table.app-rt.id
}

