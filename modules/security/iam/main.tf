locals {
  normal_tags = {
    module = "iam"
  }

  merged_tags = merge(local.normal_tags, var.tags)
}


# IAM Role
resource "aws_iam_role" "this" {
  # We only give the Identity. Who is the trust here 

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"

      Statement = [
        {

          Effect = "Allow"

          Principal = {
            Service = "ec2.amazonaws.com"
          }

          Action = "sts:AssumeRole"
        }
      ]
    }
  )

  name = "${var.identifier}-ec2-role"

  tags = local.merged_tags
}

resource "aws_iam_policy" "this" {
  name = "${var.identifier}-secrets-role"

  policy = jsonencode(
    {
      Version = "2012-10-17"

      Statement = [
        {
          Effect = "Allow"

          Action = [
            "secretsmanager:GetSecretValue",
            "kms:Decrypt"
          ]

          Resource = "*"
        }
      ]
    }
  )

  tags = local.merged_tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.identifier}-ec2-role"
  role = aws_iam_role.this.name

  tags = local.merged_tags
}