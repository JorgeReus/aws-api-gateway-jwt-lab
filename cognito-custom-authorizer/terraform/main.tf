resource "aws_cognito_user_pool" "pool" {
  name = var.cognito_pool_name
}
resource "aws_cognito_user_pool_client" "client" {
  name                  = var.user_pool_client_name
  user_pool_id          = aws_cognito_user_pool.pool.id
  access_token_validity = 5
  id_token_validity     = 5
  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
  ]
  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }
  read_attributes = [
    "address",
    "birthdate",
    "email",
    "email_verified",
    "family_name",
    "gender",
    "given_name",
    "locale",
    "middle_name",
    "name",
    "nickname",
    "phone_number",
    "phone_number_verified",
    "picture",
    "preferred_username",
    "profile",
    "updated_at",
    "website",
    "zoneinfo",
  ]
  write_attributes = [
    "address",
    "birthdate",
    "email",
    "family_name",
    "gender",
    "given_name",
    "locale",
    "middle_name",
    "name",
    "nickname",
    "phone_number",
    "picture",
    "preferred_username",
    "profile",
    "updated_at",
    "website",
    "zoneinfo",
  ]
}

resource "aws_api_gateway_method" "this" {
  rest_api_id = data.aws_api_gateway_rest_api.this.id
  resource_id = data.aws_api_gateway_resource.this.id
  # Validate ALL request that passes to this API endpoint
  http_method = "ANY"
  # Use cognito
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.this.id
}

resource "aws_api_gateway_deployment" "this" {
  depends_on = [
    aws_api_gateway_integration.example_lambda
  ]
  rest_api_id = data.aws_api_gateway_rest_api.this.id
  stage_name  = var.stage_name
}

resource "aws_api_gateway_method_settings" "this" {
  rest_api_id = data.aws_api_gateway_rest_api.this.id
  stage_name  = var.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}
