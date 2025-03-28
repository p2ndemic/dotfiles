#!/bin/bash

# Проверка зависимостей
command -v 7z >/dev/null 2>&1 || { echo "Error: 7zip not installed"; exit 1; }
command -v tar >/dev/null 2>&1 || { echo "Error: tar not installed"; exit 1; }
command -v kdialog >/dev/null 2>&1 || { echo "Error: kdialog not installed"; exit 1; }

current_dir="$PWD"
files=("${@:2}")  # Все аргументы после первого (выбранные файлы)

# Функция для получения базового имени
get_basename() {
    local filename="$1"
    echo "${filename%.*.*}"
}

# Определение имени архива
if [ ${#files[@]} -eq 1 ]; then
    base_name=$(basename "${files[0]}")
    archive_name=$(get_basename "$base_name")
else
    archive_name=$(basename "$current_dir")
fi

# Обработка операций
case "$1" in
    "pack7z")
        7z a -t7z "$current_dir/$archive_name.7z" "${files[@]}" ;;

    "pack7zMax")
        7z a -t7z -m0=lzma2 -mx=9 "$current_dir/$archive_name.7z" "${files[@]}" ;;

    "pack7zPass")
        password=$(kdialog --password "Enter archive password" --title "Password dialog" )
        if [ -n "$password" ]; then
            7z a -t7z -p"$password" "$current_dir/$archive_name.7z" "${files[@]}"
        else
            echo "Password entry canceled"
            exit 1
        fi ;;

    "packTarGz")
        tar -czvf "$current_dir/$archive_name.tar.gz" -- "${files[@]}" ;;

    "packZip")
        7z a -tzip "$current_dir/$archive_name.zip" "${files[@]}" ;;

    *)
        echo "Invalid operation. Available: pack7z, pack7zMax, pack7zPass, packTarGz, packZip"
        exit 1 ;;
esac

echo "Archive created: $current_dir/$archive_name.${1#pack}"
