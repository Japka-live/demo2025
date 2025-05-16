#!/bin/bash

set -e

echo "===> Установка sshpass..."
apt update
apt install -y sshpass

echo "===> Переход к пользователю sshuser и генерация SSH-ключа..."
su - sshuser -c "
  yes '' | ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa
"

echo "===> Раздача SSH-ключей с использованием sshpass..."
# Передача ключа user@192.168.20.3
su - sshuser -c "
  sshpass -p 'resu' ssh-copy-id -o StrictHostKeyChecking=no user@192.168.20.3
"

# Передача ключа sshuser@192.168.10.3 через порт 2024
su - sshuser -c "
  sshpass -p 'P@ssw0rd' ssh-copy-id -o StrictHostKeyChecking=no -p 2024 sshuser@192.168.10.3
"

# Передача ключа net_admin@192.168.10.1
su - sshuser -c "
  sshpass -p 'P@$$word' ssh-copy-id -o StrictHostKeyChecking=no net_admin@192.168.10.1
"

# Передача ключа net_admin@192.168.30.1
su - sshuser -c "
  sshpass -p 'P@$$word' ssh-copy-id -o StrictHostKeyChecking=no net_admin@192.168.30.1
"

echo "===> Возвращение к root..."
# Никакие действия не нужны — мы и так под root.

echo "===> Установка Ansible..."
apt install -y ansible

echo "===> Создание инвентарного файла Ansible..."
mkdir -p /etc/ansible/
touch /etc/ansible/hosts

cat <<EOF > /etc/ansible/hosts
[group]
192.168.10.3 ansible_port=2024 ansible_user=sshuser
192.168.20.3 ansible_user=user
192.168.10.1 ansible_user=net_admin
192.168.30.1 ansible_user=net_admin
EOF

echo "===> Возврат к пользователю sshuser и проверка Ansible..."
su - sshuser -c "
  echo 'ВНИМАНИЕ ПРОВЕРКА ANSIBLE'
  sleep 2
  ansible all -m ping
"
