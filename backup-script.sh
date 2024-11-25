#!/bin/bash #эта строчка для открытия BASH
sleep 1
echo "LETS ARCHIVE" # это фраза для того чтобы мы могли понять что скрипт работает
sleep # задержка чтобы мы успели среагировать
rm -r /root/BACKUP # удаляем папку BACKUP
mkdir /root/BACKUP # создаем папку
cd /root/BACKUP # перемещаемся в папку
tar -cvf archive.tar /etc #создаем архив с просмотром копирования папки
sleep 2
tar -tf archive.tar #смотрим содержимое архива
