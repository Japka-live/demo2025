#!/bin/bash

# Проверка на права суперпользователя
if [ "$EUID" -ne 0 ]; then
    echo "Пожалуйста, запустите скрипт с правами суперпользователя (sudo)."
    exit
fi

# Удаление решетки из net.ipv4.ip_forward
echo "Убираем решетку из поля net.ipv4.ip_forward в /etc/sysctl.conf..."
sed -i 's/#\?\(net.ipv4.ip_forward=\)/\1/' /etc/sysctl.conf

# Применяем изменения
echo "Применяем изменения sysctl..."
sysctl -p

# Установка FRR
echo "Установка FRR..."
apt update
apt install -y frr frr-pythontools

# Обновление конфигурации daemons.conf
echo "Изменяем настройку daemons.conf для OSPF..."
if grep -q "ospfd=no" /etc/frr/daemons.conf; then
    sed -i 's/ospfd=no/ospfd=yes/' /etc/frr/daemons.conf
else
    echo "Настройка ospfd уже установлена на yes или не найдена."
fi

# Перезапуск службы FRR
echo "Перезапуск FRR..."
systemctl restart frr

# Настройка OSPF через vtysh
echo "Настройка OSPF..."
{
    echo "configure terminal"
    echo "router ospf"
    echo "network 192.168.10.0/24 area 0"
    echo "network 192.168.20.0/24 area 0"
    echo "network 192.168.30.0/24 area 0"
    echo "network 10.10.10.0/30 area 0"
    echo "network 10.10.10.4/30 area 0"
    echo "end"
    echo "write"
} | vtysh

echo "Настройка OSPF завершена."
