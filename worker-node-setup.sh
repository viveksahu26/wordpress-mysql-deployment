echo "Creating folder dvd and mounting to dev-cdrom"
mkdir  /dvd
mount  /dev/cdrom  /dvd/

cat <<EOF | sudo tee -a /etc/rc.d/rc.local
mount  /dev/cdrom  /dvd/
EOF

chmod +x  /etc/rc.d/rc.local

# epel-release
dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm 
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

yum install -y  kubectl kubelet  kubeadm

systemctl enable kubelet --now

docker info | grep -i cgroup

cat <<EOF | sudo tee  /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

systemctl restart docker

docker info | grep -i cgroup

yum install iproute-tc -y

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl --system


