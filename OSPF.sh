#!/bin/bash

set -e

echo "===> Установка FRR"
apt update
apt install frr -y

echo "===> Включение демона OSPF"
sed -i 's/^ospfd=no/ospfd=yes/' /etc/frr/daemons

echo "===> Перезапуск FRR"
systemctl restart frr

echo "===> Конфигурация через vtysh"
vtysh <<EOF
configure terminal
router ospf
 passive-interface default
 network 192.168.10.0/29 area 0
 network 192.168.20.0/29 area 0
 network 192.168.30.0/29 area 0
 network 192.168.99.0/29 area 0
 network 10.10.10.0/30 area 0
 area 0 authentication
exit
interface TUNNEL
 no ip ospf network broadcast
 no ip ospf passive
 ip ospf authentication
 ip ospf authentication-key password
end
do write
exit
EOF

echo "===> Финальный перезапуск FRR"
systemctl restart frr

echo "===> Готово. FRR настроен."
