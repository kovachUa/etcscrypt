#!/bin/bash

# Задайте список пулів, для яких потрібно створити снапшоти
pool_list=( "zfs/pool" )

# Задайте кількість днів для зберігання снапшотів
retention_days=7

# Задайте змінну для включення або вимкнення віддаленого бекапу
remote_backup_enabled=false # true або false

# Задайте SSH-параметри для віддаленого сервера
remote_server="адреса_сервера"
remote_user="ім'я_користувача"
remote_path="шлях_до_бекапу"

# Отримати поточну дату
current_date=$(date +%d.%m.%Y)

# Пройти по кожному пулу та створити снапшоти
for pool_name in "${pool_list[@]}"; do
  # Створити снапшоти для файлової системи ZFS
  snapshot_name="$pool_name@$current_date"
  zfs snapshot $snapshot_name

  # Видалити старі снапшоти, старші за retention_days
  if [ $retention_days -gt 0 ]; then
    oldest_date=$(date -d "-$retention_days days" +%d.%m.%Y)
    zfs list -t snapshot -o name -H -r $pool_name | while read -r snapshot; do
      snapshot_date=$(echo $snapshot | awk -F "@" '{print $2}')
      if [[ $snapshot_date < $oldest_date ]]; then
        zfs destroy $snapshot
      fi
    done
  fi

  # Виконати віддалений бекап, якщо він включений
  if [ $remote_backup_enabled == true ]; then
    # Створити потік даних з снапшоту та відправити на віддалений сервер
    zfs send $snapshot_name | ssh $remote_user@$remote_server "cat > $remote_path/$snapshot_name.zfs"

    echo "Виконується віддалений бекап для пулу $pool_name..."
  fi
done

echo "Скрипт успішно виконано!"
