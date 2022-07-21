output "user_pool_id" {
  value = aws_cognito_user_pool.pool.id
}

output "client_id" {
  value = aws_cognito_user_pool_client.client.id
}

output "gw_http_url" {
  value = "https://${aws_apigatewayv2_api.this.id}.execute-api.${var.aws_region}.amazonaws.com/${var.stage_name}"
}

output "gw_ws_url" {
  value = "wss://${aws_apigatewayv2_api.this.id}.execute-api.${var.aws_region}.amazonaws.com/${var.stage_name}"
}
