#!/bin/bash

# Укажи IP-адрес BR-SRV
BR_SRV_IP="192.168.30.3"

echo "===> Проброс порта 80 на ${BR_SRV_IP}:8086..."
iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination ${BR_SRV_IP}:8086
iptables -A FORWARD -p tcp -d ${BR_SRV_IP} --dport 8086 -j ACCEPT

echo "===> Проброс порта 3015 на ${BR_SRV_IP}:3015..."
iptables -t nat -A PREROUTING -p tcp --dport 3015 -j DNAT --to-destination ${BR_SRV_IP}:3015
iptables -A FORWARD -p tcp -d ${BR_SRV_IP} --dport 3015 -j ACCEPT

echo "===> Сохранение iptables через netfilter-persistent..."
netfilter-persistent save

echo "===> Готово. Порты проброшены на ${BR_SRV_IP}"
