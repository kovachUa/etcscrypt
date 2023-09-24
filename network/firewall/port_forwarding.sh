#!/bin/bash

# Перевірка, чи передано необхідні аргументи
if [ $# -ne 1 ]; then
    echo "Використання: $0 <enable/disable>"
    exit 1
fi

# Зчитування аргументів
ENABLE_FORWARDING="$1"

# IP-адреса сервера і віртуальної машини
SERVER_IP="127.0.0.1"
VM_IP="192.168.122.241"
EXTERNAL_PORT="7999"
INTERNAL_PORT="22"

# Встановлення правила перенаправлення портів
if [ "$ENABLE_FORWARDING" == "enable" ]; then
    # Включення IP-перенаправлення на сервері
    echo 1 > /proc/sys/net/ipv4/ip_forward

    # Додавання правила iptables для перенаправлення порту
    iptables -t nat -A PREROUTING -p tcp --dport "$EXTERNAL_PORT" -j DNAT --to-destination "$VM_IP":"$INTERNAL_PORT"

    echo "Правило перенаправлення порту $EXTERNAL_PORT на віртуальну машину $VM_IP:$INTERNAL_PORT було ввімкнено."
elif [ "$ENABLE_FORWARDING" == "disable" ]; then
    # Видалення правила iptables
    iptables -t nat -D PREROUTING -p tcp --dport "$EXTERNAL_PORT" -j DNAT --to-destination "$VM_IP":"$INTERNAL_PORT"

    echo "Правило перенаправлення порту $EXTERNAL_PORT на віртуальну машину $VM_IP:$INTERNAL_PORT було вимкнено."
else
    echo "Неправильний аргумент. Використовуйте 'enable' або 'disable'."
    exit 1
fi

# Збереження правил iptables
service iptables save
