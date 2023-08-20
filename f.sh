#!/bin/bash

source_dir="//"
destination_dir="//"

date_ranges=(

    # Додайте інші пари дат тут
)

if [ ! -d "$destination_dir" ]; then
    mkdir -p "$destination_dir"
fi

for range in "${date_ranges[@]}"; do
    start_date=$(echo "$range" | cut -d ' ' -f 1)
    end_date=$(echo "$range" | cut -d ' ' -f 2)

    destination_subdir="${destination_dir}/${start_date}-${end_date}"
    mkdir -p "$destination_subdir"

    start_timestamp=$(date -d "$start_date" +%s)
    end_timestamp=$(date -d "$end_date" +%s)

    for filepath in "$source_dir"/*; do
        if [ -f "$filepath" ]; then
            file_timestamp=$(stat -c %Y "$filepath")

            if [ "$file_timestamp" -ge "$start_timestamp" ] && [ "$file_timestamp" -le "$end_timestamp" ]; then
                filename=$(basename "$filepath")
                mv "$filepath" "$destination_subdir/$filename"
                echo "Moved '$filename' to '$destination_subdir'"
            fi
        fi
    done
done
