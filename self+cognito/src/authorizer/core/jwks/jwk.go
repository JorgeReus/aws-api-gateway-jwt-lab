package jwks

import (
	"crypto/ecdsa"
	"crypto/elliptic"
	"crypto/rand"
	"crypto/rsa"
	"crypto/sha256"
	"encoding/base64"
	"errors"
	"fmt"

	"gopkg.in/square/go-jose.v2"
)

type JWK struct {
	key jose.JSONWebKey
}

func NewES256() (jwk *JWK, err error) {
	use := "sig"

	privKey, err := ecdsa.GenerateKey(elliptic.P256(), rand.Reader)
	if err != nil {
		return nil, errors.New("Cannot generate edcsa key with curve P256")
	}

	hasher := sha256.New()
	hasher.Write(privKey.X.Bytes())
	kid := base64.URLEncoding.EncodeToString(hasher.Sum(nil))

	privateJwk := jose.JSONWebKey{Key: privKey, KeyID: kid, Algorithm: string(jose.ES256), Use: use}

	return &JWK{
		key: privateJwk,
	}, nil
}

func NewRS256() (jwk *JWK, err error) {
	use := "sig"
	numBits := 2048

	privKey, err := rsa.GenerateKey(rand.Reader, numBits)
	if err != nil {
		return nil, errors.New(fmt.Sprintf("Cannot generate RSA key with %d num bits", numBits))
	}

	hasher := sha256.New()
	hasher.Write(privKey.N.Bytes())
	kid := base64.URLEncoding.EncodeToString(hasher.Sum(nil))

	privateJwk := jose.JSONWebKey{Key: privKey, KeyID: kid, Algorithm: string(jose.RS256), Use: use}

	return &JWK{
		key: privateJwk,
	}, nil
}

func (jwk *JWK) ToJson() ([]byte, error) {
	raw, err := jwk.key.MarshalJSON()
	if err != nil {
		return nil, err
	}
	return raw, err
}

func (jwk *JWK) GetPublicKey() jose.JSONWebKey {
	return jwk.key.Public()
}
