resource "aws_api_gateway_rest_api" "this" {
  name = var.rest_api_conf.name
  description = var.rest_api_conf.description
  tags = {
    Name = var.rest_api_conf.name
  }
}

resource "aws_api_gateway_resource" "lab" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id = aws_api_gateway_rest_api.this.root_resource_id
  path_part = var.lab_resource_conf.path
}
