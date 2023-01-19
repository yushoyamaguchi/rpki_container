#!/bin/bash


systemctl enable routinator

#rewrite executer of /usr/lib/systemd/system/routinator.service 
sed -i -e 's/User=routinator/User=root/g' /usr/lib/systemd/system/routinator.service

mkdir /tal
routinator --config /etc/routinator/routinator.conf --extra-tals-dir=tal config
echo "extra-tals-dir = \"/tal\" " >> /etc/routinator/routinator.conf

systemctl start routinator

echo -e "10.0.0.1\tkrill.example.org" >> /etc/hosts

curl --insecure http://krill.example.org/ta/ta.tal >> /tal/ta.tal