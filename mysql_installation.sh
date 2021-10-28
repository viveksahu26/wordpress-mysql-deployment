# https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-centos-7

wget https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm
yum install wget
wget https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm

md5sum mysql57-community-release-el7-9.noarch.rpm
rpm -ivh mysql57-community-release-el7-9.noarch.rpm
yum install mysql-server
systemctl start mysqld
systemctl status mysqld
grep 'temporary password' /var/log/mysql/mysqld.log

# Needs user input
mysql_secure_installation
mysqladmin -u root -p version


#Login to mysql
mysql -u root -p
#Now enter password

# To create a user
CREATE USER 'k3s' IDENTIFIED BY 'newpassword';

FLUSH PRIVILEGES;

GRANT SELECT ON * . * TO 'k3s';


#To create  database
CREATE DATABASE k3s;

GRANT ALL PRIVILEGES ON `k3s` . * TO 'k3s';


#View all users
SELECT User, Host, authentication_string FROM mysql.user;

#view all databases
SHOW DATABASE();
