package jwks

import (
	"crypto/sha1"
	"encoding/base64"
	"encoding/json"
	"errors"
	"fmt"
	"time"

	math_rand "math/rand"

	"gopkg.in/square/go-jose.v2"
	"gopkg.in/square/go-jose.v2/jwt"
)

type JWKS struct {
	Keys []*JWK
}

func New(keys ...*JWK) *JWKS {
	var result JWKS
	for _, key := range keys {
		result.Keys = append(result.Keys, key)
	}
	return &result
}

func (jwks *JWKS) Marshal() ([]byte, error) {
	var result jose.JSONWebKeySet
	for _, key := range jwks.Keys {
		result.Keys = append(result.Keys, key.key)
	}
	data, err := json.Marshal(result)
	if err != nil {
		return nil, err
	}
	return data, nil
}

func MarshalPublic(jwks jose.JSONWebKeySet) ([]byte, error) {
	for _, pubKey := range jwks.Keys {
		if !pubKey.IsPublic() {
			return nil, errors.New("At least one of the supplied jwks is private, aborting")
		}
	}
	data, err := json.Marshal(jwks)
	if err != nil {
		return nil, nil
	}
	return data, nil
}

func LoadPrivateFromBase64(base64Jwks string) (*JWKS, error) {
	data, err := base64.URLEncoding.DecodeString(base64Jwks)
	if err != nil {
		return nil, errors.New(fmt.Sprintf("Couldn't decode base64 Jwk Set: %v", err))
	}
	jwks := jose.JSONWebKeySet{}
	err = json.Unmarshal(data, &jwks)

	if err != nil {
		return nil, errors.New(fmt.Sprintf("Couldn't parse Jwk Set: %v", err))
	}
	var result JWKS
	for _, key := range jwks.Keys {
		if key.IsPublic() {
			return nil, errors.New("Only private keys are allowed to be loaded by LoadPrivateFromBase64")
		}
		result.Keys = append(result.Keys, &JWK{
			key,
		})
	}
	return &result, nil
}

func LoadPublicFromBase64(base64Jwks string) (*jose.JSONWebKeySet, error) {
	data, err := base64.URLEncoding.DecodeString(base64Jwks)
	if err != nil {
		return nil, errors.New(fmt.Sprintf("Couldn't decode base64 Jwk Set: %v", err))
	}
	jwks := jose.JSONWebKeySet{}
	err = json.Unmarshal(data, &jwks)

	if err != nil {
		return nil, errors.New(fmt.Sprintf("Couldn't parse Jwk Set: %v", err))
	}
	for _, key := range jwks.Keys {
		if !key.IsPublic() {
			return nil, errors.New("Only public keys are allowed to be loaded by LoadPublicFromBase64")
		}
	}
	return &jwks, nil
}

type JwtClaims struct {
	Issuer   *string
	Audience *string
	Subject  *string
	Groups   []string
	Expiry   time.Duration
}

func (jwks *JWKS) NewJWT(claims *JwtClaims) (*string, error) {
	headers := make(map[jose.HeaderKey]interface{})
	randomKey := jwks.Keys[math_rand.Intn(len(jwks.Keys))].key
	headers[jose.HeaderKey("kid")] = randomKey.KeyID
	opts := jose.SignerOptions{ExtraHeaders: headers}
	signer, err := jose.NewSigner(jose.SigningKey{Algorithm: jose.SignatureAlgorithm(randomKey.Algorithm), Key: randomKey}, &opts)
	if err != nil {
		return nil, err
	}

	now := time.Now()
	nowUnix := now.Unix()
	hasher := sha1.New()
	hasher.Write([]byte(fmt.Sprintf("%s-%d", *claims.Subject, nowUnix)))
	jti := base64.URLEncoding.EncodeToString(hasher.Sum(nil))

	raw, err := jwt.Signed(signer).Claims(map[string]interface{}{
		"iss":    claims.Issuer,
		"aud":    claims.Audience,
		"sub":    claims.Subject,
		"jti":    jti,
		"groups": claims.Groups,
		"exp":    now.Add(claims.Expiry).Unix(),
		"nbf":    nowUnix,
		"iat":    nowUnix,
	}).CompactSerialize()
	if err != nil {
		return nil, errors.New(fmt.Sprintf("Couldn't create JWT for subject %s", *claims.Subject))
	}

	return &raw, nil
}
