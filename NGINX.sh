#!/bin/bash

echo "===> Установка nginx..."
#apt update
apt install nginx -y

echo "===> Создание конфига по умолчанию..."
touch /etc/nginx/sites-available/default

echo "===> Настройка прокси-сервера..."
cat <<EOF > /etc/nginx/sites-available/default
server {
    listen 80;

    server_name moodle.au-team.irpo;

    location / {
        proxy_pass http://192.168.10.3:80;
    }
}

server {
    listen 80;

    server_name wiki.au-team.irpo;

    location / {
        proxy_pass http://192.168.10.3:8080;
    }
}
EOF

echo "===> Перезапуск nginx..."
systemctl restart nginx
sleep 2

echo "===> Проверка конфигурации nginx:"
nginx -t
