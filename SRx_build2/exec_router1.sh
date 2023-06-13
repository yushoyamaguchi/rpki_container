#/bin/bash

systemctl start rsyslog
cd /NIST-BGP-SRx/local-6.2.0/etc
cp zebra.conf.sample zebra.conf 
cp bgpd.conf.sample bgpd.conf
cd ../sbin
./zebra -d
./bgpd -d