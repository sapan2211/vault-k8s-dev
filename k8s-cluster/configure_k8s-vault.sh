#!/bin/bash

# Get Latest vault
wget https://releases.hashicorp.com/vault/1.3.1/vault_1.3.1_linux_amd64.zip
unzip ./vault_1.3.1_linux_amd64.zip

#move to accesible location
mv vault /usr/local/bin

#Configuration of Vault to enable kubernetes.
# Set VAULT_SA_NAME to the service account you created earlier

VAULT_SA_NAME=$(kubectl get sa vault-auth --insecure-skip-tls-verify -o jsonpath="{.secrets[*]['name']}")

# Set SA_JWT_TOKEN value to the service account JWT used to access the TokenReview API

SA_JWT_TOKEN=$(kubectl get secret $VAULT_SA_NAME --insecure-skip-tls-verify -o jsonpath="{.data.token}" | base64 --decode; echo)

# Set SA_CA_CRT to the PEM encoded CA cert used to talk to Kubernetes API
SA_CA_CRT=$(kubectl get secret $VAULT_SA_NAME --insecure-skip-tls-verify -o jsonpath="{.data['ca\.crt']}" | base64 --decode; echo)

# Set K8S_HOST to minikube IP address
K8S_HOST=$(cluster-master ip)

export VAULT_ADDR=https://172.31.2.99:8200

# Enable the Kubernetes auth method at the default path ("auth/kubernetes")
vault auth enable kubernetes

# Tell Vault how to communicate with the Kubernetes (Minikube) cluster
vault write auth/kubernetes/config token_reviewer_jwt="$SA_JWT_TOKEN" kubernetes_host="https://$K8S_HOST:8443" kubernetes_ca_cert="$SA_CA_CRT"

unset VAULT_ADDR
rm /usr/local/bin/vault
rm vault_1.3.1_linux_amd64.zip
