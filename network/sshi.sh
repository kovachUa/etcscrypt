#!/bin/bash

while true; do
    clear
    echo "Меню:"
    echo "1. Авторизація за ключем SSH"
    echo "2. Налаштування сервера"
    echo "3. Вихід"

    read -p "Виберіть пункт меню: " choice

    case $choice in
        1)
            read -p "Введіть ім'я користувача: " username
            read -p "Введіть IP-адресу сервера: " server_ip

            ssh-copy-id $username@$server_ip
            echo "Авторизація за ключем налаштована."
            ;;
        2)
            # Налаштування сервера
            echo "Налаштування сервера:"
            
            # Заборона авторизації за паролем
            read -p "Заборонити авторизацію за паролем? (так/ні): " password_auth
            if [ "$password_auth" == "так" ]; then
                sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
                echo "Авторизація за паролем заборонена."
            fi

            # Заборона авторизації root
            read -p "Заборонити авторизацію root? (так/ні): " root_auth
            if [ "$root_auth" == "так" ]; then
                sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
                echo "Авторизація root заборонена."
            fi

            # Увімкнення авторизації за ключем
            read -p "Увімкнути авторизацію за ключем? (так/ні): " key_auth
            if [ "$key_auth" == "так" ]; then
                sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
                echo "Авторизація за ключем увімкнена."
            fi

            # Перезапуск SSH сервера для застосування змін
            systemctl restart ssh
            ;;
        3)
            echo "Вихід"
            exit
            ;;
        *)
            echo "Будь ласка, виберіть правильний пункт меню."
            ;;
    esac

    read -p "Натисніть Enter, щоб продовжити..."
done
