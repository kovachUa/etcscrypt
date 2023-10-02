#!/bin/bash

# Задайте список пулів та файлових систем, для яких потрібно створювати снапшоти
pool_list=("zfs/pool")

# Кількість днів, для яких потрібно зберігати снапшоти
DAYS_TO_KEEP=3

# Створення снапшотів
for POOL_NAME in "${POOL_NAMES[@]}"; do
  # Створення снапшоту з поточною датою
  CURRENT_DATE=$(date +%d.%m.%Y)
  SNAPSHOT_NAME="$POOL_NAME@$CURRENT_DATE"
  zfs snapshot "$SNAPSHOT_NAME"
  echo "Створено снапшот: $SNAPSHOT_NAME"
done

# Видалення старших снапшотів
for POOL_NAME in "${POOL_NAMES[@]}"; do
  # Видалення снапшотів, які старші за DAYS_TO_KEEP днів
  zfs list -t snapshot -o name,creation -Hr "$POOL_NAME" | while read -r snapshot creation; do
    snapshot_date=$(date -d "$creation" +%s)
    cutoff_date=$(date -d "$DAYS_TO_KEEP days ago" +%s)
    if [ "$snapshot_date" -lt "$cutoff_date" ]; then
      zfs destroy "$snapshot"
      echo "Видалено старший снапшот: $snapshot"
    fi
  done
done

echo "Скрипт успішно виконано!"
