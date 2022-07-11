variable "aws_region" {
  description = "The region that will be used to deploy the infrastructure"
  default = "us-east-1" 
}

variable "rest_api_conf" {
  default = {
    name =  "rest-jwt-lab"
    description = "REST API for testing JWT base autn & authz"
  }
  type = object({
    name= string
    description = string
  })
}

variable "lab_resource_conf" {
  default = {
    path = "lab"
    stage = "test" 
  }
  type = object({
    path = string
    stage = string
  })
}
