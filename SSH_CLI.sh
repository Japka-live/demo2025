#!/bin/bash

# Установка sshpass, если он не установлен
if ! command -v sshpass &> /dev/null
then
    echo "sshpass не найден в системе. Установка..."
    apt-get update
    apt-get install -y sshpass
fi


#Переименование и создание пользователя Admin на CLI
hostnamectl hostname CLI
useradd Admin
echo "Admin:P@ssw0rd" | chpasswd

# Подключение по SSH к ISP и установка iperf
sshpass -p "resu" ssh -o StrictHostKeyChecking=no "user@10.10.10.1" << EOF
# Переход в режим root
echo "toor" | su - -c "
apt install iperf3 -y
exit  # Выход из режима root
"
exit  # Выход из сеанса SSH
EOF

# Подключение по SSH к HQ-RTR и выполнение команд
sshpass -p "resu" ssh -o StrictHostKeyChecking=no "user@10.10.10.2" << EOF
# Переход в режим root
echo "toor" | su - -c "
hostnamectl set-hostname HQ-RTR
mkdir /root/BACKUP
useradd Admin
echo "Admin:P@ssw0rd" | chpasswd
useradd Network_admin
echo "Network_admin:P@ssw0rd" | chpasswd
apt install iperf3 -y
sh /root/demo2024/DHCP.sh
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

# Подключение по SSH к BR-RTR и выполнение команд
sshpass -p "resu" ssh -o StrictHostKeyChecking=no "user@10.10.10.6" << EOF
# Переход в режим root
echo "toor" | su - -c "
hostnamectl set-hostname BR-RTR
mkdir /root/BACKUP
useradd Branch_admin
echo "Branch_admin:P@ssw0rd" | chpasswd
useradd Network_admin
echo "Network_admin:P@ssw0rd" | chpasswd
exit  # Выход из режима root
"
exit  # Выход из сеанса SSH
EOF

# Подключение по SSH к BR-SRV и выполнение команд
sshpass -p "resu" ssh -o StrictHostKeyChecking=no "user@192.168.30.3" << EOF
# Переход в режим root
echo "toor" | su - -c "
hostnamectl set-hostname BR-SRV
useradd Branch_admin
echo "Branch_admin:P@ssw0rd" | chpasswd
useradd Network_admin
echo "Network_admin:P@ssw0rd" | chpasswd
exit  # Выход из режима root
"
exit  # Выход из сеанса SSH
EOF
