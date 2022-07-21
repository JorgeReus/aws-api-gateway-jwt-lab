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
