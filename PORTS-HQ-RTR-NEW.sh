#!/bin/bash

# Указываем IP-адрес HQ-SRV
HQ_SRV_IP="172.16.4.1"

echo "===> Проброс порта 80 на ${HQ_SRV_IP}:80..."
iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination ${HQ_SRV_IP}:80
iptables -A FORWARD -p tcp -d ${HQ_SRV_IP} --dport 80 -j ACCEPT

echo "===> Проброс порта 3015 на ${HQ_SRV_IP}:3015..."
iptables -t nat -A PREROUTING -p tcp --dport 3015 -j DNAT --to-destination ${HQ_SRV_IP}:3015
iptables -A FORWARD -p tcp -d ${HQ_SRV_IP} --dport 3015 -j ACCEPT

echo "===> Сохранение правил через netfilter-persistent..."
netfilter-persistent save

echo "===> Готово. Порт 2024 проброшен на ${HQ_SRV_IP}:2024"
