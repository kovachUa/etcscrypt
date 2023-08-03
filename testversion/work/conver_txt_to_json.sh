#!/bin/bash

# Запит шляху до вхідного файлу
read -p "Введіть шлях до вхідного файлу: " input_file

# Перевірка наявності вхідного файлу
if [ ! -f "$input_file" ]; then
  echo "Помилка: Вхідний файл $input_file не знайдено."
  exit 1
fi

# Отримання назви вхідного файлу без розширення
input_file_name=$(basename "$input_file")
file_name="${input_file_name%.*}"

# Читання URL-адресів з вхідного файлу та збереження їх у масиві
urls=()
while IFS= read -r url; do
  urls+=("$url")
done < "$input_file"

# Створення JSON-об'єкту з масиву URL-адрес
json_object="{\"urls\": ["
for ((i = 0; i < ${#urls[@]}; i++)); do
  json_object+="\"${urls[i]}\""
  if ((i < ${#urls[@]} - 1)); then
    json_object+=", "
  fi
done
json_object+="]}"

# Встановлення вихідного JSON-файлу з такою ж назвою, як вхідний файл
output_file="${file_name}.json"

# Запис JSON-об'єкту у вихідний файл
echo "$json_object" > "$output_file"

echo "Успішно створено файл $output_file у форматі JSON."
