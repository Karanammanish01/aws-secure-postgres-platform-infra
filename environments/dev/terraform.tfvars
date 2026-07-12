project_name = "secure-platform"
environment  = "dev"

aws_region = "ap-south-1"

# VPC CIDR Block
vpc_cidr = "10.0.0.0/16"


vpc_subnet = {
  "public_subnet" = {
    subnet_cidr_block        = "10.0.0.0/24"
    subnet_availability_zone = "ap-south-1a"
    subnet_type              = "public"
  }

  "private_subnet" = {
    subnet_cidr_block        = "10.0.1.0/24"
    subnet_availability_zone = "ap-south-1b"
    subnet_type              = "private"
  }
}