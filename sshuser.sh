#!/bin/bash

set -e

USERNAME="sshuser"
USERID=1010
PASSWORD="P@ssw0rd"

echo "===> Создание пользователя $USERNAME с UID $USERID"

# Создание пользователя с заданным UID, без интерактивного ввода
sudo adduser --uid "$USERID" --disabled-password --gecos "" "$USERNAME"

# Установка пароля
echo "${USERNAME}:${PASSWORD}" | sudo chpasswd

echo "===> Установка sudo"
sudo apt update
sudo apt install -y sudo

echo "===> Назначение привилегий sudo без запроса пароля"

# Добавление пользователя в sudo-группу
sudo usermod -aG sudo "$USERNAME"

# Добавление строки в sudoers (через visudo для безопасности)
sudo bash -c "echo -e '\n$USERNAME ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers"

echo "===> Пользователь $USERNAME создан и добавлен в sudo с правами без пароля"
