#!/bin/bash

# Укажи IP HQ-SRV и внешний интерфейс маршрутизатора
HQ_SRV_IP="192.168.10.3"
WAN_IFACE="eth0"  # замените на свой внешний интерфейс

echo "===> Проброс портов и NAT для HQ-SRV ($HQ_SRV_IP) через $WAN_IFACE..."

# Проброс порта 80
iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination ${HQ_SRV_IP}:80
iptables -A FORWARD -p tcp -d ${HQ_SRV_IP} --dport 80 -j ACCEPT

# Проброс порта 3015
iptables -t nat -A PREROUTING -p tcp --dport 3015 -j DNAT --to-destination ${HQ_SRV_IP}:3015
iptables -A FORWARD -p tcp -d ${HQ_SRV_IP} --dport 3015 -j ACCEPT

# NAT для выхода в интернет
iptables -t nat -A POSTROUTING -o ${WAN_IFACE} -j MASQUERADE

# Сохраняем правила
netfilter-persistent save

echo "===> Настройка завершена."
