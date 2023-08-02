#!/bin/bash

# Функція для клонування або оновлення гіт-репозиторію
clone_or_update_repository() {
  repo_url=$1
  repo_name=$2
  if [ -d "$repo_name" ]; then
    # Репозиторій вже існує, оновлюємо його
    echo "Оновлення репозиторію: $repo_name"
    cd "$repo_name" || return
    git pull
    cd ..
  else
    # Репозиторій не існує, клонуємо його
    echo "Клонування репозиторію: $repo_name"
    git clone "$repo_url" "$repo_name"
  fi
}

# Отримуємо список JSON-файлів зі списками репозиторіїв
repo_files=$(ls *.json)

# Максимальна кількість паралельних процесів
max_processes=5
current_processes=0

# Ітеруємось по кожному JSON-файлу
for file in $repo_files; do
  # Отримуємо назву репозиторію з імені файлу
  repo_name=$(basename "$file" .json)

  # Зчитуємо вміст JSON-файлу
  repositories=$(cat "$file")

  # Парсимо список репозиторіїв та ітеруємось по кожному об'єкту
  for row in $(echo "${repositories}" | jq -c '.[]'); do
    # Отримуємо URL репозиторію з JSON
    repo_url=$(echo "${row}" | jq -r '.url')

    # Викликаємо функцію для клонування або оновлення репозиторію
    clone_or_update_repository "$repo_url" "$repo_name" &

    # Збільшуємо лічильник паралельних процесів
    ((current_processes++))

    # Перевіряємо, чи досягнуто максимальну кількість паралельних процесів
    if [ "$current_processes" -ge "$max_processes" ]; then
      # Очікуємо завершення всіх паралельних процесів
      wait

      # Скидаємо лічильник паралельних процесів
      current_processes=0
    fi
  done
done

# Очікуємо завершення
