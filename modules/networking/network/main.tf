# Local Tags
locals {
  normal_tags = {
    module = "network"
  }

  merged_tags = merge(local.normal_tags, var.tags)
}

# VPC setting 
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.merged_tags,
  { Name = "${var.identifier}-vpc" })
}

# Subnet module

resource "aws_subnet" "this" {
  depends_on = [aws_vpc.this]
  vpc_id     = aws_vpc.this.id

  for_each = var.subnet

  cidr_block        = each.value.subnet_cidr_block
  availability_zone = each.value.subnet_availability_zone

  map_public_ip_on_launch = each.value.subnet_type == "public"


  tags = merge(local.merged_tags, {
    Name = "${var.identifier}-${each.value.subnet_type}"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.merged_tags, {
    Name = "${var.identifier}-igw"
  })
}

# Route table
resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(local.merged_tags, {
    Name = "${var.identifier}-public-route-table"
  })
}

resource "aws_route_table_association" "this" {
  subnet_id      = aws_subnet.this["public_subnet"].id
  route_table_id = aws_route_table.this.id
}