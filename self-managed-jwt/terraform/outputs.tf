output "url" {
  value = "https://${data.aws_api_gateway_rest_api.this.id}.execute-api.${var.aws_region}.amazonaws.com/${var.stage_name}${var.lab_api_gw_resource_path}"
}

