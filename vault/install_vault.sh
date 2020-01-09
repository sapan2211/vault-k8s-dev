#!/bin/bash
wget https://releases.hashicorp.com/vault/1.3.1/vault_1.3.1_linux_amd64.zip
unzip ./vault_1.3.1_linux_amd64.zip
mv vault /usr/local/bin
mkdir -p /etc/certs
openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/certs/vault.crt -keyout /etc/certs/vault.key
ip="`ip route get 1.2.3.4 | awk '{print $7}'`"
sed -i "s/<private-ip>/$ip/g" vault.hcl
vault server -dev -config=vault.hcl > vault.log
