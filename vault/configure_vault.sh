#!/bin/bash
# Create a policy named myapp-kv-ro
vault policy write myapp-kv-ro myapp-kv-ro.hcl

# Enable K/V v1 at secret/ if it's not already available
# vault secrets enable -path=secret kv

# Create test data in the `secret/myapp` path.
vault kv put secret/myapp/config username='appuser' password='suP3rsec(et!' ttl='30s'

# Enable userpass auth method
vault auth enable userpass

# Create a user named "test-user"
vault write auth/userpass/users/test-user password=training policies=myapp-kv-ro

# Create a role named, 'example' to map Kubernetes Service Account to
#  Vault policies and default token TTL
vault write auth/kubernetes/role/example bound_service_account_names=vault-auth bound_service_account_namespaces=default policies=myapp-kv-ro ttl=24h

~

