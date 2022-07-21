package main

import (
	"authorizer/core/jwks"
	"fmt"
	"log"
	"os"
	"time"
)

var PRIVATE_JWK = "eyJrZXlzIjpbeyJ1c2UiOiJzaWciLCJrdHkiOiJFQyIsImtpZCI6IkVOS1NwbjEyWmJjeUlYYm5tR09GUEVaTm5hMGJ4MzNtejNUa2d1cWtaSWM9IiwiY3J2IjoiUC0yNTYiLCJhbGciOiJFUzI1NiIsIngiOiJqSF9qMF8wcE5EWElyZEZ5UnA5b2hFdjd3VzgtdFkwZV96aWd2US02ZTEwIiwieSI6ImM5WGFLSVFHMWNfbXVHSnE1MWcxcHAwQ19DSmdmSE1XYXhiaUc3c3pjbVkiLCJkIjoicjQ0NE5VUFJqUnJULU5OekJzV0NyWGJDSVlJMkloajJRNUloN1EzcXhnZyJ9LHsidXNlIjoic2lnIiwia3R5IjoiRUMiLCJraWQiOiJFdXZSdFZhWkpOV3Q5a09qb3VxaWN6SWkxZzZvMHRZNjFLU0JQbTUzQ3hRPSIsImNydiI6IlAtMjU2IiwiYWxnIjoiRVMyNTYiLCJ4Ijoiem9YUFlfVGstLWRRQ1l2ejMxcTEzejJqWl9FR0tMYkRidlpjcU5VelROWSIsInkiOiJDeFFWQkdmYUlKSjRRN25Mam42aEdRVkhwTndtTzMzTnZXd3FKRU5KcExFIiwiZCI6IlZleDZ0TU1NcmMxTTFjR1ZWUUhweUQxTmJyRzdFWVBBMVptbXJRak12Z2cifSx7InVzZSI6InNpZyIsImt0eSI6IkVDIiwia2lkIjoiU2lfZlplcHF0YWZ2NWNiWUtJdmtRZVdMNGVMdzZWZk9sQVB2MWl6Wkp3QT0iLCJjcnYiOiJQLTI1NiIsImFsZyI6IkVTMjU2IiwieCI6IldUTHJhWXJ0ZDRnSDNmdmhBWC1GQzJZcGNRYWFYbVVjMUFDWGt5bmoyeDAiLCJ5IjoiNngtVldxMzFxVnp6YWwwVjUyajR5aUJwMmoyS0h2X2h4d2RndXo0cWgzbyIsImQiOiJ4bkRmWVZiMGFHTFhBdVFIUkNTUWp3cFpBcjlYTEViV0xUUllCSXhNbFNVIn1dfQ=="
var JWT_ISSUER = "my.jwt.issuer"
var JWT_AUDIENCE = "my.jwt.audience"

func main() {
	jwkProvider, err := jwks.LoadPrivateFromBase64(PRIVATE_JWK)
	if err != nil {
		log.Fatal(err)
	}

	subject := "email@example.com"
	token, err := jwkProvider.NewJWT(&jwks.JwtClaims{
		Issuer:   &JWT_ISSUER,
		Audience: &JWT_AUDIENCE,
		Subject:  &subject,
		Groups: []string{
			os.Args[1],
		},
		Expiry: time.Minute * 1,
	})

	fmt.Println(*token)
}
