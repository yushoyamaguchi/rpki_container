#!/bin/bash

systemctl enable krill
systemctl enable nginx

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