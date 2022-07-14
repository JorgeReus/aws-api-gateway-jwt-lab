variable "aws_region" {
  default = "us-east-1"
}

variable "cognito_pool_name" {
  default = "basic_user_pool"
}

variable "api_gateway_name" {
  description = "The name of the API gateway to mount this example"
  default     = "rest-jwt-lab"
}

variable "lab_api_gw_resource_path" {
  description = "The path of the api gateway lab"
  default     = "/lab"
}

variable "authorizer_name" {
  description = "The name of the API GW authorizer"
  default     = "jwt_basic_authorizer"
}

variable "stage_name" {
  description = "The stage name of the API gateway deployment"
  default     = "test"
}

variable "example_function_name" {
  description = "The name of the example target function"
  default     = "cognito_basic_example"
}

variable "user_pool_client_name" {
  description = "The name of a client app to connect to the cognito user pool"
  default     = "test"
}
