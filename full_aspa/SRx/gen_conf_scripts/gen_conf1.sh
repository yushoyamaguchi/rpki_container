#!/bin/bash

ZEBRA_CONF_FILE="/NIST-BGP-SRx/local-6.2.0/etc/zebra.conf"
BGPD_CONF_FILE="/NIST-BGP-SRx/local-6.2.0/etc/bgpd.conf"

cp /NIST-BGP-SRx/local-6.2.0/etc/zebra.conf.sample $ZEBRA_CONF_FILE
INTERFACE=($(echo $(ip addr | grep mtu | cut -f 2 -d ':' | tr '\n' ' ')))
IP_ADDR=($(echo $(ip addr | grep "inet "  | cut -f 6 -d' ' | tr '\n' ' ')))

echo "hostname bgpd" >> $BGPD_CONF_FILE
echo "password  zebra" >> $BGPD_CONF_FILE
echo "log file bgpd.log" >> $BGPD_CONF_FILE
echo "!" >> $BGPD_CONF_FILE

echo "router bgp 65001" >> $BGPD_CONF_FILE
echo " bgp router-id 10.10.10.1" >> $BGPD_CONF_FILE
echo " network 192.168.1.0/24" >> $BGPD_CONF_FILE
echo " network 10.1.0.0/24" >> $BGPD_CONF_FILE
echo " network 10.3.0.0/24" >> $BGPD_CONF_FILE
echo " neighbor 10.1.0.2 remote-as 65002" >> $BGPD_CONF_FILE
echo " neighbor 10.1.0.2 next-hop-self" >> $BGPD_CONF_FILE
echo " neighbor 10.1.0.2 route-map setlocalpre in" >> $BGPD_CONF_FILE
echo " neighbor 10.3.0.1 remote-as 65003" >> $BGPD_CONF_FILE
echo " neighbor 10.3.0.1 next-hop-self" >> $BGPD_CONF_FILE
echo " neighbor 10.3.0.1 route-map setlocalpre in" >> $BGPD_CONF_FILE
echo "!" >> $BGPD_CONF_FILE

echo "route-map setlocalpre permit 10" >> $BGPD_CONF_FILE
echo " set local-preference 100" >> $BGPD_CONF_FILE
echo "!" >> $BGPD_CONF_FILE
echo "line vty" >> $BGPD_CONF_FILE
echo "!" >> $BGPD_CONF_FILE