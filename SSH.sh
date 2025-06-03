#!/bin/bash

set -e

echo "===> Установка OpenSSH"
apt install ssh -y

SSHD_CONFIG="/etc/ssh/sshd_config"

echo "===> Настройка sshd_config"

# Снимаем комментарий и меняем порт
sed -i 's/^#Port .*/Port 2024/' "$SSHD_CONFIG"

# Разрешаем только конкретного пользователя
sed -i '/^AllowUsers/d' "$SSHD_CONFIG"
echo "AllowUsers sshuser" >> "$SSHD_CONFIG"

# Ограничиваем количество попыток входа
sed -i 's/^#MaxAuthTries.*/MaxAuthTries 2/' "$SSHD_CONFIG"

# Добавляем баннер
sed -i '/^#Banner none/a Banner /root/banner.txt' "$SSHD_CONFIG"

# Создаем баннер
echo "===> Создание баннера"
echo '$$$$$$$$$$$Authorized access only!$$$$$$$$$$$' > /root/banner.txt

# Перезапуск SSH
echo "===> Перезапуск SSH"
systemctl restart ssh
systemctl restart sshd

echo "===> Настройка SSH завершена."
