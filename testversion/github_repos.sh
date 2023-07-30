#!/bin/bash

repository_url="$1"
url_type=""
output_file=""

if [[ "$repository_url" == *"github.com/orgs/"* ]]; then
  # Посилання на організацію
  url_type="orgs"
  output_file="$(basename "$repository_url").txt"
elif [[ "$repository_url" == *"github.com/users/"* ]]; then
  # Посилання на користувача
  url_type="users"
  output_file="$(basename "$repository_url").txt"
else
  echo "Invalid GitHub repository URL."
  exit 1
fi

# Виконуємо запит до GitHub API та зберігаємо URL-адреси "clone_url" у файлі
curl -s "https://api.github.com/$url_type/$(basename "$repository_url")/repos" | jq -r '.[].clone_url' > "$output_file"
echo "Repo URLs saved to $output_file"
