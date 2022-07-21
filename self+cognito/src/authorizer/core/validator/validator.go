package validator

import (
	"encoding/json"
	"errors"
	"fmt"

	"github.com/MicahParks/keyfunc"
	"github.com/golang-jwt/jwt/v4"
)

type jwkset struct {
	Keys []struct {
		Use string `json:"use"`
		Kty string `json:"kty"`
		Kid string `json:"kid"`
		Alg string `json:"alg"`
		E   string `json:"e"`
		N   string `json:"n"`
		Crv string `json:"crv"`
		X   string `json:"x"`
		Y   string `json:"y"`
	} `json:"keys"`
}

type JwkProvider struct {
	keySet *keyfunc.JWKS
	parser *jwt.Parser
}

func loadJsonKeys(rawJwks ...string) (error, json.RawMessage) {
	var resultKeys jwkset
	for _, rawJwk := range rawJwks {
		var jwk jwkset
		err := json.Unmarshal([]byte(rawJwk), &jwk)
		if err != nil {
			return err, nil
		}

		for _, key := range jwk.Keys {
			resultKeys.Keys = append(resultKeys.Keys, key)
		}
	}

	data, err := json.Marshal(resultKeys)
	if err != nil {
		return err, nil
	}
	return nil, json.RawMessage(data)
}

func New(rawJwks ...string) (err error, provider *JwkProvider) {
	err, keys := loadJsonKeys(rawJwks...)
	if err != nil {
		return err, nil
	}
	jwks, err := keyfunc.NewJSON(keys)
	if err != nil {
		return err, nil
	}

	return nil, &JwkProvider{
		keySet: jwks,
		parser: &jwt.Parser{},
	}
}

func (provider *JwkProvider) Validate(rawToken *string) (error, map[string]interface{}) {
	// Validate that the token is expired and that the token was signed with some key of the key set
	token, err := provider.parser.Parse(*rawToken, provider.keySet.Keyfunc)
	if err != nil {
		return err, nil
	}

	claims := token.Claims.(jwt.MapClaims)
	return nil, claims
}

func ValidateClaims(actual map[string]interface{}, expected map[string]interface{}) error {
	// Validate issuer
	actualIss := actual["iss"]
	expectedIss := expected["iss"]
	if expectedIss == nil {
		return errors.New("At least the \"iss\" claim must be suplied in expected")
	}
	if actualIss != expectedIss {
		return errors.New(fmt.Sprintf("Issuer %s does not match with expected %s", actualIss, expectedIss))
	}

	// Validate other claims
	for k, v := range expected {
		if k != "iss" && actual[k] != v {
			return errors.New(fmt.Sprintf("Claim %s with value %s does not match with expected %s", k, actual[k], v))
		}
	}
	return nil
}
