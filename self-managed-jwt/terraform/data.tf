data "archive_file" "authorizer_zip" {
  type        = "zip"
  source_file = "../src/authorizer/cmd/lambda/authorizer"
  output_path = "authorizer.zip"
}

data "archive_file" "example_lambda_zip" {
  type        = "zip"
  source_dir  = "../src/example_lambda"
  output_path = "lambda.zip"
}

data "aws_api_gateway_rest_api" "this" {
  name = var.api_gateway_name
}

data "aws_api_gateway_resource" "this" {
  rest_api_id = data.aws_api_gateway_rest_api.this.id
  path        = var.lab_api_gw_resource_path
}
