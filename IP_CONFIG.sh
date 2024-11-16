#!/bin/bash

# Файл конфигурации
CONFIG_FILE="/etc/network/interfaces"

# Добавляем настройки в файл
echo "Обновляем файл $CONFIG_FILE..."

cat <<EOL >> "$CONFIG_FILE"

auto ens36
auto ens37
auto ens38
iface ens33 inet static
    address 192.168.10.1/29
    gateway 192.168.1.1/29
EOL

echo "Настройки добавлены."

# Перезапуск сети
echo "Перезапускаем службу сети..."
service networking restart

if [ $? -eq 0 ]; then
  echo "Сеть успешно перезапущена."
else
  echo "Ошибка при перезапуске сети. Проверьте настройки."
fi
