#!/bin/bash

# Задайте список пулів, для яких потрібно створювати снапшоти
pool_list=("zfs/pool")

# Задайте кількість днів, старше яких снапшоти будуть видалятися
retention_days=7

# Отримати поточну дату
current_date=$(date +%d.%m.%Y)

# Пройти по кожному пулу та створити снапшоти
for pool_name in "${pool_list[@]}"; do
  # Створити снапшоти для файлової системи ZFS
  snapshot_name="$pool_name@$current_date"
  zfs snapshot $snapshot_name

  # Видалити старі снапшоти, старші за retention_days
  if [ $retention_days -gt 0 ]; then
    zfs list -t snapshot -o name -H -r $pool_name | while read -r snapshot; do
      snapshot_date=$(echo $snapshot | awk -F "@" '{print $2}')
      snapshot_date_seconds=$(date --date="$snapshot_date" +%s 2>/dev/null)
      current_date_seconds=$(date --date="$current_date" +%s 2>/dev/null)
      retention_seconds=$((retention_days * 24 * 60 * 60))
      if [ "$snapshot_date_seconds" != "" ] && [ "$current_date_seconds" != "" ] && [ $((current_date_seconds - snapshot_date_seconds)) -gt $retention_seconds ]; then
        zfs destroy $snapshot
      fi
    done
  fi
done

echo "Скрипт успішно виконано!"
