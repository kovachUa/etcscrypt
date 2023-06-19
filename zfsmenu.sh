#!/bin/bash

# Масив зі списком пулів
pools=("pool1" "pool2" "pool3")

# Функція для вибору пулу
select_pool() {
    echo "Виберіть пул:"
    select pool in "${pools[@]}"; do
        if [[ -n $pool ]]; then
            echo "Вибраний пул: $pool"
            break
        else
            echo "Невірний вибір. Спробуйте ще раз."
        fi
    done
}

# Функція для створення знімку датасету ZFS
create_zfs_snapshot() {
    select_pool
    echo "Введіть ім'я датасету, для якого потрібно створити знімок:"
    read dataset_name
    echo "Введіть ім'я знімку:"
    read snapshot_name
    zfs snapshot $pool/$dataset_name@$snapshot_name
}

# Функція для відновлення датасету ZFS з знімку
rollback_zfs_snapshot() {
    select_pool
    echo "Введіть ім'я датасету, який потрібно відновити:"
    read dataset_name
    echo "Введіть ім'я знімку, з якого потрібно відновити:"
    read snapshot_name
    zfs rollback $pool/$dataset_name@$snapshot_name
}

# Функція для виведення списку доступних команд
print_commands() {
    echo "=============================="
    echo "Меню команд ZFS/Zpool:"
    echo "1. Створити новий пул ZFS"
    echo "2. Видалити пул ZFS"
    echo "3. Вивести список пулів ZFS"
    echo "4. Вивести стан пулу ZFS"
    echo "5. Створити новий датасет ZFS"
    echo "6. Видалити датасет ZFS"
    echo "7. Вивести список датасетів ZFS"
    echo "8. Створити знімок датасету ZFS"
    echo "9. Відновити датасет ZFS з знімку"
    echo "10. Відправити знімок датасету ZFS"
    echo "11. Вийти"
    echo "=============================="
    echo "Виберіть опцію:"
}

# Головне меню
while true; do
    print_commands
    read option

    case $option in
        1)
            echo "Опція 1: Створити новий пул ZFS"
            # Додайте код для створення пулу ZFS
            ;;
        2)
            echo "Опція 2: Видалити пул ZFS"
            # Додайте код для видалення пулу ZFS
            ;;
        3)
            echo "Опція 3: Вивести список пулів ZFS"
            # Додайте код для виведення списку пулів ZFS
            ;;
        4)
            echo "Опція 4: Вивести стан пулу ZFS"
            # Додайте код для виведення стану пулу ZFS
            ;;
        5)
            echo "Опція 5: Створити новий датасет ZFS"
            # Додайте код для створення нового датасету ZFS
            ;;
        6)
            echo "Опція 6: Видалити датасет ZFS"
            # Додайте код для видалення датасету ZFS
            ;;
        7)
            echo "Опція 7: Вивести список датасетів ZFS"
            # Додайте код для виведення списку датасетів ZFS
            ;;
        8)
            create_zfs_snapshot
            ;;
        9)
            rollback_zfs_snapshot
            ;;
        10)
            echo "Опція 10: Відправити знімок датасету ZFS"
            # Додайте код для відправки знімку датасету ZFS
            ;;
        11)
            break
            ;;
        *)
            echo "Невірна опція. Виберіть ще раз."
            ;;
    esac
done

