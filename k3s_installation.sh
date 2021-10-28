# youtube link:- https://www.youtube.com/watch?v=QDwhbMvikGQ
# Set-up LoadBalancer i.e.nginx
vi /etc/selinux/config   -----> SELINUX=disabled
reboot
dnf install nginx -y
cat  /etc/nginx/nginx.conf
mv /etc/nginx/nginx.conf  /etc/nginx/nginx.conf.bk
vi /etc/nginx/nginx.conf ----->  
      "worker_processes 4;
      worker_rlimit_nofile 40000;

      events {
          worker_connections 8192;
      }

      stream {
          upstream k3snodes {
              least_conn;
              server 192.168.100.51:6443 max_fails=3 fail_timeout=5s;
              server 192.168.100.52:6443 max_fails=3 fail_timeout=5s;
              server 192.168.100.53:6443 max_fails=3 fail_timeout=5s;
          }
          server {
              listen 6443;
              proxy_pass k3snodes;
          }
      }
"
systemctl enable nginx
systemctl start nginx

curl -sLS https://get.k3sup.dev | sh -
k3sup -h


# To setup k3s in nodes we need to setup passwordless login
ssh-keygen  -t  rsa    ------> In all nodes
ssh-copy-id   root@192.168.0.103    -----> In all nodes

# Install kubectl in loadbalance node
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

k3sup install \
	--host=192.168.0.103 \
	--user=root \
	--cluster \
	--tls-san 192.168.0.106 \
 	--k3s-extra-args="--node-taint node-role.kubernetes.io/master=true:NoSchedule"
mkdir  .kube

#Inside master
scp  /etc/rancher/k3s/k3s.yaml  root@192.168.0.106:/root/.kube/config

# Join other master node of ip 192.168.0.104
k3sup join --host=192.168.0.104 --server-user=root --server-host=192.168.0.103 --user=root --server  --k3s-extra-args="--node-taint node-role.kubernetes.io/master=true:NoSchedule"

# Join worker node
k3sup join --host=192.168.0.107 --server-user=root --server-host=192.168.0.103 --user=root




