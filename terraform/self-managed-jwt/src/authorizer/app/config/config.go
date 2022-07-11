package config

import (
	"log"

	"github.com/ilyakaznacheev/cleanenv"
)

var (
	c *appConfig
)

type redis_hosts []string

type appConfig struct {
	PublicJwk   string `env:"PUBLIC_JWK" env-required:"true"`
	PrivateJwk  string `env:"PRIVATE_JWK" env-required:"true"`
	JwtIssuer   string `env:"JWT_ISSUER" env-required:"true"`
	JwtAudience string `env:"JWT_AUDIENCE" env-required:"true"`
}

func GetConfig() *appConfig {
	if c == nil {
		c = new(appConfig)
		err := cleanenv.ReadEnv(c)
		if err != nil {
			log.Fatal(err)
		}
	}
	return c
}
