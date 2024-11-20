#!/bin/bash

# Установка sshpass, если он не установлен
if ! command -v sshpass &> /dev/null; then
    echo "sshpass не установлен. Устанавливаем..."
    sudo apt-get update && sudo apt-get install -y sshpass
fi

# Переменные
CLI_IP="192.168.20.3"
ISP_IP="192.168.20.1"
USER="user"
USER_PASSWORD="resu"
ROOT_PASSWORD="toor"

# Подключение по SSH и выполнение команд
sshpass -p "$USER_PASSWORD" ssh -o StrictHostKeyChecking=no "$USER@$ISP_IP" << EOF
    # Перекключение на пользователя root и создание файлов
    echo "$ROOT_PASSWORD" | su - -c "touch /root/example.txt"
    echo "$ROOT_PASSWORD" | su - -c "touch /root/example1.txt"
    exit  # Явный выход из SSH-сессии
EOF

echo "Файлы /root/example.txt и /root/example1.txt созданы на машине ISP."
