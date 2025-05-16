#!/bin/bash

set -e

echo "===> Установка необходимых пакетов..."
apt update
apt install -y vlan bridge-utils

echo "===> Загрузка модуля 8021q..."
modprobe 8021q

echo "===> Добавление конфигурации VLAN в /etc/network/interfaces..."

cat <<EOF >> /etc/network/interfaces

# VLAN configuration
auto vlan100
iface vlan100 inet static
    address 192.168.10.5/29
    vlan-raw-device ens36

auto vlan200
iface vlan200 inet static
    address 192.168.20.5/29
    vlan-raw-device ens37

auto vlan999
iface vlan999 inet static
    address 192.168.99.5/29
    vlan-raw-device ens38
EOF

echo "===> Готово. Чтобы применить изменения, перезапусти сетевой сервис:"
echo "      systemctl restart networking"
