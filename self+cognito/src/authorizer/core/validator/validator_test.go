package validator

import (
	"authorizer/core/jwks"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
	"gopkg.in/square/go-jose.v2"
)

var rawCognitoJson = `{"keys":[{"alg":"RS256","e":"AQAB","kid":"9ZFieblfcx/ARxuLdItN0qZ95kcsGSt5kfHwF9DDwDQ=","kty":"RSA","n":"uphnJQ3n_Pj4uP1NmakxsxMm9K1HDs8JTYPPtj6v9ZVaVTCJ0YTCXaU5IcBdhxUgdan06bD5hk6iXEUEttteSfJJngPDHnb3VMUjp_hRQgx4FoMp5RBCMiIDsRS-KE0lD8eaRt3z05-Slx1H3QlgzAPZmFuZ_XynFCIPJ3r6YPQyP-MH2iTfsHuvy1UzehlCyAsxKff-xiOEMQKPqgx3ZpUlxS-UaB5Xs50gYGAtvhI2QODJwE37yxTNQJAHXsAiCzLXPBUhGsJhozQ5jun8qr6U-C6OCeevyFbLRbxali1aKW5wA0F4m-G6vpPq0SRfQwdbWTB61xOHHnFfzi_3bw","use":"sig"},{"alg":"RS256","e":"AQAB","kid":"yi3h3SDmd4N0q3w3Ooeazy25j30eB8cU3/sASXz1T3E=","kty":"RSA","n":"yhjA4nCv2ySceWgurM0Sy3CMDADD8XFQi8Rdoc1vXy7f1aiO6VxANZzuZg-Y3ndCFBxxIpt7_RoDyklRANFfY6R3OiNdBQBmpcQq8BaaTGFLsCBnuDUNLlNUXrwNZpO4N7jkbp3M3SEWAndpW8L4KyEfoJZFYhjROCosWKBCRY5AkNzEE8k2dnhEx_-QdNW3WXmkbvTTKXkW42BW469uP42Cyy-NYVVdp-f_4SnFj4zbu3wLSdWN1h-neOwBT_rpic5JEDrZLGbcc-3aINIa2zRadCz8PXcbBA50pCzk__AA17GxPfr7kN7DBll1Ped9ox2JpmVm2AR0JKmaC8WoLw","use":"sig"}]}`

var rawSelfSignedJson = `{"keys":[{"use":"sig","kty":"EC","kid":"ArSyiVhFo1DVQYR0P4EVGVuRvSxSYaklTaPp9MOV_PM=","crv":"P-256","alg":"ES256","x":"zO8K-ZSBGfJsHk2bX-rK-8CkdGmsk0VL8vQDIy70yPE","y":"vKdhgqW88u3tvaMUSlXhyE1eeRskgwmPDjtHJsMnoOY"}]}`

// Expired
var expiredTok = "eyJhbGciOiJFUzI1NiIsImtpZCI6IkFyU3lpVmhGbzFEVlFZUjBQNEVWR1Z1UnZTeFNZYWtsVGFQcDlNT1ZfUE09In0.eyJhdWQiOiJteS5qd3QuYXVkaWVuY2UiLCJleHAiOjE2NTc5MzkzMjAsImdyb3VwcyI6WyJhZG1pbiJdLCJpYXQiOjE2NTc5MzkyNjAsImlzcyI6Im15Lmp3dC5pc3N1ZXIiLCJqdGkiOiJsbVdfTGlablRXNXplS2lnTVZtenpITklZTTN6NlltTndNSG1IZkZyNXBzPSIsIm5hbWUiOiJlbWFpbEBleGFtcGxlLmNvbSIsIm5iZiI6MTY1NzkzOTI2MCwic3ViIjoiZW1haWxAZXhhbXBsZS5jb20ifQ.rVgH7pNph3BJ9nAmrKmS2gXAQIABlJB4dkMv9qW2h2T03TwOjyBfNPyLo5tI2BIHZl8Fo8XVNUV0oGD6bQDiUg"

// No kid in header
var noKidInHeaderTok = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJPbmxpbmUgSldUIEJ1aWxkZXIiLCJpYXQiOjE2NTc5NDUxNjUsImV4cCI6MTY4OTQ4MTE2NSwiYXVkIjoid3d3LmV4YW1wbGUuY29tIiwic3ViIjoianJvY2tldEBleGFtcGxlLmNvbSIsIkdpdmVuTmFtZSI6IkpvaG5ueSIsIlN1cm5hbWUiOiJSb2NrZXQiLCJFbWFpbCI6Impyb2NrZXRAZXhhbXBsZS5jb20iLCJSb2xlIjpbIk1hbmFnZXIiLCJQcm9qZWN0IEFkbWluaXN0cmF0b3IiXX0.vLSauV5Szye3Xi2yEfWSDa0yt8B3zQEMwnoQbyHbwHo"

// Key id not present in JWKS
var noValidKeyIdTok = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Im15S2V5SWQifQ.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.MvsliXUA5bPPd7D2zyvafAtOnps6NL-Ka61KSvTi5Mc"

// Key present but forgered
var foregeredKeyIdTok = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IjlaRmllYmxmY3gvQVJ4dUxkSXROMHFaOTVrY3NHU3Q1a2ZId0Y5RER3RFE9In0.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.8zFogzlmqbQJLe5SLxZOTOJc0NKg2iFrSgtH9aRu_XU"

func generateEDCKeys() (*jose.JSONWebKeySet, *jwks.JWKS) {
	keyPair1, err := jwks.NewES256()
	if err != nil {
		panic(err)
	}
	keyPair2, err := jwks.NewES256()
	if err != nil {
		panic(err)
	}

	var public jose.JSONWebKeySet

	privKeys := jwks.New(keyPair1, keyPair2)
	for _, privKey := range privKeys.Keys {
		public.Keys = append(public.Keys, privKey.GetPublicKey())
	}
	return &public, privKeys
}

var JwtTests = []struct {
	expectedErr string
	token       string
}{
	{"Token is expired", expiredTok},
	{"the JWT has an invalid kid: could not find kid in JWT header", noKidInHeaderTok},
	{"the given key ID was not found in the JWKS", noValidKeyIdTok},
	{"key is of invalid type", foregeredKeyIdTok},
}

var testJwkProvider *JwkProvider

func TestMain(m *testing.M) {
	// Setup
	var err error
	err, testJwkProvider = New(rawSelfSignedJson, rawCognitoJson)
	if err != nil {
		panic(err)
	}
	code := m.Run()
	os.Exit(code)
}

func TestTokValidator(t *testing.T) {
	for _, tt := range JwtTests {
		err, _ := testJwkProvider.Validate(&tt.token)
		assert.EqualError(t, err, tt.expectedErr)
	}
}

var claimsTests = []struct {
	expectedErr    string
	actualClaims   map[string]interface{}
	expectedClaims map[string]interface{}
}{
	{"At least the \"iss\" claim must be suplied in expected", map[string]interface{}{}, map[string]interface{}{}},
	{"", map[string]interface{}{
		"iss": "myIssuer",
	}, map[string]interface{}{
		"iss": "myIssuer",
	}},
	{"does not match with expected myIssuer", map[string]interface{}{}, map[string]interface{}{
		"iss": "myIssuer",
	}},
	{"does not match with expected myAudience", map[string]interface{}{
		"iss": "myIssuer",
	}, map[string]interface{}{
		"iss": "myIssuer",
		"aud": "myAudience",
	}},
}

func TestClaimsValidator(t *testing.T) {
	for _, tt := range claimsTests {
		err := ValidateClaims(tt.actualClaims, tt.expectedClaims)
		if tt.expectedErr == "" {
			assert.Nil(t, err)
		} else {

			assert.ErrorContains(t, err, tt.expectedErr)
		}
	}
}
