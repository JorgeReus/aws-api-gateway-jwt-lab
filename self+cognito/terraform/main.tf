resource "aws_apigatewayv2_api" "this" {
  name                       = var.websocket-api-name
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
}

resource "aws_apigatewayv2_stage" "test" {
  api_id = aws_apigatewayv2_api.this.id
  name   = var.stage_name
  default_route_settings {
    logging_level          = "ERROR"
    data_trace_enabled     = true
    throttling_burst_limit = 5000
    throttling_rate_limit  = 10000
  }
}

resource "aws_apigatewayv2_integration" "disconnect" {
  api_id           = aws_apigatewayv2_api.this.id
  integration_type = "MOCK"
}

resource "aws_apigatewayv2_route" "disconnect" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "$disconnect"
  target    = "integrations/${aws_apigatewayv2_integration.disconnect.id}"
}

resource "aws_apigatewayv2_deployment" "this" {
  api_id      = aws_apigatewayv2_route.connect.api_id
  description = "Connect route deployment"

  lifecycle {
    create_before_destroy = true
  }
}
