#!/bin/bash
sudo yum install -y yum-utils 
sudo yum-config-manager --add-repo   https://download.docker.com/linux/centos/docker-ce.repo 
sudo yum -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker
sudo usermod -aG docker centos 
sudo systemctl restart docker 
echo "Wait for 5 Sec"
sleep 5
sudo chmod 666 /var/run/docker.sock 
sudo systemctl restart docker 
sudo curl -L "https://github.com/docker/compose/releases/download/v2.12.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo mv /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose

