#!/bin/sh
ip tunnel add TUNNEL mode gre remote 172.16.5.2 local 172.16.4.2 ttl 255
ip link set TUNNEL up
ip addr add 10.10.10.1/30 dev TUNNEL
