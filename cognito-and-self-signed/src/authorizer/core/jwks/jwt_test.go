package jwks

import (
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
)

func TestCreateValidJwt(t *testing.T) {
	_, private := generateEDCKeys(t)
	issuer := "my.jwt.issuer"
	aud := "aud"
	sub := "sub"
	groups := []string{
		"myGroup",
	}

	compactJwt, err := private.NewJWT(&JwtClaims{
		Issuer:   &issuer,
		Audience: &aud,
		Subject:  &sub,
		Groups:   groups,
		Expiry:   time.Minute * 2,
	})

	assert.Nil(t, err)
	assert.NotEmpty(t, compactJwt)
}
