resource "aws_api_gateway_gateway_response" "authorizer_configuration_error" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  status_code   = "500"
  response_type = "AUTHORIZER_CONFIGURATION_ERROR"

  response_templates = {
    "application/json" = "{\"error_message\":$context.error.messageString}"
  }
}

resource "aws_api_gateway_gateway_response" "authorizer_failure" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  status_code   = "500"
  response_type = "AUTHORIZER_FAILURE"

  response_templates = {
    "application/json" = "{\"error_message\":$context.authorizer.messageString}"
  }
}

resource "aws_api_gateway_gateway_response" "access_denied" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  status_code   = "403"
  response_type = "ACCESS_DENIED"

  response_templates = {
    "application/json" = "{\"error_message\":$context.authorizer.messageString}"
  }
}
