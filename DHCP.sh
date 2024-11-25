#!/bin/bash

# Установка isc-dhcp-server
apt-get update
apt-get install -y isc-dhcp-server

# Редактирование файла /etc/default/isc-dhcp-server
sed -i 's/^INTERFACESv4=".*"/INTERFACESv4="ens37"/' /etc/default/isc-dhcp-server
sleep 2
# Редактирование файла /etc/dhcp/dhcpd.conf
sed -i '/option-domain-name-servers/a\\n\\nsubnet 192.168.10.0 netmask 255.255.255.248 {\\n  range 192.168.10.4 192.168.10.6;\\n  option routers 192.168.10.1;\\n}' /etc/dhcp/dhcpd.conf

# Перезапуск isc-dhcp-server
systemctl restart isc-dhcp-server
systemctl start isc-dhcp-server

echo "isc-dhcp-server установлен и настроен."
