resource "aws_iam_role" "example_lambda" {
  name = var.example_function_name

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

resource "aws_iam_role_policy" "example_lambda" {
  name = var.example_function_name

  role = aws_iam_role.example_lambda.id

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

resource "aws_cloudwatch_log_group" "example_lambda" {
  name              = "/aws/lambda/${var.example_function_name}"
  retention_in_days = 5
}

resource "aws_lambda_function" "example_lambda" {
  function_name    = var.example_function_name
  role             = aws_iam_role.example_lambda.arn
  handler          = "index.apiHandler"
  filename         = data.archive_file.example_lambda_zip.output_path
  source_code_hash = data.archive_file.example_lambda_zip.output_base64sha256
  runtime          = "nodejs14.x"
  depends_on = [
    aws_cloudwatch_log_group.example_lambda
  ]
}

resource "aws_api_gateway_integration" "example_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_method.this.resource_id
  http_method             = aws_api_gateway_method.this.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.example_lambda.invoke_arn
}

resource "aws_lambda_permission" "example_lambda_apigw_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.this.execution_arn}/*/*"
}
