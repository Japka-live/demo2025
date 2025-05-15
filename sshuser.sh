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

echo "===> Правка файла /etc/sudoers"

# Временный файл
TEMP_SUDOERS="/tmp/sudoers.new"

# Создаем новый файл sudoers, добавляя строку вручную после строки "%sudo..."
inserted=0
while IFS= read -r line; do
    echo "$line" >> "$TEMP_SUDOERS"
    if [[ "$line" =~ ^%sudo[[:space:]]+ALL=\(ALL:ALL\)[[:space:]]+ALL$ ]] && [[ $inserted -eq 0 ]]; then
        echo "" >> "$TEMP_SUDOERS"
        echo "$USERNAME ALL=(ALL:ALL) NOPASSWD:ALL" >> "$TEMP_SUDOERS"
        inserted=1
    fi
done < /etc/sudoers

# Проверяем корректность
visudo -cf "$TEMP_SUDOERS"
if [[ $? -eq 0 ]]; then
    cp "$TEMP_SUDOERS" /etc/sudoers
    echo "===> Строка успешно добавлена в sudoers"
else
    echo "Ошибка в синтаксисе sudoers — изменения не применены"
    exit 1
fi

# Очистка
rm -f "$TEMP_SUDOERS"

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
