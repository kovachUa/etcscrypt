#!/bin/bash

# Задайте список пулів та файлових систем, для яких потрібно створювати снапшоти
pool_list=("zfs/pool")

# Задайте кількість днів, старше яких снапшоти будуть видалятися
retention_days=7

# Отримати поточну дату
current_date=$(date +%d.%m.%Y)

# Пройти по кожному пулу та файловій системі та створити снапшоти
for pool_name in "${pool_list[@]}"; do
  # Отримати список файлових систем для цього пулу
  filesystems=($(zfs list -H -o name -r $pool_name))

  for filesystem in "${filesystems[@]}"; do
    # Створити снапшот для кожної файлової системи
    snapshot_name="$filesystem@$current_date"
    zfs snapshot $snapshot_name

    # Видалити старі снапшоти, старші за retention_days
    if [ $retention_days -gt 0 ]; then
      oldest_date=$(date -d "-$retention_days days" +%d.%m.%Y)
      zfs list -t snapshot -o name -H -r $filesystem | while read -r snapshot; do
        snapshot_date=$(echo $snapshot | awk -F "@" '{print $2}')
        if [[ $snapshot_date < $oldest_date ]]; then
          zfs destroy $snapshot
        fi
      done
    fi
  done
done

echo "Скрипт успішно виконано!"
