#!/bin/bash

# Введення посилання на дистрибутив від користувача
echo "Введіть посилання на дистрибутив:"
read distribution_link

# Отримання імені дистрибутиву з посилання
distribution_filename=$(basename "$distribution_link")

# Введення хеш-суми від користувача
echo "Введіть хеш-суму дистрибутива:"
read expected_hash

# Питання користувача щодо запису на диск
echo "Бажаєте записати дистрибутив на диск? (Так/Ні)"
read write_to_disk

# Виведення доступних дисків
echo "Доступні диски:"
lsblk

if [[ "$write_to_disk" == "Так" ]]; then
  # Введення шляху до USB-диска від користувача
  echo "Введіть шлях до USB-диска (наприклад, /dev/sdb):"
  read target_disk

  # Форматування диску в ext4
  echo "Форматування диску $target_disk в ext4..."
  sudo mkfs.ext4 "$target_disk"

  # Запис дистрибутиву на USB-диск
  echo "Запис дистрибутиву на USB-диск $target_disk..."
  sudo dd if="$distribution_filename" of="$target_disk" bs=4M status=progress conv=fsync

  echo "Запис на диск завершено."
else
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

  echo "Завантаження дистрибутиву завершено. Перевірка хеш-суми пройшла успішно."
fi
