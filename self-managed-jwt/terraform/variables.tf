variable "aws_region" {
  description = "The region that will be used to deploy the infrastructure"
  default     = "us-east-1"
}

variable "authorizer_function_name" {
  description = "The name of the authorizer function"
  default     = "jwt-basic-authorizer"
}

variable "api_gateway_name" {
  description = "The name of the API gateway to mount this example"
  default     = "selfsigned-jwk-rest-lab"
}

variable "example_function_name" {
  description = "The name of the example target function"
  default     = "jwt-basic-example"
}

variable "lab_api_gw_resource_path" {
  description = "The path of the api gateway lab"
  default     = "lab"
}

variable "stage_name" {
  description = "The stage name of the API gateway deployment"
  default     = "test"
}

variable "authorizer_env_vars" {
  default = {
    PUBLIC_JWK   = "eyJ1c2UiOiJzaWciLCJrdHkiOiJFQyIsImtpZCI6IkFyU3lpVmhGbzFEVlFZUjBQNEVWR1Z1UnZTeFNZYWtsVGFQcDlNT1ZfUE09IiwiY3J2IjoiUC0yNTYiLCJhbGciOiJFUzI1NiIsIngiOiJ6TzhLLVpTQkdmSnNIazJiWC1ySy04Q2tkR21zazBWTDh2UURJeTcweVBFIiwieSI6InZLZGhncVc4OHUzdHZhTVVTbFhoeUUxZWVSc2tnd21QRGp0SEpzTW5vT1kifQ=="
    PRIVATE_JWK  = "eyJ1c2UiOiJzaWciLCJrdHkiOiJFQyIsImtpZCI6IkFyU3lpVmhGbzFEVlFZUjBQNEVWR1Z1UnZTeFNZYWtsVGFQcDlNT1ZfUE09IiwiY3J2IjoiUC0yNTYiLCJhbGciOiJFUzI1NiIsIngiOiJ6TzhLLVpTQkdmSnNIazJiWC1ySy04Q2tkR21zazBWTDh2UURJeTcweVBFIiwieSI6InZLZGhncVc4OHUzdHZhTVVTbFhoeUUxZWVSc2tnd21QRGp0SEpzTW5vT1kiLCJkIjoiU3hCTXhaWFByOHNRNGRRRGpSQ2sybDk1UkVHR1ZkTV9HTUVyMWJoU2VNdyJ9"
    JWT_ISSUER   = "my.jwt.issuer"
    JWT_AUDIENCE = "my.jwt.audience"
  }
}
