#!/bin/sh
#не забудьте установить ssh на все машины
set -e

# --- Настройки пользователей и паролей ---
SSHUSER="sshuser"
SSHUSER_PASS="P@ssw0rd"
ROOT_PASS="toor"

echo "===> Установка sshpass и ansible..."
apt update
apt install -y sshpass ansible

echo "===> Создание ключа от имени $SSHUSER..."

# Создаем временную папку для su-перехода
su - "$SSHUSER" -c "
  if [ ! -f ~/.ssh/id_rsa ]; then
    echo '===> Генерация SSH ключа...'
    ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa
  else
    echo '===> SSH ключ уже существует, пропускаем генерацию.'
  fi
"

# Список получателей ключей
declare -A HOSTS
HOSTS["user@192.168.20.3"]="user"
HOSTS["sshuser@192.168.10.3 -p2024"]="sshuser"
HOSTS["net_admin@192.168.10.1"]="net_admin"
HOSTS["net_admin@192.168.30.1"]="net_admin"

echo "===> Передача SSH ключей..."

for host in "${!HOSTS[@]}"; do
  sshpass -p "$SSHUSER_PASS" ssh-copy-id -o StrictHostKeyChecking=no -i /home/$SSHUSER/.ssh/id_rsa.pub $host
done

echo "===> Настройка Ansible..."

mkdir -p /etc/ansible
cat <<EOF > /etc/ansible/hosts
[group]
192.168.10.3 ansible_port=2024 ansible_user=sshuser
192.168.20.3 ansible_user=user
192.168.10.1 ansible_user=net_admin
192.168.30.1 ansible_user=net_admin
EOF

chown -R $SSHUSER:$SSHUSER /etc/ansible

echo "===> Завершаем настройку: проверка подключения Ansible от имени sshuser..."

su - "$SSHUSER" -c "
  echo 'ВНИМАНИЕ: ПРОВЕРКА ANSIBLE'
  sleep 2
  ansible all -m ping
"
