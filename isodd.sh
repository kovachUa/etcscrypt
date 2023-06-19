#!/bin/bash

# Введення посилання на дистрибутив від користувача
echo "Введіть посилання на дистрибутив:"
read distribution_link

# Отримання імені дистрибутиву з посилання
distribution_filename=$(basename "$distribution_link")

# Введення хеш-суми від користувача
echo "Введіть хеш-суму дистрибутива:"
read expected_hash

# Виведення доступних дисків
echo "Доступні диски:"
lsblk

# Введення шляху до USB-диска від користувача
echo "Введіть шлях до USB-диска (наприклад, /dev/sdb):"
read target_disk

# Завантаження дистрибутиву
echo "Завантаження дистрибутиву..."
wget "$distribution_link" -O "$distribution_filename"

# Перевірка хеш-суми
echo "Перевірка хеш-суми..."
calculated_hash=$(sha256sum "$distribution_filename" | awk '{ print $1 }')

if [ "$calculated_hash" != "$expected_hash" ]; then
  echo "Хеш-сума не співпадає. Відміна."
  exit 1
fi

# Форматування диску в ext4
echo "Форматування диску $target_disk в ext4..."
sudo mkfs.ext4 "$target_disk"

# Запис дистрибутиву на USB-диск
echo "Запис дистрибутиву на USB-диск $target_disk..."
sudo dd if="$distribution_filename" of="$target_disk" bs=4M status=progress conv=fsync

echo "Операція завершена."
