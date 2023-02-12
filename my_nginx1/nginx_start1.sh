#!/bin/bash

#config in https://blog.apnic.net/2022/05/27/making-a-krill-sandbox/

systemctl enable nginx


#rewrite executer of nginx
sed -i -e 's/user www-data;/user root;/g' /etc/nginx/nginx.conf

rm /etc/nginx/sites-enabled/default

cat <<EOL >> /etc/nginx/sites-enabled/yamaguchi.test

server {
    listen 80 ;
    location / {
        root /var/www;
        access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log;
    }
}

server {
    listen 443 ;
    ssl on;
	server_name www.example.com;
	ssl_certificate /etc/nginx/ssl/server.crt; # サーバー証明書のパス
	ssl_certificate_key /etc/nginx/ssl/server.key; # 秘密鍵のパス
    location / {
        root /var/www;
        access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log;
    }
}
EOL


cat <<EOL >>/var/www/index.html
<!DOCTYPE html>
<html lang="ja">
  <head>
    <meta charset="utf-8">
    <title>nginx test</title>
  </head>
  <body>
    <h1>Yamaguchi ! </h1>
  </body>
</html>
EOL



SJ="/CN=yamaguchi.test"
mkdir -p /etc/nginx/ssl
openssl genrsa -out /etc/nginx/ssl/server.key 2048
openssl req -new -key /etc/nginx/ssl/server.key -out /etc/nginx/ssl/server.csr -subj "$SJ"
openssl x509 -in /etc/nginx/ssl/server.csr -days 365 -req -signkey /etc/nginx/ssl/server.key > /etc/nginx/ssl/server.crt



systemctl start nginx




