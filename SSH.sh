#!/bin/bash

set -e

echo "===> Установка OpenSSH"
sudo apt update
sudo apt install -y openssh-server

SSHD_CONFIG="/etc/ssh/sshd_config"

echo "===> Настройка sshd_config"

# Снимаем комментарий и меняем порт
sudo sed -i 's/^#Port .*/Port 2024/' "$SSHD_CONFIG"

# Разрешаем только конкретного пользователя
sudo sed -i '/^AllowUsers/d' "$SSHD_CONFIG"
echo "AllowUsers sshuser" | sudo tee -a "$SSHD_CONFIG" > /dev/null

# Ограничиваем количество попыток входа
sudo sed -i 's/^#MaxAuthTries.*/MaxAuthTries 2/' "$SSHD_CONFIG"

# Добавляем баннер
sudo sed -i '/^#Banner none/a Banner /root/banner.txt' "$SSHD_CONFIG"

# Создаем баннер
echo "===> Создание баннера"
sudo touch /root/banner.txt
echo "\$\$\$\$\$\$\$\$\$\$\$\$Authorized access only!\$\$\$\$\$\$\$\$\$\$\$\$" | sudo tee /root/banner.txt > /dev/null

# Перезапуск SSH
echo "===> Перезапуск SSH"
sudo systemctl restart ssh
sudo systemctl restart sshd

echo "===> Настройка SSH завершена."
