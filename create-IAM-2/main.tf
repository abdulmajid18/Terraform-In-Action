provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key

  default_tags {
    tags = {
      Hashicorp-Learn = "aws-iam-policy"
    }
  }
}

resource "random_pet" "pet_name" {
  length    = 3
  separator = "-"
}


resource "aws_s3_bucket" "example" {
  bucket = "${random_pet.pet_name.id}-bucket"
}

resource "aws_s3_bucket_policy" "example_bucket_policy" {
  bucket = aws_s3_bucket.example.bucket

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.example_role.name}"
        },
        "Action" : [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        "Resource" : [
          "arn:aws:s3:::example-bucket",
          "arn:aws:s3:::example-bucket/*"
        ]
      }
    ]
  })
}

resource "aws_instance" "example_instance" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"

  iam_instance_profile = aws_iam_instance_profile.example_profile.name

  tags = {
    Name = "exampleinstance"
  }
}

resource "aws_iam_role" "example_role" {
  name = "examplerole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "example_profile" {
  name = "example_profile"
  role = aws_iam_role.example_role.name
}

resource "aws_iam_role_policy_attachment" "example_attachment" {
  role       = aws_iam_role.example_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}