#!/bin/bash

# Замініть "repositories.json" на ваш шлях до JSON-файлу
JSON_FILE="gentoo.json"

# Зчитати дані з JSON-файлу та клонувати репозиторії
cat "$JSON_FILE" | jq -r '.urls[]' | while read -r repo_url; do
    git clone "$repo_url"
done

