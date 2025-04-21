
USER=$(whoami)

sudo hostnamectl set-hostname k8-master1

vi /etc/hosts

nmtui and fixed the machine ip

######## for installing the Kubenetes components

cd /home/centos/air-gap-k8-setup/kubernetes_rpms

sudo yum localinstall *.rpm --disablerepo="*"

kubectl version
kubeadm version
kubelet --version

######## for installing the containerd

cd /home/centos/air-gap-k8-setup/containerd_setup


tar xzvf containerd-2.0.1-linux-amd64.tar.gz

cp bin/* /usr/local/bin

cp bin/* /usr/bin

cp -r containerd.service /etc/systemd/system/

sudo systemctl restart containerd
sudo systemctl enable containerd
sudo systemctl enable containerd.service
sudo systemctl status containerd

######## for installing the docker



cd /home/centos/air-gap-k8-setup/docker_setup


tar xzvf docker-27.4.1.tgz


cp docker/docker* /usr/local/bin
cp docker/runc* /usr/local/bin
cp docker/docker* /usr/bin
cp docker/runc* /usr/bin

SERVICE_PATH="/etc/systemd/system/docker.service"

# Create or overwrite the docker.service file
cat <<EOF | sudo tee $SERVICE_PATH > /dev/null
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network.target

[Service]
Type=notify
ExecStart=/usr/local/bin/dockerd
ExecReload=/bin/kill -s HUP \$MAINPID
LimitNOFILE=1048576
LimitNPROC=infinity
LimitCORE=infinity
TimeoutStartSec=0
Restart=always
RestartSec=2
KillMode=process

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to apply the changes
sudo systemctl daemon-reload
systemctl enable docker.service

# Enable and start the Docker service
sudo systemctl enable --now docker

# Print the status of the Docker service
sudo systemctl status docker

## disabling firewall and cgroup
sudo modprobe overlay
sudo modprobe br_netfilter

sudo tee /etc/modules-load.d/k8s.conf <<EOF
overlay
br_netfilter
EOF


lsmod | grep br_netfilter

echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables
echo 1 > /proc/sys/net/bridge/bridge-nf-call-ip6tables


vi /etc/sysctl.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1

sysctl -p

sudo systemctl disable --now firewalld

if ! setenforce 0; then   sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config; fi
swapoff -a

## Starting the kubelet

sudo systemctl restart kubelet
sudo systemctl status kubelet
sudo systemctl enable kubelet.service

# loading the images to k8s.io namespace

cd /home/centos/air-gap-k8-setup/kubernetes_images

for img in *.tar; do     ctr -n k8s.io images import "$img"; done


ctr -n k8s.io images list

sudo systemctl restart kubelet
sudo systemctl status kubelet


sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=all --v=5

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl get no



#################

cd /home/centos/air-gap-k8-setup/flannel/images

for img in *.tar; do     ctr -n k8s.io images import "$img"; done

cd /home/centos/air-gap-k8-setup/flannel

kubectl apply -f kube-flannel.yml

kubectl get no
kubectl get pod -A

################

Troubleshooting with flannel

mkdir /etc/containerd
sudo containerd config default > /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl restart kubelet
sudo systemctl status kubelet

kubectl logs kube-flannel-ds-jggtr -n kube-flannel

sudo modprobe overlay
sudo modprobe br_netfilter

sudo tee /etc/modules-load.d/k8s.conf <<EOF
overlay
br_netfilter
EOF


lsmod | grep -E 'overlay|br_netfilter'


vi /var/lib/kubelet/config.yaml
resolvConf: /run/systemd/resolve/resolv.conf remove this andd below thing
resolvConf: /etc/resolv.conf
