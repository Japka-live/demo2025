#!/bin/bash

set -e

echo "===> Установка NFS-клиентских утилит..."
#apt update
apt install -y nfs-common

echo "===> Создание точки монтирования /mnt/nfs..."
mkdir -p /mnt/nfs

echo "===> Монтирование NFS-ресурса..."
mount 192.168.10.3:/raid0/nfs /mnt/nfs

echo "===> Проверка смонтированных файловых систем..."
df -h
sleep 2

echo "===> Добавление записи в /etc/fstab..."
echo "192.168.10.3:/raid0/nfs /mnt/nfs nfs defaults 0 0" >> /etc/fstab

echo "===> Повторное монтирование всех файловых систем..."
mount -a

echo "===> Перезагрузка системы..."
reboot
