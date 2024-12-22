Just go to
cd /etc/yum.repos.d

update appstream, baseous and extras with below line and comment existing

baseurl=http://vault.centos.org/8.5.2111/BaseOS/x86_64/os/

Install Docker and Docker compose
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
sudo systemctl enable docker
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
echo $PATH
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose –version

Registry Installation
cd  /etc/hosts
{ip_ of VM} registry name
Open Ports inbound 5000 + 443 for registry login and access
Run the registry_script
Docker login usman-registry.com
User/pass



cat ~/.docker/config.json
curl -k -X GET https://usman-registry.com/v2/_catalog -H "Authorization: Basic YWRtaW46YWRtaW4="

curl -k -X GET https://usman-registry.com/v2/nginx/tags/list -H "Authorization: Basic YWRtaW46YWRtaW4="


Please make sure every machine where you want to pull/push or login the internal registry the below mentioned need to be placed there
cd  /etc/hosts
the hosts has an entry of the machine with the name and registry.
 

cd /etc/docker/certs.d
it has 1 server.crt copy this crt from the vm where registry was setup and copy to the VM where you will be try to login pull/push the docker registry and images.



