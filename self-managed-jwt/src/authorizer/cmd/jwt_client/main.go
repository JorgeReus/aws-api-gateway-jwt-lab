package main

import (
	"authorizer/core/jwks"
	"authorizer/core/jwt"
	"crypto/sha256"
	"encoding/base64"
	"fmt"
	"log"
	"os"
	"time"
)

var PUBLIC_JWK = "eyJ1c2UiOiJzaWciLCJrdHkiOiJFQyIsImtpZCI6IkFyU3lpVmhGbzFEVlFZUjBQNEVWR1Z1UnZTeFNZYWtsVGFQcDlNT1ZfUE09IiwiY3J2IjoiUC0yNTYiLCJhbGciOiJFUzI1NiIsIngiOiJ6TzhLLVpTQkdmSnNIazJiWC1ySy04Q2tkR21zazBWTDh2UURJeTcweVBFIiwieSI6InZLZGhncVc4OHUzdHZhTVVTbFhoeUUxZWVSc2tnd21QRGp0SEpzTW5vT1kifQ=="
var PRIVATE_JWK = "eyJ1c2UiOiJzaWciLCJrdHkiOiJFQyIsImtpZCI6IkFyU3lpVmhGbzFEVlFZUjBQNEVWR1Z1UnZTeFNZYWtsVGFQcDlNT1ZfUE09IiwiY3J2IjoiUC0yNTYiLCJhbGciOiJFUzI1NiIsIngiOiJ6TzhLLVpTQkdmSnNIazJiWC1ySy04Q2tkR21zazBWTDh2UURJeTcweVBFIiwieSI6InZLZGhncVc4OHUzdHZhTVVTbFhoeUUxZWVSc2tnd21QRGp0SEpzTW5vT1kiLCJkIjoiU3hCTXhaWFByOHNRNGRRRGpSQ2sybDk1UkVHR1ZkTV9HTUVyMWJoU2VNdyJ9"
var JWT_ISSUER = "my.jwt.issuer"
var JWT_AUDIENCE = "my.jwt.audience"

func main() {
	err, key1 := jwks.LoadFromBase64(&PUBLIC_JWK, &PRIVATE_JWK)
	if err != nil {
		log.Fatal(err)
	}

	subject := "email@example.com"
	expiry := time.Now().Add(time.Minute).Unix()

	hasher := sha256.New()
	hasher.Write([]byte(fmt.Sprintf("%s-%d", subject, expiry)))
	jti := base64.URLEncoding.EncodeToString(hasher.Sum(nil))
	now := time.Now().Unix()

	err, userInfoTok, _ := jwt.NewJwt(jwt.JwtClaims{
		Issuer:   &JWT_ISSUER,
		Audience: &JWT_AUDIENCE,
		Subject:  &subject,
		Groups: []string{
			os.Args[1],
		},
		Expiry:    expiry,
		JTI:       &jti,
		Name:      &subject,
		IssuedAt:  now,
		NotBefore: now,
	}, key1)

	fmt.Println(*userInfoTok)
}
