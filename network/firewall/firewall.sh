#!/bin/bash

# Розділити аргументи на окремі порти та дії (додати або видалити)
IFS=',' read -ra args <<< "$1"

# Пройтися по всіх аргументах
for arg in "${args[@]}"; do
  # Виділити порт та дію
  port="${arg%,*}"
  action="${arg: -1}"

  # Виділити тип порту (I, N, T)
  type="${arg%,*}"
  type="${type#*,}"

  # Перевірити, чи додавати або видаляти порт
  if [ "$action" == "+" ]; then
    if [ "$type" == "I" ]; then
      iptables -A INPUT -p tcp --dport "$port" -j ACCEPT
    elif [ "$type" == "N" ]; then
      iptables -A OUTPUT -p tcp --dport "$port" -j ACCEPT
    elif [ "$type" == "T" ]; then
      iptables -A OUTPUT -p tcp --dport "$port" -j ACCEPT
      iptables -A INPUT -p tcp --sport "$port" -j ACCEPT
    fi
  elif [ "$action" == "-" ]; then
    if [ "$type" == "I" ]; then
      iptables -D INPUT -p tcp --dport "$port" -j ACCEPT
    elif [ "$type" == "N" ]; then
      iptables -D OUTPUT -p tcp --dport "$port" -j ACCEPT
    elif [ "$type" == "T" ]; then
      iptables -D OUTPUT -p tcp --dport "$port" -j ACCEPT
      iptables -D INPUT -p tcp --sport "$port" -j ACCEPT
    fi
  fi
done

# Зберегти налаштування брандмауера
service iptables save

echo "Порти налаштовані успішно."
 
