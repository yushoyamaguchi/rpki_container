#!/bin/bash

systemctl enable krill
systemctl enable nginx

#rewrite executer of /usr/lib/systemd/system/krill.service 
sed -i -e 's/User=krill/User=root/g' /usr/lib/systemd/system/krill.service


#rewrite executer of nginx
sed -i -e 's/user www-data;/user root;/g' /etc/nginx/nginx.conf


cat <<EOL >> /etc/krill.conf
[testbed]
# RRDP BASE URI
#
# Set the base RRDP uri for the testbed repository server.
#
# It is highly recommended to use a proxy in front of Krill.
#
# To expose the RRDP files you can actually proxy back to your testbed
# krill server (https://<yourkrill>/rrdp/), or you can expose the
# files as they are written to disk ($data_dir/repo/rrdp/)
#
# Set the following value to *your* public proxy hostname and path.
rrdp_base_uri = "https://krill.example.org/rrdp/"

# RSYNC BASE URI
#
# Set the base rsync URI (jail) for the testbed repository server.
#
# Make sure that you have an rsyncd running and a module which is
# configured to expose the rsync repository files. By default these
# files would be saved to: $data/repo/rsync/current/
rsync_jail = "rsync://krill.example.org/repo/"

# TA AIA
#
# Set the rsync location for your testbed trust anchor certificate.
#
# You need to configure an rsync server to expose another module for the
# TA certificate. Don't use the module for the repository as its
# content will be overwritten.
#
# Manually retrieve the TA certificate from krill and copy it
# over - it won't change again. You can get it at:
# https://<yourkrill>/ta/ta.cer
ta_aia = "rsync://krill.example.org/ta/ta.cer"

# TA URI
#
# Like above, make the TA certificate available over HTTPS and
# specify the url here so that it may be included in the TAL.
ta_uri = "https://krill.example.org/ta/ta.cer"
EOL


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