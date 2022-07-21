resource "aws_iam_role" "default_lambda" {
  name = var.default_function_name

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

resource "aws_iam_role_policy" "default_lambda" {
  name = var.default_function_name

  role = aws_iam_role.default_lambda.id

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

resource "aws_cloudwatch_log_group" "default_lambda" {
  name              = "/aws/lambda/${var.default_function_name}"
  retention_in_days = 5
}

resource "aws_lambda_function" "default_lambda" {
  function_name    = var.default_function_name
  role             = aws_iam_role.default_lambda.arn
  handler          = "index.apiHandler"
  filename         = data.archive_file.default_lambda_zip.output_path
  source_code_hash = data.archive_file.default_lambda_zip.output_base64sha256
  runtime          = "nodejs14.x"
  depends_on = [
    aws_cloudwatch_log_group.default_lambda
  ]
}

resource "aws_lambda_permission" "default_lambda_apigw_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.default_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.this.execution_arn}/*/*"
}

resource "aws_apigatewayv2_integration" "default" {
  api_id                    = aws_apigatewayv2_api.this.id
  integration_type          = "AWS_PROXY"
  connection_type           = "INTERNET"
  content_handling_strategy = "CONVERT_TO_TEXT"
  description               = "Lambda example"
  integration_method        = "POST"
  integration_uri           = aws_lambda_function.default_lambda.invoke_arn
  passthrough_behavior      = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_route" "default" {
  api_id                              = aws_apigatewayv2_api.this.id
  route_key                           = "$default"
  target                              = "integrations/${aws_apigatewayv2_integration.default.id}"
  route_response_selection_expression = "$default"
}

resource "aws_apigatewayv2_integration_response" "default" {
  api_id                   = aws_apigatewayv2_api.this.id
  integration_id           = aws_apigatewayv2_integration.default.id
  integration_response_key = "$default"
  response_templates = {
    "200" = jsonencode(
      {
        statusCode = 200
      }
    )
  }
}
resource "aws_apigatewayv2_route_response" "default" {
  api_id             = aws_apigatewayv2_api.this.id
  route_id           = aws_apigatewayv2_route.default.id
  route_response_key = "$default"
}
