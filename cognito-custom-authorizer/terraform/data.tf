data "archive_file" "example_lambda_zip" {
  type        = "zip"
  source_dir  = "../src/example_lambda"
  output_path = "lambda.zip"
}
