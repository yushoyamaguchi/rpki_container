#/bin/bash

systemctl start rsyslog
cd /NIST-BGP-SRx/local-6.2.0/sbin
./zebra -d
./bgpd -d