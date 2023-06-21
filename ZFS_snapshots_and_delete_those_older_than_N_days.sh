#!/bin/bash

# Змінні
pool_names=("data/foto" "data/doc" "data/backup" "data/etc")  # Замініть на відповідні імена ваших пулів ZFS
snapshot_prefix="snapshot"  # Префікс для імені снапшотів
days_to_keep=3  # Кількість днів, протягом яких тримати снапшоти

# Створення снапшота
create_snapshot() {
    local pool_name="$1"
    local snapshot_name="${snapshot_prefix}_$(date +%Y-%m-%d)"
    zfs snapshot "${pool_name}@${snapshot_name}"
    echo "Створено снапшот: ${pool_name}@${snapshot_name}"
}

# Видалення снапшота
delete_snapshot() {
    local pool_name="$1"
    local snapshot="$2"
    zfs destroy "${pool_name}@${snapshot}"
    echo "Видалено снапшот: ${pool_name}@${snapshot}"
}

# Отримання списку снапшотів
get_snapshots() {
    local pool_name="$1"
    zfs list -H -t snapshot -o name,creation -S creation -r "${pool_name}" | awk -F '\t' '{print $1}'
}

# Основний код

for pool_name in "${pool_names[@]}"; do
    # Створення нового снапшота
    create_snapshot "${pool_name}"

    # Отримання списку снапшотів
    snapshots=($(get_snapshots "${pool_name}"))

    # Видалення снапшотів, які старше заданої кількості днів
    for snapshot in "${snapshots[@]}"; do
        creation_date=$(zfs list -H -o creation -t snapshot "${snapshot}")
        days_ago=$(( ( $(date +%s) - $(date -d "${creation_date}" +%s) ) / 86400 ))

        if [[ ${days_ago} -gt ${days_to_keep} ]]; then
            delete_snapshot "${pool_name}" "${snapshot}"
        fi
    done
done
