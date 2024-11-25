#!/bin/bash

# Установка isc-dhcp-server
apt-get update
apt-get install -y isc-dhcp-server

# Редактирование файла /etc/default/isc-dhcp-server
sed -i 's/^INTERFACESv4=".*"/INTERFACESv4="ens37"/' /etc/default/isc-dhcp-server

# Редактирование файла /etc/dhcp/dhcpd.conf
echo -e "\nsubnet 192.168.10.0 netmask 255.255.255.248 {" >> /etc/dhcp/dhcpd.conf
echo -e "  range 192.168.10.4 192.168.10.6;" >> /etc/dhcp/dhcpd.conf
echo -e "  option routers 192.168.10.1;" >> /etc/dhcp/dhcpd.conf
echo -e "}" >> /etc/dhcp/dhcpd.conf

# Перезапуск isc-dhcp-server
systemctl restart isc-dhcp-server
systemctl start isc-dhcp-server

echo "isc-dhcp-server установлен и настроен."
