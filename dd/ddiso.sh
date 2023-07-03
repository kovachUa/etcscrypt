#!/bin/bash

# Отримуємо назву мітки диску
label=$(blkid -s LABEL -o value /dev/sr0)

# Визначаємо розмір блоку диску
block_size=$(blockdev --getbsz /dev/sr0)

# Ім'я образу
image_name="${label}.iso"

# Копіюємо диск з використанням dd
echo "Копіювання диску..."
dd if=/dev/sr0 of="${image_name}" bs="${block_size}"

# Обчислюємо хеш-суму образу
echo "Обчислення хеш-суми..."
hash_sum=$(sha256sum "${image_name}" | awk '{ print $1 }')

# Записуємо хеш-суму в файл
echo "${hash_sum}" > hash_sum.txt

echo "Операція завершена. Образ диску: ${image_name}, хеш-сума: ${hash_sum}"
