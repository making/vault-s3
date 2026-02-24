FROM hashicorp/vault:1.16.2
COPY <<'EOF' /usr/local/bin/run-vault
#!/bin/sh
set -ex
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
/usr/local/bin/docker-entrypoint.sh server
EOF
RUN chmod +x /usr/local/bin/run-vault

ENTRYPOINT ["/usr/local/bin/run-vault"]
