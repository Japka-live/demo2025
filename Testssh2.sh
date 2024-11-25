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
apt-get update && apt-get install -y isc-dhcp-server
sed -i 's/^INTERFACESv4=\"\"/INTERFACESv4=\"ens37\"/' /etc/default/isc-dhcp-server

# Редактирование файла /etc/dhcp/dhcpd.conf
sed -i '/option-domain-name-servers/a\\n\\nsubnet 192.168.10.0 netmask 255.255.255.248 {\\n  range 192.168.10.4 192.168.10.6;\\n  option routers 192.168.10.1;\\n}' /etc/dhcp/dhcpd.conf

# Перезапуск и включение isc-dhcp-server
systemctl restart isc-dhcp-server
systemctl start isc-dhcp-server
systemctl enable isc-dhcp-server
"
EOF
