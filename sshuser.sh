#!/bin/bash

set -e

USERNAME="sshuser"
USERID=1010
PASSWORD="P@ssw0rd"

echo "===> Создание пользователя $USERNAME с UID $USERID"
adduser --uid "$USERID" --disabled-password --gecos "" "$USERNAME"

echo "$USERNAME:$PASSWORD" | chpasswd

echo "===> Установка пакета sudo"
apt update
apt install -y sudo

echo "===> Настройка прав sudo в файле /etc/sudoers"

# Вставка строки в sudoers-файл сразу под строкой %sudo ...
awk '
/^%sudo\s+ALL=\(ALL:ALL\)\s+ALL/ && !x { 
    print; 
    print ""; 
    print "sshuser ALL=(ALL:ALL) NOPASSWD:ALL"; 
    x=1; 
    next 
} 
{ print }' /etc/sudoers > /tmp/sudoers.new

# Проверка синтаксиса перед заменой
visudo -cf /tmp/sudoers.new

# Только если проверка прошла — заменить
if [ $? -eq 0 ]; then
    cp /tmp/sudoers.new /etc/sudoers
    echo "===> Права sudo успешно назначены для $USERNAME"
else
    echo "Ошибка в синтаксисе sudoers. Изменения не применены."
    exit 1
fi

# Очистка
rm /tmp/sudoers.new
