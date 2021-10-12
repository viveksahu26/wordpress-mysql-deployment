echo "Creating folder dvd and mounting to dev-cdrom"
mkdir  /dvd
mount  /dev/cdrom  /dvd/

cat <<EOF | sudo tee -a /etc/rc.d/rc.local
mount  /dev/cdrom  /dvd/
EOF

chmod +x  /etc/rc.d/rc.local

echo "configuring repo for yum"
cat <<EOF | sudo tee /etc/yum.repos.d/rhel.repo
[AppStream]
baseurl=file:///dvd/AppStream
gpgcheck=0

[BaseOS]
baseurl=file:///dvd/BaseOS
gpgcheck=0
EOF

yum repolist

echo "configuring repo for docker"
cat <<EOF | sudo tee /etc/yum.repos.d/docker.repo
[docker]
baseurl=https://download.docker.com/linux/centos/7/x86_64/stable/
gpgcheck=0
EOF

echo "Installing docker now."
yum install  docker-ce --nobest -y
systemctl enable docker --now

echo "configuring repo for kubernetes.."

cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

echo "Installing kubelet kubeadm kubectl"
yum install -y kubelet kubeadm kubectl

systemctl enable --now kubelet

kubeadm config images pull

docker info | grep -i cgroup

cat <<EOF | sudo tee  /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

systemctl restart docker

docker info | grep -i cgroup

yum install iproute-tc -y

kubeadm init --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=NumCPU --ignore-preflight-errors=Mem

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply  -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

kubeadm token create  --print-join-command
