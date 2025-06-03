#!/bin/bash

set -e

echo "===> Установка NFS-сервера..."
#apt update
apt install -y nfs-kernel-server

echo "===> Создание каталога /raid0/nfs..."
mkdir -p /raid0/nfs

echo "===> Установка прав доступа 777 на /raid0/nfs..."
chmod 777 /raid0/nfs

echo "===> Настройка /etc/exports..."
echo "/raid0/nfs 192.168.20.3/29(rw,sync,no_root_squash,subtree_check)" >> /etc/exports

echo "===> Применение экспорта NFS..."
exportfs -ra

echo "===> Перезапуск службы NFS..."
systemctl restart nfs-kernel-server

echo "===> Проверка экспортов..."
exportfs -v

sleep 2
