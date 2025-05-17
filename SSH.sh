#!/bin/bash

set -e

echo "===> Установка OpenSSH"
#apt update
apt install ssh -y

SSHD_CONFIG="/etc/ssh/sshd_config"

echo "===> Настройка sshd_config"

# Снимаем комментарий и меняем порт
sed -i 's/^#Port .*/Port 2024/' "$SSHD_CONFIG"

# Разрешаем только конкретного пользователя
sed -i '/^AllowUsers/d' "$SSHD_CONFIG"
"AllowUsers sshuser" | sudo tee -a "$SSHD_CONFIG" > /dev/null

# Ограничиваем количество попыток входа
sed -i 's/^#MaxAuthTries.*/MaxAuthTries 2/' "$SSHD_CONFIG"

# Добавляем баннер
sed -i '/^#Banner none/a Banner /root/banner.txt' "$SSHD_CONFIG"

# Создаем баннер
echo "===> Создание баннера"
touch /root/banner.txt
echo "\$\$\$\$\$\$\$\$\$\$\$\$Authorized access only!\$\$\$\$\$\$\$\$\$\$\$\$" | sudo tee /root/banner.txt > /dev/null

# Перезапуск SSH
echo "===> Перезапуск SSH"
systemctl restart ssh
systemctl restart sshd

echo "===> Настройка SSH завершена."
