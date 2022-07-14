resource "aws_api_gateway_method" "this" {
  rest_api_id = data.aws_api_gateway_rest_api.this.id
  resource_id = data.aws_api_gateway_resource.this.id
  # Validate ALL request that passes to this API endpoint
  http_method   = "ANY"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.this.id
}

resource "aws_api_gateway_deployment" "this" {
  depends_on = [
    aws_api_gateway_integration.example_lambda
  ]
  rest_api_id = data.aws_api_gateway_rest_api.this.id
  stage_name  = var.stage_name
}
