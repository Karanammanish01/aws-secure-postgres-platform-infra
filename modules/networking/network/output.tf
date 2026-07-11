output "vpc_id" {
  value = aws_vpc.this
}

output "subnet_id" {
    description = "Subnet ID"

    value = {
        for key, subnet in aws_subnet.this :
        key => subnet
    }
}