 
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

# Читання URL-адресів з вхідного файлу та створення JSON-об'єкту
json_object="{"
while read -r url; do
  json_object+="\"url\": \"$url\","
done < "$input_file"
json_object="${json_object%,}" # Видалення останньої коми
json_object+="}"

# Встановлення вихідного JSON-файлу з такою ж назвою, як вхідний файл
output_file="${file_name}.json"

# Запис JSON-об'єкту у вихідний файл
echo "$json_object" > "$output_file"

echo "Успішно створено файл $output_file у форматі JSON."
