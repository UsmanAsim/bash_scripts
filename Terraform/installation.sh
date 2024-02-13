#!/bin/bash

# Install yum-utils if not installed
echo "Installing yum-utils..."
sudo yum install -y yum-utils

# Add HashiCorp repository
echo "Adding HashiCorp repository..."
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo

# Install Terraform
echo "Installing Terraform..."
sudo yum -y install terraform

# Display Terraform version and help
echo "Terraform installed. Checking Terraform version and help options..."
terraform -version
terraform -help

# Download AWS CLI installer
echo "Downloading AWS CLI installer..."
sudo curl "https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Unzip AWS CLI installer
echo "Unzipping AWS CLI installer..."
sudo unzip awscliv2.zip

# Install AWS CLI
echo "Installing AWS CLI..."
sudo ./aws/install

# Display AWS CLI version and help
echo "AWS CLI installed. Checking AWS CLI version and help options..."
aws --version
aws help

echo "Installation completed."
