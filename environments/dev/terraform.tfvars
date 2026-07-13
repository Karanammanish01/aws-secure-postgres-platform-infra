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

security_group = {
  "ec2" = {
    security_group_resource = "ec2"
    description             = "This is the security group for the EC2"
  }

  "rds" = {
    security_group_resource = "rds"
    description             = "This is the secuirty group for RDS"
  }
}

ingress_rule = {
  "rule_1" = {
    security_group = "ec2"
    cidr_ipv4      = "122.172.86.44/32"
    from_port      = 22
    to_port        = 22
    ip_protocol    = "tcp"
  }

  "rule_2" = {
    security_group            = "rds"
    referenced_security_group = "ec2"
    from_port                 = 5432
    to_port                   = 5432
    ip_protocol               = "tcp"
  }
}

egress_rule = {
  "rule_1" = {
    security_group = "ec2"
    cidr_ipv4      = "0.0.0.0/0"
    from_port      = -1
    to_port        = -1
    ip_protocol    = "-1"
  }
}