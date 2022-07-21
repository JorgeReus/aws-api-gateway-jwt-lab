package utils

import (
	"strings"

	"github.com/aws/aws-lambda-go/events"
)

func GeneratePolicy(principalId, effect, resource string, message *string, groups []string) events.APIGatewayCustomAuthorizerResponse {
	authResponse := events.APIGatewayCustomAuthorizerResponse{PrincipalID: principalId}

	if effect != "" && resource != "" {
		authResponse.PolicyDocument = events.APIGatewayCustomAuthorizerPolicy{
			Version: "2012-10-17",
			Statement: []events.IAMPolicyStatement{
				{
					Action:   []string{"execute-api:Invoke"},
					Effect:   effect,
					Resource: []string{resource},
				},
			},
		}
	}

	authResponse.Context = map[string]interface{}{
		"messageString": message,
		"groups":        strings.Join(groups, ","),
	}
	return authResponse
}
