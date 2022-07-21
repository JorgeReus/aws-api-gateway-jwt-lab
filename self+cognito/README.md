# AWS Websockets with custom authorizers!
This example showcases a minimal setup to implement an AWS API Gateway Websockets API with custom authorizers validating requests from different JWK sources!

# Diagrams
Click [here](./docs/README.md) 

## Steps
> **Warning**
> Please make sure you have configured your AWS credentials properly, this will configure **real** infrastructure.
1. Run `task setup`, be sure the read carefully what terraform will apply, you can rety this command if anything fails due to the async nature of AWS API Gateway
2. Run `task start-ws-cognito`, and start typing, see what message the API responds.
3. Run `task start-ws-selfsigned`, and start typing, see what message the API responds.

# Destroy
Run `task tearup`
