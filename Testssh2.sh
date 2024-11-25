#!/bin/bash

# Установка sshpass, если он не установлен
if ! command -v sshpass &> /dev/null
then
    echo "sshpass не найден в системе. Установка..."
    apt-get update
    apt-get install -y sshpass
fi

# Переменные
SSH_ISP="10.10.10.1"
SSH_HQRTR="10.10.10.2"
SSH_BRRTR="10.10.10.6"
SSH_HQSRV="192.168.10.3"
SSH_BRSRV="192.168.30.3"
SSH_USER="user"
SSH_PASS="resu"
ROOT_PASS="toor"

#Переименование и создание пользователя Admin на CLI
hostnamectl hostname CLI
useradd Admin
echo "Admin:P@ssw0rd" | chpasswd

# Подключение по SSH к HQ-RTR и выполнение команд
sshpass -p "resu" ssh -o StrictHostKeyChecking=no "user@10.10.10.2" << EOF
# Переход в режим root
echo "toor" | su - -c "
hostnamectl set-hostname HQ-RTR
useradd Admin
echo "Admin:P@ssw0rd" | chpasswd
exit  # Выход из режима root
"
exit  # Выход из сеанса SSH
EOF

# Подключение по SSH к HQ-SRV и выполнение команд
sshpass -p "resu" ssh -o StrictHostKeyChecking=no "user@192.168.10.3" << EOF
# Переход в режим root
echo "toor" | su - -c "
hostnamectl set-hostname HQ-SRV
useradd Admin
echo "Admin:P@ssw0rd" | chpasswd
exit  # Выход из режима root
"
exit  # Выход из сеанса SSH
EOF
