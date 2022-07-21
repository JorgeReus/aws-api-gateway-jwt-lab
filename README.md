# API Gateway JWT authz & authn
Laboratory to showcase several ways of implementing authorization and authentication using JWT in AWS API Gateway (v1 & v2)

## Dependencies
### Required
- [task](https://taskfile.dev/installation/)
- [golang](https://go.dev/doc/install)
- [wscat](https://www.npmjs.com/package/wscat)
- [terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
### Optional
- [docker](https://docs.docker.com/get-docker/)

## Setup
Run `task setup` to deploy the base infrastructure:
- IAM role to log all API Gateway requests account wise

Then you can go to each dir to test the example
- [Cognito Authorizer Basic Integration](./cognito-authorizer)
- [Custom Authorizer using a self signed JWK](./self-managed-jwk)
- [Websockets API + Cognito JWK + Self Signed JWK](./self+cognito)

## Tearup
Run `task tearup`
