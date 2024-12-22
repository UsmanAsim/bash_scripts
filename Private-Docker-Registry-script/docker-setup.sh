#!/bin/bash

# Exit script on error
set -e

# Install required tools
echo "Installing yum-utils..."
sudo yum install -y yum-utils

# Add Docker repository
echo "Adding Docker repository..."
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Install Docker packages
echo "Installing Docker..."
sudo yum install -y docker-ce docker-ce-cli containerd.io

# Enable and start Docker service
echo "Enabling and starting Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

# Add the current user to the Docker group
echo "Adding user $USER to the Docker group..."
sudo usermod -aG docker $USER

# Ensure Docker is enabled
echo "Ensuring Docker service is enabled..."
sudo systemctl enable docker

# Install Docker Compose
echo "Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Make Docker Compose executable
echo "Setting execute permissions for Docker Compose..."
sudo chmod +x /usr/local/bin/docker-compose

# Update PATH
echo "Verifying PATH..."
echo $PATH

# Create a symbolic link for Docker Compose
echo "Creating a symbolic link for Docker Compose..."
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Verify Docker Compose installation
echo "Checking Docker Compose version..."
docker-compose --version

echo "Docker and Docker Compose installation completed successfully!"
