#!/bin/bash

#config in https://blog.apnic.net/2022/05/27/making-a-krill-sandbox/

systemctl enable nginx


#rewrite executer of nginx
sed -i -e 's/user www-data;/user root;/g' /etc/nginx/nginx.conf

rm /etc/nginx/sites-enabled/default

cat <<EOL >> /etc/nginx/sites-enabled/yamaguchi.conf

server {
    listen 80 ;
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

systemctl start nginx




