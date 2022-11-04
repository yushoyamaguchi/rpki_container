#!/bin/bash

systemctl enable krill

#rewrite executer of /usr/lib/systemd/system/routinator.service 
sed -i -e 's/User=krill/User=root/g' /usr/lib/systemd/system/krill.service


systemctl start krill