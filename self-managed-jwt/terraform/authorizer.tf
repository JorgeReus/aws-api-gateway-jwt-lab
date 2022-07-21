resource "aws_iam_role" "authorizer" {
  name               = var.authorizer_function_name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "authorizer_lambda_logging" {
  name = "authorizer_lambda_logging"

  role = aws_iam_role.authorizer.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role" "authorizer_invocation_role" {
  name = "${var.authorizer_function_name}-invocation"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "authorizer" {
  function_name    = var.authorizer_function_name
  filename         = data.archive_file.authorizer_zip.output_path
  role             = aws_iam_role.authorizer.arn
  handler          = "authorizer"
  source_code_hash = data.archive_file.authorizer_zip.output_base64sha256
  runtime          = "go1.x"
  environment {
    variables = var.authorizer_env_vars
  }
}

resource "aws_iam_role_policy" "invocation_policy" {
  name = "${var.authorizer_function_name}-invocation"
  role = aws_iam_role.authorizer_invocation_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "lambda:InvokeFunction",
      "Effect": "Allow",
      "Resource": "${aws_lambda_function.authorizer.arn}"
    }
  ]
}
EOF
}

resource "aws_api_gateway_authorizer" "this" {
  name                   = var.authorizer_function_name
  rest_api_id            = aws_api_gateway_rest_api.this.id
  authorizer_uri         = aws_lambda_function.authorizer.invoke_arn
  authorizer_credentials = aws_iam_role.authorizer_invocation_role.arn
  # Disable cache
  authorizer_result_ttl_in_seconds = 0
  # Try to check if the authorization header is syntactically valid
  # identity_validation_expression   = "^Bearer +.$"
}
