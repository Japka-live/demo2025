#!/bin/bash

# Указываем IP-адрес HQ-SRV
HQ_SRV_IP="192.168.10.3"

echo "===> Настройка iptables для проброса порта 2024 на $HQ_SRV_IP..."

# Проброс порта 2024 на HQ-SRV
iptables -t nat -A PREROUTING -p tcp --dport 2024 -j DNAT --to-destination ${HQ_SRV_IP}:2024
iptables -A FORWARD -p tcp -d ${HQ_SRV_IP} --dport 2024 -j ACCEPT

echo "===> Сохранение правил через netfilter-persistent..."
netfilter-persistent save

echo "===> Готово. Порт 2024 проброшен на ${HQ_SRV_IP}:2024"
