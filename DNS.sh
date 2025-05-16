#!/bin/bash

set -e

echo "===> Установка dnsmasq..."
apt update
apt install -y dnsmasq

echo "===> Настройка /etc/dnsmasq.conf..."
cat <<EOF >> /etc/dnsmasq.conf

# Настройки для au-team.irpo
domain=au-team.irpo
local=/au-team.irpo/
expand-hosts
domain-needed
interface=ens33
listen-address=192.168.10.3
no-resolv
server=8.8.8.8

# Записи A и PTR
address=/hq-srv.au-team.irpo/192.168.10.3
ptr-record=3.10.168.192.in-addr.arpa,hq-srv.au-team.irpo

address=/hq-rtr.au-team.irpo/192.168.10.1
ptr-record=1.10.168.192.in-addr.arpa,hq-rtr.au-team.irpo

address=/hq-cli.au-team.irpo/192.168.20.3
ptr-record=3.20.168.192.in-addr.arpa,hq-cli.au-team.irpo

address=/br-rtr.au-team.irpo/192.168.30.1

address=/br-srv.au-team.irpo/192.168.30.3

# CNAME запись
cname=moodle.au-team.irpo,hq-rtr.au-team.irpo
EOF

echo "===> Настройка /etc/hosts..."
# Вставка строк после "127.0.1.1 debian"
awk '
  /^127\.0\.1\.1[ \t]+debian/ {
    print
    print "192.168.10.1 hq-rtr.au-team.irpo hq-rtr"
    print "192.168.10.1 wiki.au-team.irpo wiki"
    print "192.168.10.1 moodle.au-team.irpo moodle"
    next
  }
  { print }
' /etc/hosts > /tmp/hosts && mv /tmp/hosts /etc/hosts

echo "===> Перезапуск dnsmasq..."
systemctl restart dnsmasq
