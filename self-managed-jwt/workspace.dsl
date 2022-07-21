workspace "AWS APIGW authorizers" "Example of implementing custom authorizers for multiple JWKs using REST APIs" {
    model {
      softwareSystem = softwareSystem "REST API with Custom Authorizers" "Example for showcasing self signed JWK authorizers for a REST API" {
        !docs docs
      }
      live = deploymentEnvironment "Example" {
        deploymentNode "Amazon Web Services" {
          tags "Amazon Web Services - Cloud"
          region = deploymentNode "us-east-1" {
            tags "Amazon Web Services - Region"

            apigw = infrastructureNode "API Gateway" {
                description "Highly available service to manage APIs (REST APIs)"
                tags "Amazon Web Services - API Gateway"
            }

            authorizerLambda = infrastructureNode "Authorizer" {
                description "Decides if a request is allowed to proceed"
                tags "Amazon Web Services - Lambda Lambda Function"
            }

            exampleLambda = infrastructureNode "Example" {
                description "Default labmda for a /lab path"
                tags "Amazon Web Services - Lambda Lambda Function"
            }

            selfSignedJwk = infrastructureNode "SelfSigned JWKs" {
                description "Public self signed JWKS"
                tags "JWK"
            }
          }
        }
        apigw -> authorizerLambda "Validates requests"
        authorizerLambda -> exampleLambda "Forwards authorized requests"
        exampleLambda -> apigw "Returns a message"
        authorizerLambda -> selfSignedJwk "Validates JWTs based on public selfsigned JWKS"
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
