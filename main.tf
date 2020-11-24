provider "aws" {
  profile = "default"
  region = "eu-central-1"
}

data "aws_iam_policy_document" "assumeRolePolicy" {
  statement {
    sid = "1"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type = "Service"
    }
  }
}

data "aws_iam_policy_document" "s3AccessPolicy" {
  statement {
    sid = "S3AccessPolicy"

    actions = [
      "s3:PutItem"
    ]

    effect = "Allow"

    resources = [
      aws_s3_bucket.my_bucket.arn
    ]
  }
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-test-bucket-216854687469874684"
}

resource "aws_iam_role" "helloWorld" {
  name = "hello"
  assume_role_policy = data.aws_iam_policy_document.assumeRolePolicy.json
}

resource "aws_iam_role_policy" "s3Access" {
  policy = data.aws_iam_policy_document.s3AccessPolicy.json
  role = aws_iam_role.helloWorld.id
}

resource "aws_lambda_function" "helloWorldLambda" {
  function_name = "helloWorldFromGo"
  filename = "function.zip"
  handler = "helloWorldTFGo"
  role = aws_iam_role.helloWorld.arn
  runtime = "go1.x"
  memory_size = 128
}
