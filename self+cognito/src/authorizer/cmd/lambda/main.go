package main

import (
	"authorizer/app/config"
	"authorizer/app/utils"
	"authorizer/core/validator"
	"encoding/base64"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"

	"context"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"go.uber.org/zap"
)

var cognitoIssuer = os.Getenv("COGNITO_ISSUER")

func handleRequest(jwkProvider *validator.JwkProvider, ctx context.Context, event events.APIGatewayCustomAuthorizerRequestTypeRequest) (events.APIGatewayCustomAuthorizerResponse, error) {
	base64Token := event.Headers["Auth"]
	var err_msg string
	err, claims := jwkProvider.Validate(&base64Token)

	if err != nil {
		err_msg = err.Error()
		origin := event.Headers["X-Forwarded-For"]
		zap.S().Warn(fmt.Sprintf("Denying request for user \"%s\"", origin))
		return utils.GeneratePolicy(origin, "Deny", event.MethodArn, &err_msg, nil), nil
	}
	jti := claims["jti"].(string)
	zap.S().Warn(fmt.Sprintf("Allowing request for user \"%s\"", jti))

	var groups []string
	if valGroups, ok := claims["groups"]; ok {
		for _, group := range valGroups.([]interface{}) {
			groups = append(groups, group.(string))
		}
	} else {
		groups = []string{"cognito"}
	}
	zap.S().Info(claims)
	return utils.GeneratePolicy(jti, "Allow", event.MethodArn, nil, groups), nil
}

func main() {
	logger, _ := zap.NewProduction()
	zap.ReplaceGlobals(logger)
	defer logger.Sync()
	appConfig := config.GetConfig()
	publicJwk, err := base64.URLEncoding.DecodeString(appConfig.PublicJwk)
	if err != nil {
		zap.S().Fatal(err)
	}
	cognitoJwksUrl := fmt.Sprintf("%s/.well-known/jwks.json", cognitoIssuer)
	resp, err := http.Get(cognitoJwksUrl)
	if err != nil {
		zap.S().Fatal(err)
	}
	cognitoJwks, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		zap.S().Fatal(err)
	}
	err, jwkProvider := validator.New(string(publicJwk), string(cognitoJwks))
	if err != nil {
		zap.S().Fatal(err)
	}
	lambda.Start(func(ctx context.Context, event events.APIGatewayCustomAuthorizerRequestTypeRequest) (events.APIGatewayCustomAuthorizerResponse, error) {
		return handleRequest(jwkProvider, ctx, event)
	})
}
