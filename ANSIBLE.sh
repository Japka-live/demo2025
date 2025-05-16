#!/bin/bash

# Переменные
SSHUSER="sshuser"
SSHUSER_PASS="P@ssw0rd"
ROOT_PASS="toor"

# Переключение на пользователя sshuser
su - $SSHUSER <<EOF

# Генерация SSH-ключей без фразы (нажимаем Enter 3 раза)
yes "" | ssh-keygen -t rsa

# Передача ключей
sshpass -p "$SSHUSER_PASS" ssh-copy-id -o StrictHostKeyChecking=no user@192.168.20.3
sshpass -p "$SSHUSER_PASS" ssh-copy-id -o StrictHostKeyChecking=no -p 2024 sshuser@192.168.10.3
sshpass -p "$SSHUSER_PASS" ssh-copy-id -o StrictHostKeyChecking=no net_admin@192.168.10.1
sshpass -p "$SSHUSER_PASS" ssh-copy-id -o StrictHostKeyChecking=no net_admin@192.168.30.1

EOF

# Возвращаемся в root (если нужно снова явно)
echo "$ROOT_PASS" | su - root <<EOF

# Установка Ansible
apt install ansible -y

# Создание структуры
mkdir -p /etc/ansible/
touch /etc/ansible/hosts

# Настройка инвентарного файла
cat > /etc/ansible/hosts <<EOL
[group]
192.168.10.3 ansible_port=2024 ansible_user=sshuser
192.168.20.3 ansible_user=user
192.168.10.1 ansible_user=net_admin
192.168.30.1 ansible_user=net_admin
EOL

EOF

# Проверка
su - $SSHUSER <<EOF
echo "ВНИМАНИЕ ПРОВЕРКА ANSIBLE"
sleep 2
ansible all -m ping
EOF
