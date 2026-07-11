# Configure the AWS Provider

provider "aws" {
  region = var.aws_region

  # Default tags 
  default_tags {
    tags = local.common_tags
  }
}
