# Basic API gateway with custom self-signed token authentication
This example contains a simple terraform configuration to implement an API gateway rest API with a basic cognito authorizer.

> **Warning**
> Please make sure you have configured your AWS properly, this will configure **real** infrastructure.

## Steps
1. Run `task setup`, be sure the read carefully what terraform will apply, you can rety this command if anything fails due to the async nature of AWS API Gateway
2. Run `curl -H "Authorization: Bearer $(task get-valid-jwt)" "$(task get-apigw-url)" -w '\nResponse code:%{http_code}'`.
2. Run `curl -H "Authorization: Bearer $(task get-invalid-jwt)" "$(task get-apigw-url)" -w '\nResponse code:%{http_code}'`, see the expiration happen (403 status code instead of 200).

# Destroy
Run `task tearup`
