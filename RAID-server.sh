#!/bin/bash

set -e

echo "===> Установка mdadm..."
#apt update
apt install -y mdadm

echo "===> Создание RAID 5 из /dev/sdb /dev/sdc /dev/sdd..."
mdadm --create --verbose /dev/md0 --level=5 --raid-devices=3 /dev/sdb /dev/sdc /dev/sdd

echo "===> Сканирование и запись конфигурации RAID в /etc/mdadm/mdadm.conf..."
mdadm --detail --scan >> /etc/mdadm/mdadm.conf

echo "===> Обновление initramfs..."
update-initramfs -u

echo "===> Создание раздела на /dev/md0..."
# Создание раздела через fdisk в автоматическом режиме
(
echo n    # Новая партиция
echo p    # Primary
echo      # Номер раздела (по умолчанию 1)
echo      # Начальный сектор (по умолчанию)
echo      # Конечный сектор (по умолчанию)
echo w    # Запись и выход
) | fdisk /dev/md0

# Подождем, пока ядро "увидит" новый раздел
sleep 2

echo "===> Форматирование /dev/md0p1 в ext4..."
mkfs.ext4 /dev/md0p1

echo "===> Создание точки монтирования /raid5..."
mkdir -p /raid5

echo "===> Монтирование /dev/md0p1 в /raid5..."
mount /dev/md0p1 /raid5

echo "===> Получение UUID раздела..."
UUID=$(blkid -s UUID -o value /dev/md0p1)

echo "===> Добавление записи в /etc/fstab..."
echo "UUID=$UUID /raid5 ext4 defaults 0 0" >> /etc/fstab

echo "===> Применение fstab..."
mount -a

echo "===> Перезагрузка системы..."
reboot
