workspace "AWS APIGW cognito" "Example of implementing A basic REST API with cognito authorizers" {
    model {
      softwareSystem = softwareSystem "REST API with Cognito Authorizers" "Example for showcasing cognito authorizers for a REST API" {
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

            cognitoAuthorizer = infrastructureNode "Authorizer" {
                description "Decides if a request is allowed to proceed"
            }

            exampleLambda = infrastructureNode "Example" {
                description "Default labmda for a /lab path"
                tags "Amazon Web Services - Lambda Lambda Function"
            }

            cognitoUserPool = infrastructureNode "User Pool" {
                description "Manages System users"
                tags "Amazon Web Services - Cognito"
            }
          }
        }
        apigw -> cognitoAuthorizer "Validates requests"
        cognitoAuthorizer -> exampleLambda "Forwards authorized requests"
        cognitoAuthorizer -> cognitoUserPool "Get cognito JWK"
        exampleLambda -> apigw "Returns a message"
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

          element "Infrastructure Node" {
              shape roundedbox
          }
      }

      themes https://static.structurizr.com/themes/amazon-web-services-2020.04.30/theme.json
    }
}
