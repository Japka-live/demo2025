#!/bin/bash

# Установка sshpass, если он не установлен
if ! command -v sshpass &> /dev/null
then
    echo "sshpass не найден в системе. Установка..."
    apt-get update
    apt-get install -y sshpass
fi

# Переменные
SSH_HQ="192.168.10.1"
SSH_USER="user"
SSH_PASS="resu"
ROOT_PASS="toor"

# Подключение по SSH и выполнение команд
echo "$ROOT_PASS" | su - -c "

"
EOF
