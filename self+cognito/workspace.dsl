workspace "AWS APIGW v2 authorizers" "Example of implementing custom authorizers for multiple JWKs using websockets" {
    model {
      softwareSystem = softwareSystem "Websockets Custom Authorizers" "Example for showcasing websockets in AWS APIGW V2" {
        !docs docs
      }
      live = deploymentEnvironment "Example" {
        deploymentNode "Amazon Web Services" {
          tags "Amazon Web Services - Cloud"
          region = deploymentNode "us-east-1" {
            tags "Amazon Web Services - Region"

            apigw = infrastructureNode "API Gateway" {
                description "Highly available service to manage APIs (Websockets)"
                tags "Amazon Web Services - API Gateway"
            }

            lambdaConnect = infrastructureNode "$connect" {
                description "Process connect events"
                tags "Amazon Web Services - Lambda Lambda Function"
            }

            authorizerLambda = infrastructureNode "Authorizer" {
                description "Decides if a $connect event is allowed to proceed"
                tags "Amazon Web Services - Lambda Lambda Function"
            }

            lambdaDefault = infrastructureNode "$default" {
                description "Process all events not managed by other routes"
                tags "Amazon Web Services - Lambda Lambda Function"
            }

            cognitoJwk = infrastructureNode "Cognito JWKs" {
                description "Public cognito JWKS"
                tags "JWK"
            }

            selfSignedJwk = infrastructureNode "SelfSigned JWKs" {
                description "Public self signed JWKS"
                tags "JWK"
            }

            cognitoUserPool = infrastructureNode "User Pool" {
                description "Manages System users"
                tags "Amazon Web Services - Cognito"
            }
          }
        }
        apigw -> authorizerLambda "Validates connect events"
        authorizerLambda -> lambdaConnect "Forward connect events"
        apigw -> lambdaDefault "Forwards events after connection has been authorized"
        lambdaDefault -> apigw "Returns default message"
        authorizerLambda -> cognitoJwk "Validates JWTs based on public JWKS"
        authorizerLambda -> selfSignedJwk "Validates JWTs based on public selfsigned JWKS"
        cognitoJwk -> cognitoUserPool "Validates JWTs based on cognito public JWKS"
      }
    }

    views {
      deployment softwareSystem "Live" "AmazonWebServicesDeployment" {
          include *
          autoLayout lr
      }

      styles {
          element "Software System" {
              background #1168bd
              color #ffffff
          }
          element "JWK" {
              shape roundedbox
              icon images/jwk.png
          }

          element "Infrastructure Node" {
              shape roundedbox
          }
      }

      themes https://static.structurizr.com/themes/amazon-web-services-2020.04.30/theme.json
    }
    
}
