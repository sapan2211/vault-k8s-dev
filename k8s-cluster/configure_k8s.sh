#!/bin/bash

# Create a service account, 'vault-auth'
kubectl create serviceaccount vault-auth

# Update the 'vault-auth' service account
kubectl apply --filename vault-auth-service-account.yml


