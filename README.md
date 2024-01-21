# Vault using S3

How to deploy to fly.dev

```
APP_NAME=vault-${RANDOM}
flyctl apps create --name ${APP_NAME} --machines
flyctl secrets set -a ${APP_NAME} S3_ENDPOINT=https://play.min.io:9443
flyctl secrets set -a ${APP_NAME} S3_REGION=us-east-1
flyctl secrets set -a ${APP_NAME} S3_ACCESS_KEY=Q3AM3UQ867SPQQA43P2F
flyctl secrets set -a ${APP_NAME} S3_SECRET_KEY=zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG
flyctl secrets set -a ${APP_NAME} S3_BUCKET=vault-backend
fly deploy -a ${APP_NAME} -c fly.toml
```

