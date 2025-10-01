resource "aws_iam_role" "ssm_role" {
  name = "ssm_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "ssm_instance_profile"
  role = aws_iam_role.ssm_role.name
}

resource "aws_iam_policy" "s3_read_policy" {
  name        = "s3_read_policy"
  description = "A policy to allow reading from s3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Effect   = "Allow",
        Resource = [
          "",
          ""
        ]
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_read_policy_attachment" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = aws_iam_policy.s3_read_policy.arn
}