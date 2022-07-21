package jwks

import (
	"encoding/base64"
	"testing"

	"github.com/stretchr/testify/assert"
	"gopkg.in/square/go-jose.v2"
)

func generateEDCKeys(t *testing.T) (*jose.JSONWebKeySet, *JWKS) {
	keyPair1, err := NewES256()
	assert.Nil(t, err)
	jsonKeyPair, err := keyPair1.ToJson()

	assert.NotEmpty(t, jsonKeyPair)
	keyPair2, err := NewES256()
	assert.Nil(t, err)

	var public jose.JSONWebKeySet

	privKeys := New(keyPair1, keyPair2)
	for _, privKey := range privKeys.Keys {
		public.Keys = append(public.Keys, privKey.GetPublicKey())
	}
	return &public, privKeys
}

func TestRSAKeys(t *testing.T) {
	t.Parallel()
	// Create RSA keys
	keyPair1, err := NewRS256()
	assert.Nil(t, err)
	assert.NotEmpty(t, keyPair1)
	keyPair2, err := NewRS256()
	assert.NotEmpty(t, keyPair2)
	assert.Nil(t, err)

	edcKeyPair, err := NewES256()
	assert.NotEmpty(t, edcKeyPair)
	assert.Nil(t, err)

	// Create EDC keys and merge with the RSA
	privateKeys := New(keyPair1, keyPair2, edcKeyPair)

	var numRsa = 0
	var numEdc = 0
	for _, jwk := range privateKeys.Keys {
		if jwk.key.Algorithm == "RS256" {
			numRsa += 1
		} else if jwk.key.Algorithm == "ES256" {
			numEdc += 1
		} else {
			t.Fatalf("Key with different algorithm was present, undefined behaviour")
		}
	}

	assert.Equal(t, numRsa, 2)
	assert.Equal(t, numEdc, 1)
}

func TestMergeKeys(t *testing.T) {
	t.Parallel()
	public, private := generateEDCKeys(t)

	// Asser the array has two keys
	assert.Equal(t, 2, len(public.Keys))
	assert.Equal(t, 2, len(private.Keys))
}

func TestLoadFrombase64(t *testing.T) {

	public, private := generateEDCKeys(t)
	t.Parallel()
	publicData, err := MarshalPublic(*public)
	assert.Nil(t, err)
	assert.NotEmpty(t, publicData)

	privateData, err := private.Marshal()
	assert.Nil(t, err)
	assert.NotEmpty(t, privateData)

	// Convert to base64
	base64Public := base64.URLEncoding.EncodeToString(publicData)
	publicConverted, err := LoadPublicFromBase64(base64Public)
	assert.Nil(t, err)
	assert.NotEmpty(t, publicConverted)

	// Assert the converted keys are all public
	for _, key := range publicConverted.Keys {
		assert.True(t, key.IsPublic())
	}

	base64Private := base64.URLEncoding.EncodeToString(privateData)
	privateConverted, err := LoadPrivateFromBase64(base64Private)
	// Assert the converted keys are all private
	assert.Nil(t, err)
	assert.NotEmpty(t, privateConverted)
}
