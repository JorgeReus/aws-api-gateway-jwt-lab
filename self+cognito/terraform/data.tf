data "archive_file" "authorizer_zip" {
  type        = "zip"
  source_file = "../src/authorizer/cmd/lambda/bin/authorizer"
  output_path = "authorizer.zip"
}

data "archive_file" "default_lambda_zip" {
  type        = "zip"
  source_dir  = "../src/default_lambda"
  output_path = "default_lambda.zip"
}

data "archive_file" "connect_lambda_zip" {
  type        = "zip"
  source_dir  = "../src/connect_lambda"
  output_path = "connect_lambda.zip"
}
