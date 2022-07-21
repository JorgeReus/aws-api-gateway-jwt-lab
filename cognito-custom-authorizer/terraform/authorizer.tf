resource "aws_api_gateway_authorizer" "this" {
  name        = var.authorizer_name
  rest_api_id = aws_api_gateway_rest_api.this.id
  # Disable cache
  authorizer_result_ttl_in_seconds = 0
  type                             = "COGNITO_USER_POOLS"
  provider_arns = [
    aws_cognito_user_pool.pool.arn
  ]
}
