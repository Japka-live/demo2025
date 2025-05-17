#!/bin/bash

set -e

echo "===> Установка chrony..."
#apt update
apt install -y chrony

echo "===> Настройка /etc/chrony/chrony.conf..."

# Комментируем строку pool и добавляем server
awk '
  /pool 2\.debian\.pool\.ntp\.org iburst/ {
    print "#" $0
    print ""
    print "server 192.168.10.1 iburst"
    next
  }
  { print }
' /etc/chrony/chrony.conf > /tmp/chrony.conf && mv /tmp/chrony.conf /etc/chrony/chrony.conf

echo "===> Перезапуск chronyd..."
systemctl restart chronyd
