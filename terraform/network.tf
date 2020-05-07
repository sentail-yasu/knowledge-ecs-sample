resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true

  tags = {
    Name = "${var.name}-vpc"
  }
}

# EIP
resource "aws_eip" "nat" {
    vpc = true
}

# NatGateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public-a.id
}

# Subnet
resource "aws_subnet" "public-a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr["public-a"]
  map_public_ip_on_launch = true
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "public-subnet-1a"
  }
}

resource "aws_subnet" "public-c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr["public-c"]
  map_public_ip_on_launch = true
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "public-subnet-1c"
  }
}

resource "aws_subnet" "private-a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr["private-a"]
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "private-subunet-1a"
  }
}

resource "aws_subnet" "private-c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr["private-c"]
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "private-subunet-1c"
  }
}

# db_subnet_group
resource "aws_db_subnet_group" "db-subnet" {
    name = "db-subnet"
    description = "test db subnet"
    subnet_ids = ["${aws_subnet.private-a.id}", "${aws_subnet.private-c.id}"]
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.name}-igw"
  }
}

# public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.name}-rt"
  }
}

# public Route
resource "aws_route" "public_route" {
  gateway_id             = aws_internet_gateway.igw.id
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
}

# パブリックルートテーブルとpublic-a関連付け
resource "aws_route_table_association" "public_a" {
    subnet_id      = aws_subnet.public-a.id
    route_table_id = aws_route_table.public.id
}

# パブリックルートテーブルとpublic-c関連付け
resource "aws_route_table_association" "public_c" {
    subnet_id      = aws_subnet.public-c.id
    route_table_id = aws_route_table.public.id
}

# private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
}

# private Route
resource "aws_route" "private_route" {
  nat_gateway_id             = aws_nat_gateway.nat.id
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
}

# パブリックルートテーブルとprivate-a関連付け
resource "aws_route_table_association" "private-a" {
    subnet_id = aws_subnet.private-a.id
    route_table_id = aws_route_table.private.id
}

# パブリックルートテーブルとprivate-c関連付け
resource "aws_route_table_association" "private-c" {
    subnet_id = aws_subnet.private-c.id
    route_table_id = aws_route_table.private.id
}
