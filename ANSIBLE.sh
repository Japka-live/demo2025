#!/bin/bash

# Установка необходимых пакетов
apt update && apt install -y sshpass ansible

# Переменные
SSHUSER="sshuser"
SSHUSER_PASS="P@ssw0rd"
ROOT_PASS="toor"

# Переключение на пользователя sshuser
su - $SSHUSER <<EOF

# Генерация SSH-ключей без фразы
yes "" | ssh-keygen -t rsa

# Передача ключей на целевые машины
sshpass -p "$SSHUSER_PASS" ssh-copy-id -o StrictHostKeyChecking=no user@192.168.20.3
sshpass -p "$SSHUSER_PASS" ssh-copy-id -o StrictHostKeyChecking=no -p 2024 sshuser@192.168.10.3
sshpass -p "$SSHUSER_PASS" ssh-copy-id -o StrictHostKeyChecking=no net_admin@192.168.10.1
sshpass -p "$SSHUSER_PASS" ssh-copy-id -o StrictHostKeyChecking=no net_admin@192.168.30.1

EOF

# Настройка Ansible под root
echo "$ROOT_PASS" | su - root <<EOF

# Создание структуры Ansible
mkdir -p /etc/ansible/
touch /etc/ansible/hosts

# Запись инвентарного файла
cat > /etc/ansible/hosts <<EOL
[group]
192.168.10.3 ansible_port=2024 ansible_user=sshuser
192.168.20.3 ansible_user=user
192.168.10.1 ansible_user=net_admin
192.168.30.1 ansible_user=net_admin
EOL

EOF

# Проверка связи от имени sshuser
su - $SSHUSER <<EOF
echo "ВНИМАНИЕ ПРОВЕРКА ANSIBLE"
sleep 2
ansible all -m ping
EOF
