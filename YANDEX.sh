#!/bin/bash

echo "===> Установка Yandex Browser..."

# Устанавливаем пакет
dpkg -i /home/user/Загрузки/Yandex.deb

# Устанавливаем недостающие зависимости
apt install -f -y

# Повторно устанавливаем .deb-файл на случай ошибок
dpkg -i /home/user/Загрузки/Yandex.deb

echo "===> Установка завершена."
