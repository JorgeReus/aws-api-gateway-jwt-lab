provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Domain = "api-gateway-jwt-lab"
      Environment = "dev"
    }
  }
}
