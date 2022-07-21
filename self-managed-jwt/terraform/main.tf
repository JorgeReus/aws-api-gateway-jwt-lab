resource "aws_api_gateway_rest_api" "this" {
  name = var.api_gateway_name
  description = "Self Managed JWK APIGW lab"
  tags = {
    Name = var.api_gateway_name
  }
}

resource "aws_api_gateway_resource" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id = aws_api_gateway_rest_api.this.root_resource_id
  path_part = var.lab_api_gw_resource_path
}

resource "aws_api_gateway_method_settings" "all" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = var.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "ERROR"
  }
}

resource "aws_api_gateway_method" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.this.id
  # Validate ALL request that passes to this API endpoint
  http_method   = "ANY"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.this.id
}

resource "aws_api_gateway_deployment" "this" {
  depends_on = [
    aws_api_gateway_integration.example_lambda
  ]
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = var.stage_name
}
