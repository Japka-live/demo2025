#!/bin/bash

# Укажи IP-адрес BR-SRV
BR_SRV_IP="192.168.20.3"

echo "===> Проброс порта 80 на ${BR_SRV_IP}:8080..."
iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination ${BR_SRV_IP}:8080
iptables -A FORWARD -p tcp -d ${BR_SRV_IP} --dport 8080 -j ACCEPT

echo "===> Проброс порта 2024 на ${BR_SRV_IP}:2024..."
iptables -t nat -A PREROUTING -p tcp --dport 2024 -j DNAT --to-destination ${BR_SRV_IP}:2024
iptables -A FORWARD -p tcp -d ${BR_SRV_IP} --dport 2024 -j ACCEPT

echo "===> Сохранение iptables через netfilter-persistent..."
netfilter-persistent save

echo "===> Готово. Порты проброшены на ${BR_SRV_IP}"
