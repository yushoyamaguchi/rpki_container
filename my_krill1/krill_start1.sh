#!/bin/bash

systemctl enable krill
systemctl enable nginx

#rewrite executer of /usr/lib/systemd/system/krill.service 
sed -i -e 's/User=krill/User=root/g' /usr/lib/systemd/system/krill.service


#rewrite executer of nginx
sed -i -e 's/user www-data;/user root;/g' /etc/nginx/nginx.conf


systemctl start krill


rm /etc/nginx/sites-enabled/default

cat <<EOL >> /etc/nginx/sites-enabled/krill.example.org
server {
      server_name krill.example.org;
      client_max_body_size 100M;

      location / {
              proxy_pass https://localhost:3000/;
      }

  listen 80;
}
EOL

systemctl start nginx