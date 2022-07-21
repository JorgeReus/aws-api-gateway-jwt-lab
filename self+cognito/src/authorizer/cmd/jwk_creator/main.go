package main

import (
	"authorizer/core/jwks"
	"encoding/base64"
	"encoding/json"
	"fmt"

	flag "github.com/spf13/pflag"
	"gopkg.in/square/go-jose.v2"
)

var keyType *string = flag.String("type", "ES256", "The algorithm to use to generate keys")

func main() {
	flag.Parse()
	var priv1, priv2, priv3 *jwks.JWK
	if *keyType == "ES256" {
		priv1, _ = jwks.NewES256()
		priv2, _ = jwks.NewES256()
		priv3, _ = jwks.NewES256()
	} else if *keyType == "RS256" {
		priv1, _ = jwks.NewRS256()
		priv2, _ = jwks.NewRS256()
		priv3, _ = jwks.NewRS256()
	} else {
		panic("Unknown value supplied for type, only ES256 and RS256 are allowed")
	}
	privKeys := jwks.New(priv1, priv2, priv3)
	var pubKeys jose.JSONWebKeySet
	for _, privKey := range privKeys.Keys {
		pubKeys.Keys = append(pubKeys.Keys, privKey.GetPublicKey())
	}

	private, _ := privKeys.Marshal()
	privBase64 := base64.URLEncoding.EncodeToString(private)

	pubJson, _ := jwks.MarshalPublic(pubKeys)
	pubBase64 := base64.URLEncoding.EncodeToString(pubJson)

	keys := map[string]string{
		"private": privBase64,
		"public":  pubBase64,
	}

	result, _ := json.MarshalIndent(keys, "", "  ")
	fmt.Println(string(result))
}
