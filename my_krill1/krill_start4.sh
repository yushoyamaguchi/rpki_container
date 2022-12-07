#!/bin/bash

systemctl enable krill
systemctl enable nginx
systemctl enable rsync

#rewrite executer of /usr/lib/systemd/system/krill.service 
sed -i -e 's/User=krill/User=root/g' /usr/lib/systemd/system/krill.service


#rewrite executer of nginx
sed -i -e 's/user www-data;/user root;/g' /etc/nginx/nginx.conf



cat <<EOL > /etc/krill.conf

###########################################################
#                                                         #
#                       DATA                              #
#                                                         #
###########################################################

# We use the default data_dir used by the Debian package.
data_dir = "/var/lib/krill/data/"

###########################################################
#                                                         #
#                      LOGGING                            #
#                                                         #
###########################################################

# We will use syslog and the default log level (warn):
log_type = "syslog"
### log_level = "warn"
### syslog_facility = "daemon"

###########################################################
#                                                         #
#                       ACCESS                            #
#                                                         #
###########################################################

# Admin Token
#
# We use an admin token, rather than multi-user support. We
# will use the CLI as the primary way to manage this server,
# and we like to keep things simple.
admin_token = "yama80"

# Service URI
#
# We will use the public (base) URI for our (nginx) proxy, so
# that remote CAs can connect to our testbed.
service_uri = "https://localhost:3000/"


[testbed]
###########################################################
#                                                         #
#                  TESTBED SETTINGS                       #
#                                                         #
###########################################################
# RRDP BASE URI
#
# Set the base RRDP uri for the repository server. 
rrdp_base_uri = "https://krill.example.org/rrdp/"

# RSYNC BASE URI
#
# Set the base rsync URI (jail) for the repository server.
rsync_jail = "rsync://krill.example.org/repo/"

# TA URI
# 
# Define the TA certificate HTTPS URI for the TAL.
ta_uri = "https://krill.example.org/ta/ta.cer"

# TA AIA
#
# Define the TA certificate rsync URI for the TAL. 
ta_aia = "rsync://krill.example.org/ta/ta.cer"
EOL

sed -i '/\[Service\]/a ReadWritePaths=/mnt/volume_ams3_03/krill-data/' /usr/lib/systemd/system/krill.service


systemctl start krill


mkdir /mnt/volume_ams3_03
mkdir /mnt/volume_ams3_03/krill-data
ln -s /mnt/volume_ams3_03/krill-data /var/lib/krill/data


rm /etc/nginx/sites-enabled/default

cat <<EOL >> /etc/nginx/sites-enabled/krill.example.org
server {
  server_name krill.example.org;
  client_max_body_size 100M;

  # Rewrite the TAL URI used on the testbed page to the real file.
  rewrite ^/testbed.tal$ /ta/ta.tal;

  # Maps to the base directory where krill-sync stores RRDP files.
  location /rrdp {
     root /var/lib/krill-sync/;
  }

  # Maps to the base directory where we copy the TA certificate and TAL.
  location /ta {
     root /mnt/volume_ams3_03/repository/;
  }

  # All other requests go to the krill backend.
  location / {
    proxy_pass https://localhost:3000/;
  }

  listen 80;
}
EOL


systemctl start nginx

mkdir /mnt/volume_ams3_03/repository
mkdir /mnt/volume_ams3_03/repository/ta

curl --insecure https://localhost:3000/ta/ta.tal --output /mnt/volume_ams3_03/repository/ta/ta.tal
curl --insecure https://localhost:3000/ta/ta.cer --output /mnt/volume_ams3_03/repository/ta/ta.cer


cat <<EOL > /etc/rsyncd.conf
uid = root
gid = root
max connections = 50

[repo]
path = /var/lib/krill-sync/rsync/current/
comment = RPKI repository
read only = yes

[ta]
path = /mnt/volume_ams3_03/repository/ta/
comment = Testbed Trust Anchor
read only = yes
EOL

mkdir -p /mnt/volume_ams3_03/repository/rrdp
ln -s /mnt/volume_ams3_03/repository/rrdp /var/lib/krill-sync/rrdp
mkdir -p /mnt/volume_ams3_03/repository/rsync
ln -s /mnt/volume_ams3_03/repository/rsync /var/lib/krill-sync/rsync


systemctl start rsync