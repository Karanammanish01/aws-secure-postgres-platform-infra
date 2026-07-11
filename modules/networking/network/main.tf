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

  tags = merge(local.merged_tags,
  { Name = "${var.identifier}-vpc" })
}

# Subnet module

resource "aws_subnet" "this" {
  depends_on = [ aws_vpc.this, aws_internet_gateway.this]
  vpc_id = aws_vpc.this.id

  for_each = var.subnet

  cidr_block = each.value.subnet_cidr_block
  availability_zone = each.value.subnet_availability_zone

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

  for_each = 

  tags = merge(local.merged_tags, {
    Name = "${var.identifier}-${var.}"
  })
}