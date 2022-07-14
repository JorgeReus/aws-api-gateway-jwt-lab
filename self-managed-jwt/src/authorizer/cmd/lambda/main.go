package main

import (
	"authorizer/app/config"
	"authorizer/app/utils"
	"authorizer/core/jwks"
	"authorizer/core/jwt"

	"context"
	"log"
	"strings"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"go.uber.org/zap"
)

func handleRequest(jwkProvider *jwks.JWK, ctx context.Context, event events.APIGatewayCustomAuthorizerRequest) (events.APIGatewayCustomAuthorizerResponse, error) {
	appConfig := config.GetConfig()
	auth_header := event.AuthorizationToken
	token_parts := strings.Split(auth_header, "Bearer ")
	var err_msg string
	if len(token_parts) != 2 {
		err_msg = "Invalid Bearer token, not in Bearer <token> form"
		return utils.GeneratePolicy("user", "Deny", event.MethodArn, &err_msg), nil
	}
	base64Token := strings.Split(auth_header, "Bearer ")[1]
	_, tokens := jwks.LoadFromBase64(&appConfig.PublicJwk, &appConfig.PrivateJwk)
	err := jwt.ValidateIdToken(&base64Token, &appConfig.JwtIssuer, tokens)
	if err != nil {
		err_msg = err.Error()
		return utils.GeneratePolicy("user", "Deny", event.MethodArn, &err_msg), nil
	}
	return utils.GeneratePolicy("user", "Allow", event.MethodArn, nil), nil
}

func main() {
	logger, _ := zap.NewProduction()
	zap.ReplaceGlobals(logger)
	defer logger.Sync()
	appConfig := config.GetConfig()
	err, jwkProvider := jwks.LoadFromBase64(&appConfig.PublicJwk, &appConfig.PrivateJwk)
	if err != nil {
		log.Fatal(err)
	}
	lambda.Start(func(ctx context.Context, event events.APIGatewayCustomAuthorizerRequest) (events.APIGatewayCustomAuthorizerResponse, error) {
		return handleRequest(jwkProvider, ctx, event)
	})
}
