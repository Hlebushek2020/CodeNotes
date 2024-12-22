alt linux

https://www.altlinux.org/Nextcloud

```bash
sudo apt-get update
sudo apt-get install nano
```

```bash
echo 192.168.100.65/16 > /etc/net/ifaces/ens18/ipv4address
echo default via 192.168.100.1 > /etc/net/ifaces/ens18/ipv4route
echo nameserver 192.168.100.1 > /etc/net/ifaces/ens18/resolv.conf
```

```bash
lsblk
sudo mkfs.ext4 /dev/sdb
```

```bash
sudo blkid
sudo nano /etc/fstab
```

Установка, запуск и вход в консоль СУБД mariadb
```bash
apt-get install mariadb-server
systemctl enable --now mysqld
mysql -u root
```

Создание БД для nextcloud
```mysql
create user 'nextcloud'@'localhost' identified by 'PASSWORD';
create database nextcloud default character set utf8 collate utf8_unicode_ci;
grant all privileges on nextcloud.* to nextcloud@localhost;
```

Немедленная перезагрузка
```bash
reboot now
```

Установка nextcloud. Посмотреть на первом шаге **ВЕРСИЮ** устанавливаемых php зависимостей, поменять версию во второй команде!
```bash
apt-get install nextcloud nextcloud-apache2
apt-get install php8.2-pdo_mysql php8.2-mysqlnd
```

Создание самоподписанного сертификата
```bash
openssl.exe req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -keyout /crt/nextcloud-private.key -out /crt/nextcloud-certificate.crt
```

Конфигурирование Apache
```bash
cp /etc/httpd2/conf/sites-available/nextcloud.conf /etc/httpd2/conf/sites-available/nextcloud.conf.backup
echo '
<IfModule ssl_module>
   <VirtualHost *:443>
      DocumentRoot "/var/www/webapps/nextcloud/"
      ServerName nextcloud.sergei.plesx.ru
      ServerAdmin webmaster@example.com
      ErrorLog "/var/log/httpd2/nextcloud_error_log"
      TransferLog "/var/log/httpd2/nextcloud_access_log"
      SSLEngine on
      SSLProtocol all -SSLv2
      SSLCipherSuite HIGH:MEDIUM:!aNULL:!MD5
      SSLCertificateFile "/crt/nextcloud-certificate.crt"
      SSLCertificateKeyFile "/crt/nextcloud-private.key"
      <IfModule mod_headers.c>
            Header always set Strict-Transport-Security "max-age=15552000; includeSubDomains; preload"
      </IfModule>
      <Directory /var/www/webapps/nextcloud/>
            Require all granted
            Options FollowSymlinks MultiViews
            AllowOverride All
            <IfModule mod_dav.c>
                  Dav off
            </IfModule>

            SetEnv HOME /var/www/webapps/nextcloud
            SetEnv HTTP_HOME /var/www/webapps/nextcloud
      </Directory>
   </VirtualHost>
</IfModule>

<VirtualHost *:80>
   ServerName nextcloud.sergei.plesx.ru
   Redirect permanent / https://nextcloud.sergei.plesx.ru/
</VirtualHost>
' > /etc/httpd2/conf/sites-available/nextcloud.conf
```

Включаем сервис Apache и тут же запускаем
```bash
systemctl enable --now httpd2
```