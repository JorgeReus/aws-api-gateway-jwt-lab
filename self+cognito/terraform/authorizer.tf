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
  name = "${var.authorizer_function_name}-logging"

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
  path = "/"

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

resource "aws_cloudwatch_log_group" "authorizer_lambda" {
  name              = "/aws/lambda/${var.authorizer_function_name}"
  retention_in_days = 5
}

resource "aws_lambda_function" "authorizer" {
  function_name    = var.authorizer_function_name
  filename         = data.archive_file.authorizer_zip.output_path
  role             = aws_iam_role.authorizer.arn
  handler          = "authorizer"
  source_code_hash = data.archive_file.authorizer_zip.output_base64sha256
  runtime          = "go1.x"
  environment {
    variables = merge(var.authorizer_env_vars, {
      COGNITO_ISSUER = "https://cognito-idp.${var.aws_region}.amazonaws.com/${aws_cognito_user_pool.pool.id}"
    })
  }
  depends_on = [
    aws_cloudwatch_log_group.authorizer_lambda
  ]
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

resource "aws_apigatewayv2_authorizer" "this" {
  name                       = var.authorizer_function_name
  api_id                     = aws_apigatewayv2_api.this.id
  authorizer_type            = "REQUEST"
  identity_sources           = ["route.request.header.Auth"]
  authorizer_uri             = aws_lambda_function.authorizer.invoke_arn
  authorizer_credentials_arn = aws_iam_role.authorizer_invocation_role.arn
}
