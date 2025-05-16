#!/bin/bash

set -e

echo "===> Установка chrony..."
apt update
apt install -y chrony

echo "===> Настройка /etc/chrony/chrony.conf..."

# Закомментировать строку pool и добавить свои строки
awk '
  /pool 2\.debian\.pool\.ntp\.org iburst/ {
    print "#" $0
    print ""
    print "server 192.168.10.1 iburst"
    print "local stratum 5"
    print "allow 192.168.10.0/29"
    print "allow 192.168.20.0/29"
    print "allow 192.168.30.0/29"
    print "allow 10.10.10.0/30"
    next
  }
  { print }
' /etc/chrony/chrony.conf > /tmp/chrony.conf && mv /tmp/chrony.conf /etc/chrony/chrony.conf

echo "===> Перезапуск chronyd..."
systemctl restart chronyd
