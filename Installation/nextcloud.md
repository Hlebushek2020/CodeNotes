alt linux

sudo apt-get update
sudo apt-get install nano

echo 192.168.100.65/16 > /etc/net/ifaces/ens18/ipv4address
echo default via 192.168.100.1 > /etc/net/ifaces/ens18/ipv4route
echo nameserver 192.168.100.1 > /etc/net/ifaces/ens18/resolv.conf

lsblk
sudo mkfs.ext4 /dev/sdb

sudo blkid
sudo nano /etc/fstab

apt-get install mariadb-server
systemctl enable --now mysqld
mysql -u root

```sql
create user 'nextcloud'@'localhost' identified by 'PASSWORD';
create database nextcloud default character set utf8 collate utf8_unicode_ci;
grant all privileges on nextcloud.* to nextcloud@localhost;
```

reboot now

apt-get install nextcloud nextcloud-apache2
apt-get install php8.2-pdo_mysql php8.2-mysqlnd  //check version!!

systemctl enable --now httpd2

Создание самоподписанного сертификата
```bash
openssl.exe req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -keyout /crt/nextcloud-private.key -out /crt/nextcloud-certificate.crt
```