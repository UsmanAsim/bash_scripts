#!/bin/bash

# Prompt for folder name
read -rp "Enter the folder name to store the SSH key: " folder_name

# Create folder if it doesn't exist
mkdir -p "$folder_name"

# Set key file path
key_path="$folder_name/id_rsa"

# Generate RSA key
echo "Generating RSA key..."
ssh-keygen -t rsa -f "$key_path" -N ""

# Convert private key to PEM format
echo "Converting private key to PEM format..."
ssh-keygen -p -N "" -m pem -f "$key_path"

echo "Key generated and converted successfully."
echo "Private Key: $key_path"
echo "Public Key: ${key_path}.pub"
