#!/bin/bash

# Проверка наличия необходимых утилит
command -v tar >/dev/null 2>&1 || { echo "Error: tar not installed"; exit 1; }
command -v 7z >/dev/null 2>&1 || { echo "Error: 7zip not installed"; exit 1; }
command -v kdialog >/dev/null 2>&1 || { echo "Error: kdialog not installed"; exit 1; }

# Функция для получения базового имени файла
get_basename() {
    local filename="$1"
    # Удаляем два последних расширения
    echo "${filename%.*.*}"
}

# Функция извлечения
extract_archive() {
    local archive="$1"
    local output_dir="$2"

    case "$archive" in
        *.tar|*.tar.br|*.tar.bz2|*.tbz|*.tbz2|*.tar.gz|*.tgz|*.tar.lz|*.tar.lz4|*.tar.lzma|*.tar.lzo|*.tar.lrz|*.tar.xz|*.txz|*.tar.zst|*.tzst)
            tar -xf "$archive" -C "$output_dir"
            ;;
        *)
            7z x "$archive" -o"$output_dir"
            ;;
    esac
}

# Основная логика
if [ $# -ne 2 ]; then
    echo "Usage: $0 <operation: 1=here|2=subdir|3=choose_dir> <archive>"
    exit 1
fi

operation="$1"
archive="$2"
base_name=$(get_basename "$(basename "$archive")")

case $operation in
    1)
        # Извлечь здесь
        extract_archive "$archive" "./"
        ;;
    2)
        # Извлечь в папку с именем архива
        mkdir -p "$base_name"
        extract_archive "$archive" "$base_name"
        ;;
    3)
        # Извлечь в выбранную папку
        target_dir=$(kdialog --getexistingdirectory "$HOME" --title "Select Extraction Directory")
        if [ -n "$target_dir" ]; then
            extract_archive "$archive" "$target_dir"
        else
            echo "Extraction canceled"
            exit 1
        fi
        ;;
    *)
        echo "Invalid operation. Use 1, 2 or 3"
        exit 1
        ;;
esac

echo "Extraction complete!"
