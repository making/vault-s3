FROM hashicorp/vault:1.16.3
COPY <<'EOF' /usr/local/bin/run-vault
#!/bin/sh
set -e
cat <<EOC > /vault/config/config.hcl
ui = true
disable_mlock = true
storage "s3" {
  endpoint    = "${S3_ENDPOINT}"
  region      = "${S3_REGION}"
  access_key  = "${S3_ACCESS_KEY}"
  secret_key  = "${S3_SECRET_KEY}"
  bucket      = "${S3_BUCKET}"
  disable_ssl = "${S3_DISABLE_SSL:-false}"
  s3_force_path_style = "${S3_FORCE_PATH_STYLE:-false}"
}

listener "tcp" {
 address = "0.0.0.0:8200"
 tls_disable = 1
}
EOC

if [ -n "$AZURE_TENANT_ID" ] && [ -n "$AZURE_CLIENT_ID" ] && [ -n "$AZURE_CLIENT_SECRET" ] && [ -n "$KEYVAULT_NAME" ] && [ -n "$KEY_NAME" ]; then
cat <<EOK >> /vault/config/config.hcl

seal "azurekeyvault" {
  tenant_id      = "$AZURE_TENANT_ID"
  client_id      = "$AZURE_CLIENT_ID"
  client_secret  = "$AZURE_CLIENT_SECRET"
  vault_name     = "$KEYVAULT_NAME"
  key_name       = "$KEY_NAME"
}
EOK
fi

/usr/local/bin/docker-entrypoint.sh server
EOF
RUN chmod +x /usr/local/bin/run-vault

ENTRYPOINT ["/usr/local/bin/run-vault"]
