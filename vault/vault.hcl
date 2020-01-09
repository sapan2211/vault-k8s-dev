listener "tcp" {
  tls_cert_file = "/etc/certs/vault.crt"
  tls_key_file  = "/etc/certs/vault.key"
  address = "<private-ip>:8200"
  address = "127.0.0.1:8200"
}

# Advertise the non-loopback interface
api_addr = "<private-ip>:8200"
cluster_addr = "https://<private-ip>:8201"
