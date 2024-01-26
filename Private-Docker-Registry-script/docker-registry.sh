#!/bin/bash
sudo mkdir -p /registry && cd "$_"
sudo mkdir -p certs && cd certs
yum -y update
openssl genrsa -out ca.key 2048
openssl req -new -x509 -days 365 -key ca.key -subj "/C=lh/ST=pb/L=as/O=sys/CN=dockerregistry.com" -out ca.crt
openssl req -newkey rsa:2048 -nodes -keyout server.key -subj "/C=lh/ST=pb/L=as/O=sys/CN=*.dockerregistry.com" -out server.csr
openssl x509 -req -extfile <(printf "subjectAltName=DNS:dockerregistry.com,DNS:www.dockerregistry.com") -days 365 -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt
sudo mkdir -p /etc/docker/certs.d/dockerregistry.com
cp /registry/certs/server.crt /etc/docker/certs.d/dockerregistry.com
cp /registry/certs/server.crt /usr/local/share/ca-certificates
update-ca-trust
cd ..
sudo mkdir -p auth && cd auth
sudo yum install httpd-tools.x86_64
htpasswd -Bc registry.password admin
echo "Creating Docker-Compose file and add necessary content"
sudo tee /registry/docker-compose.yaml<<EOF
version: "3.3"
services:
  registry:
    image: registry:2
    ports:
      - 443:5000
    container_name: docker_registry
    environment:
      REGISTRY_AUTH: htpasswd
      REGISTRY_AUTH_HTPASSWD_REALM: Registry
      REGISTRY_AUTH_HTPASSWD_PATH: /auth/registry.password
      REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY: /data
      REGISTRY_HTTP_TLS_CERTIFICATE: /certs/server.crt
      REGISTRY_HTTP_TLS_KEY: /certs/server.key
    volumes:
      - /registry/data:/data
      - /registry/auth:/auth
      - /registry/certs:/certs
EOF
docker-compose up -d
docker ps
