#!/bin/bash


systemctl enable routinator

#rewrite executer of /usr/lib/systemd/system/routinator.service 
sed -i -e 's/User=routinator/User=root/g' /usr/lib/systemd/system/routinator.service


systemctl start routinator

echo -e "10.0.0.1\tkrill.example.org" >> /etc/hosts