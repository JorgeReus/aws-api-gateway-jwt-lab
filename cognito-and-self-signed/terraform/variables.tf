variable "aws_region" {
  description = "The region that will be used to deploy the infrastructure"
  default     = "us-east-1"
}

variable "cognito_pool_name" {
  default = "ws_user_pool"
}

variable "user_pool_client_name" {
  description = "The name of a client app to connect to the cognito user pool"
  default     = "ws_test"
}

variable "websocket-api-name" {
  default = "test-websocket-api"
}

variable "stage_name" {
  description = "The stage name of the API gateway deployment"
  default     = "test"
}

variable "authorizer_env_vars" {
  default = {
    PUBLIC_JWK   = "eyJrZXlzIjpbeyJ1c2UiOiJzaWciLCJrdHkiOiJFQyIsImtpZCI6IkVOS1NwbjEyWmJjeUlYYm5tR09GUEVaTm5hMGJ4MzNtejNUa2d1cWtaSWM9IiwiY3J2IjoiUC0yNTYiLCJhbGciOiJFUzI1NiIsIngiOiJqSF9qMF8wcE5EWElyZEZ5UnA5b2hFdjd3VzgtdFkwZV96aWd2US02ZTEwIiwieSI6ImM5WGFLSVFHMWNfbXVHSnE1MWcxcHAwQ19DSmdmSE1XYXhiaUc3c3pjbVkifSx7InVzZSI6InNpZyIsImt0eSI6IkVDIiwia2lkIjoiRXV2UnRWYVpKTld0OWtPam91cWljeklpMWc2bzB0WTYxS1NCUG01M0N4UT0iLCJjcnYiOiJQLTI1NiIsImFsZyI6IkVTMjU2IiwieCI6InpvWFBZX1RrLS1kUUNZdnozMXExM3oyalpfRUdLTGJEYnZaY3FOVXpUTlkiLCJ5IjoiQ3hRVkJHZmFJSko0UTduTGpuNmhHUVZIcE53bU8zM052V3dxSkVOSnBMRSJ9LHsidXNlIjoic2lnIiwia3R5IjoiRUMiLCJraWQiOiJTaV9mWmVwcXRhZnY1Y2JZS0l2a1FlV0w0ZUx3NlZmT2xBUHYxaXpaSndBPSIsImNydiI6IlAtMjU2IiwiYWxnIjoiRVMyNTYiLCJ4IjoiV1RMcmFZcnRkNGdIM2Z2aEFYLUZDMllwY1FhYVhtVWMxQUNYa3luajJ4MCIsInkiOiI2eC1WV3EzMXFWenphbDBWNTJqNHlpQnAyajJLSHZfaHh3ZGd1ejRxaDNvIn1dfQ=="
    PRIVATE_JWK  = "eyJrZXlzIjpbeyJ1c2UiOiJzaWciLCJrdHkiOiJFQyIsImtpZCI6IkVOS1NwbjEyWmJjeUlYYm5tR09GUEVaTm5hMGJ4MzNtejNUa2d1cWtaSWM9IiwiY3J2IjoiUC0yNTYiLCJhbGciOiJFUzI1NiIsIngiOiJqSF9qMF8wcE5EWElyZEZ5UnA5b2hFdjd3VzgtdFkwZV96aWd2US02ZTEwIiwieSI6ImM5WGFLSVFHMWNfbXVHSnE1MWcxcHAwQ19DSmdmSE1XYXhiaUc3c3pjbVkiLCJkIjoicjQ0NE5VUFJqUnJULU5OekJzV0NyWGJDSVlJMkloajJRNUloN1EzcXhnZyJ9LHsidXNlIjoic2lnIiwia3R5IjoiRUMiLCJraWQiOiJFdXZSdFZhWkpOV3Q5a09qb3VxaWN6SWkxZzZvMHRZNjFLU0JQbTUzQ3hRPSIsImNydiI6IlAtMjU2IiwiYWxnIjoiRVMyNTYiLCJ4Ijoiem9YUFlfVGstLWRRQ1l2ejMxcTEzejJqWl9FR0tMYkRidlpjcU5VelROWSIsInkiOiJDeFFWQkdmYUlKSjRRN25Mam42aEdRVkhwTndtTzMzTnZXd3FKRU5KcExFIiwiZCI6IlZleDZ0TU1NcmMxTTFjR1ZWUUhweUQxTmJyRzdFWVBBMVptbXJRak12Z2cifSx7InVzZSI6InNpZyIsImt0eSI6IkVDIiwia2lkIjoiU2lfZlplcHF0YWZ2NWNiWUtJdmtRZVdMNGVMdzZWZk9sQVB2MWl6Wkp3QT0iLCJjcnYiOiJQLTI1NiIsImFsZyI6IkVTMjU2IiwieCI6IldUTHJhWXJ0ZDRnSDNmdmhBWC1GQzJZcGNRYWFYbVVjMUFDWGt5bmoyeDAiLCJ5IjoiNngtVldxMzFxVnp6YWwwVjUyajR5aUJwMmoyS0h2X2h4d2RndXo0cWgzbyIsImQiOiJ4bkRmWVZiMGFHTFhBdVFIUkNTUWp3cFpBcjlYTEViV0xUUllCSXhNbFNVIn1dfQ=="
    JWT_ISSUER   = "my.jwt.issuer"
    JWT_AUDIENCE = "my.jwt.audience"
  }
}

variable "authorizer_function_name" {
  description = "The name of the authorizer function"
  default     = "jwt-ws-authorizer"
}


variable "default_function_name" {
  description = "The name of the function called for the default route"
  default     = "ws_default_lambda"
}

