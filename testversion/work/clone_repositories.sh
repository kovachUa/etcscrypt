#!/bin/bash

# Визначаємо URL GitHub API з переданим параметром
API_URL="$1"

# Визначаємо ім'я для папки
name="$(echo "$API_URL" | awk -F / '{print $(NF-1)}')"

# Створюємо папку для збереження репозиторіїв | Створює в поточному каталозі, ви можете коригувати шлях при необхідності
mkdir -p "reposgit"

# Масив для збереження репозиторіїв
repositories=()

# Функція для збирання даних про репозиторії
function get_repositories() {
    local page=1

    while true; do
        # Запит до GitHub API для отримання репозиторіїв
        response=$(curl -s -H "User-Agent: Your-User-Agent" "$API_URL?page=$page")

        # Збираємо посилання на репозиторії в масив
        while IFS= read -r repo_url; do
            repositories+=("$repo_url")
        done < <(echo "$response" | jq -r '.[].html_url')

        # Перевіряємо чи є наступна сторінка пагінації
        if [[ $(echo "$response" | jq '. | length') -eq 0 ]]; then
            break
        fi

        ((page++))
    done

    # Створюємо JSON-файл для репозиторію з масивом "urls"
    echo "{\"urls\":[$(printf "\"%s\"," "${repositories[@]}" | sed 's/,$//')]}" > "reposgit/$name.json"
}

echo "Обробка: $API_URL"
get_repositories
