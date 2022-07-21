output "url" {
  value = "https://${aws_api_gateway_rest_api.this.id}.execute-api.${var.aws_region}.amazonaws.com/${var.stage_name}/${var.lab_api_gw_resource_path}"
}

output "client_id" {
 value = aws_cognito_user_pool_client.client.id
}

output "user_pool_id" {
 value = aws_cognito_user_pool.pool.id
}
