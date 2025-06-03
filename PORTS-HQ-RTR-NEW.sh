#!/bin/bash

# Укажите IP-адрес HQ-SRV ниже
HQ_SRV_IP="192.168.10.3"

echo "===> Настройка iptables для проброса портов к HQ-SRV ($HQ_SRV_IP)..."

# Проброс порта 80 на HQ-SRV:80 (для Moodle)
iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination ${HQ_SRV_IP}:80
iptables -A FORWARD -p tcp -d ${HQ_SRV_IP} --dport 80 -j ACCEPT

# Проброс порта 3015 на HQ-SRV:3015
iptables -t nat -A PREROUTING -p tcp --dport 3015 -j DNAT --to-destination ${HQ_SRV_IP}:3015
iptables -A FORWARD -p tcp -d ${HQ_SRV_IP} --dport 3015 -j ACCEPT

# Сохраняем правила
netfilter-persistent save

echo "===> Проброс портов завершен."
