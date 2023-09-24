#!/bin/bash

function configure_nfs() {
    # Додаємо правила до файлу /etc/exports для налаштування NFS
    echo "$1 *(rw,sync,no_subtree_check)" >> /etc/exports

    # Перезапускаємо службу NFS
    systemctl restart nfs-kernel-server
}

function configure_samba() {
    local share_name="$1"
    local share_path="$2"

    # Перевіряємо чи існує каталог для розділення через Samba
    if [ ! -d "$share_path" ]; then
        mkdir "$share_path"
    fi

    # Додаємо налаштування до smb.conf
    echo "[$share_name]" >> /etc/samba/smb.conf
    echo "    path = $share_path" >> /etc/samba/smb.conf
    echo "    read only = no" >> /etc/samba/smb.conf
    echo "    browseable = yes" >> /etc/samba/smb.conf

    # Перезапускаємо службу Samba
    systemctl restart smbd
}

function configure_iptables() {
    # Додатково налаштовуємо файервол iptables правила для дозволу на доступ до портів NFS та Samba
    iptables -A INPUT -p tcp --dport 111 -j ACCEPT
    iptables -A INPUT -p udp --dport 111 -j ACCEPT
    iptables -A INPUT -p tcp --dport 2049 -j ACCEPT
    iptables -A INPUT -p udp --dport 2049 -j ACCEPT
    iptables -A INPUT -p udp --dport 137 -j ACCEPT
    iptables -A INPUT -p udp --dport 138 -j ACCEPT
    iptables -A INPUT -p tcp --dport 139 -j ACCEPT
    iptables -A INPUT -p tcp --dport 445 -j ACCEPT

    # Зберігаємо файервол правила
    iptables-save > /etc/iptables/rules.v4
}

# Основний вибір:
while true; do
    echo "Оберіть дію:"
    echo "1. Первоначальна настройка NFS"
    echo "2. Первоначальна настройка Samba"
    echo "3. Налаштування iptables"
    echo "4. Додати новий каталог до NFS"
    echo "5. Додати новий каталог до Samba"
    echo "6. Вийти"

    read choice

    case $choice in
        1)
            # Додайте сюди налаштування для NFS за замовчуванням
            echo "Первоначальне налаштування NFS..."
            ;;
        2)
            # Додайте сюди налаштування для Samba за замовчуванням
            echo "Первоначальне налаштування Samba..."
            ;;
        3)
            configure_iptables
            echo "Nалаштування iptables додано."
            ;;
        4)
            echo "Введіть шлях до каталогу, який ви бажаєте розділити через NFS:"
            read nfs_path
            configure_nfs "$nfs_path"
            echo "Каталог додано до NFS."
            ;;
        5)
            echo "Введіть ім'я розділеного ресурсу для Samba:"
            read samba_name
            echo "Введіть шлях до каталогу, який ви бажаєте розділити через Samba:"
            read samba_path
            configure_samba "$samba_name" "$samba_path"
            echo "Каталог додано до Samba."
            ;;
        6)
            echo "Дякую за використання скрипта. Вихід."
            exit
            ;;
        *)
            echo "Недійсний вибір. Будь ласка, введіть 1, 2, 3, 4, 5 або 6."
            ;;
    esac
done

