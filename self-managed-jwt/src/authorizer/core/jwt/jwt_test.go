package jwt

import (
	"authorizer/core/jwks"
	"log"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
)

var (
	key    *jwks.JWK
	issuer = "my.issuer.com"
)

func init() {
	var err error
	key, err = jwks.New()
	if err != nil {
		log.Fatalln(err)
	}
}

func TestInvalidClaimsJwt(t *testing.T) {
	raw := "eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJpc3N1ZXIiLCJzdWIiOiJzdWJqZWN0In0.gpHyA1B1H6X4a4Edm9wo7D3X2v3aLSDBDG2_5BzXYe0"
	randomIssuer := "my.random.issuer"
	err := ValidateIdToken(&raw, &randomIssuer, key)
	assert.EqualError(t, err, "Invalid JWT :square/go-jose: error in cryptographic primitive")
}

func TestInvalidJwt(t *testing.T) {
	raw := "asdasdasd"
	randomIssuer := "my.random.issuer"
	err := ValidateIdToken(&raw, &randomIssuer, key)
	assert.EqualError(t, err, "Couldn't parse base64 jwt")
}

func createValidJwtPair(issuer string) (error, *string, *string) {
	audience := "internal"
	subject := "subject"

	err, userInfoTok, refreshTok := NewJwt(JwtClaims{
		Issuer:   &issuer,
		Audience: &audience,
		Subject:  &subject,
		Groups:   []string{},
		Expiry:   time.Now().Add(time.Minute).Unix(),
	}, key)
	return err, userInfoTok, refreshTok
}

func TestValidJwt(t *testing.T) {
	err, userInfoTok, refreshTok := createValidJwtPair(issuer)
	assert.Nil(t, err)
	assert.NotEmpty(t, userInfoTok)
	assert.NotEmpty(t, refreshTok)
	err = ValidateIdToken(userInfoTok, &issuer, key)
	assert.Nil(t, err)
}

func TestJwtJwkNil(t *testing.T) {
	_, userInfoTok, _ := createValidJwtPair(issuer)
	err := ValidateIdToken(userInfoTok, &issuer, nil)
	assert.EqualError(t, err, "Error, creating JWT, key must not be nil")
}

func TestJwtJwkEmpty(t *testing.T) {
	_, userInfoTok, _ := createValidJwtPair(issuer)
	err := ValidateIdToken(userInfoTok, &issuer)
	assert.EqualError(t, err, "Error creating JWT, you need to supply at least 1 JWK")
}

func TestErrorJwkNil(t *testing.T) {
	issuer := "my.random.issuer"
	audience := "internal"
	subject := "subject"

	err, _, _ := NewJwt(JwtClaims{
		Issuer:   &issuer,
		Audience: &audience,
		Subject:  &subject,
		Groups:   []string{},
		Expiry:   time.Now().Add(time.Minute).Unix(),
	}, nil)

	assert.EqualError(t, err, "Error, creating JWT, key must not be nil")
}

func TestErrorJwkNotPresent(t *testing.T) {
	issuer := "my.random.issuer"
	audience := "internal"
	subject := "subject"

	err, _, _ := NewJwt(JwtClaims{
		Issuer:   &issuer,
		Audience: &audience,
		Subject:  &subject,
		Groups:   []string{},
		Expiry:   time.Now().Add(time.Minute).Unix(),
	})

	assert.EqualError(t, err, "Error creating JWT, you need to supply at least 1 JWK")
}
