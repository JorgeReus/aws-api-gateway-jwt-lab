variable "connect_function_name" {
  description = "The name of the function called for the default route"
  default     = "ws_connect_lambda"
}

resource "aws_iam_role" "connect_lambda" {
  name = var.connect_function_name

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

resource "aws_iam_role_policy" "connect_lambda" {
  name = var.connect_function_name

  role = aws_iam_role.connect_lambda.id

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

resource "aws_cloudwatch_log_group" "connect_lambda" {
  name              = "/aws/lambda/${var.connect_function_name}"
  retention_in_days = 5
}

resource "aws_lambda_function" "connect_lambda" {
  function_name    = var.connect_function_name
  role             = aws_iam_role.connect_lambda.arn
  handler          = "index.apiHandler"
  filename         = data.archive_file.connect_lambda_zip.output_path
  source_code_hash = data.archive_file.connect_lambda_zip.output_base64sha256
  runtime          = "nodejs14.x"
  depends_on = [
    aws_cloudwatch_log_group.connect_lambda
  ]
}

resource "aws_lambda_permission" "connect_lambda_apigw_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.connect_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.this.execution_arn}/*/*"
}


resource "aws_apigatewayv2_integration" "connect" {
  api_id                    = aws_apigatewayv2_api.this.id
  integration_type          = "AWS_PROXY"
  connection_type           = "INTERNET"
  content_handling_strategy = "CONVERT_TO_TEXT"
  description               = "Lambda example"
  integration_method        = "POST"
  integration_uri           = aws_lambda_function.connect_lambda.invoke_arn
  passthrough_behavior      = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_route" "connect" {
  api_id                              = aws_apigatewayv2_api.this.id
  route_key                           = "$connect"
  target                              = "integrations/${aws_apigatewayv2_integration.connect.id}"
  route_response_selection_expression = "$default"
  authorization_type                  = "CUSTOM"
  authorizer_id                       = aws_apigatewayv2_authorizer.this.id
}

resource "aws_apigatewayv2_integration_response" "connect" {
  api_id                   = aws_apigatewayv2_api.this.id
  integration_id           = aws_apigatewayv2_integration.connect.id
  integration_response_key = "$default"

  response_templates = {
    "200" = jsonencode(
      {
        statusCode = 200
      }
    )
  }
}
