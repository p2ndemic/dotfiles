#!/bin/bash

# mkdir -p ~/.local/bin/ && touch ~/.local/bin/7z-compress.sh

# Проверка зависимостей
# command -v 7z >/dev/null 2>&1 || { echo "Error: 7zip not installed"; exit 1; }
# command -v tar >/dev/null 2>&1 || { echo "Error: tar not installed"; exit 1; }
# command -v kdialog >/dev/null 2>&1 || { echo "Error: kdialog not installed"; exit 1; }

# Параметры:
# $1 — desktop entry action (pack7z, packZip и т.д.)
# $2... — выбранные файлы (%F)

current_dir="$PWD"
action="$1"
files=("${@:2}")  # Все файлы, кроме первого аргумента (типа архива)

# Определить имя архива
if [ ${#files[@]} -eq 1 ]; then
    # Один файл/папка: имя_файла.расширение
    base_name=$(basename "${files[0]}")
    archive_name="${base_name%%.*}"  # Убрать расширение
else
    # Несколько файлов: имя_текущей_папки
    archive_name=$(basename "$current_dir")
fi

# Создать архив
case "$action" in
    "pack7z")
        7z a -t7z "$current_dir/$archive_name.7z" "${files[@]}" ;;

    "pack7zMax")
        7z a -t7z -m0=lzma2 -mx=9 "$current_dir/$archive_name.7z" "${files[@]}" ;;

    "pack7zPass")
    password=$(kdialog --password "Enter archive password" --title "Password diaglog")
    if [ -n "$password" ]; then
        7z a -t7z -p"$password" "$current_dir/$archive_name.7z" "${files[@]}"
    else
        echo "Operation canceled"
        exit 1
    fi ;;
    
    "packTarGz")
        tar -czvf "$current_dir/$archive_name.tar.gz" -- "${files[@]}" ;;

    "packZip")
        7z a -tzip "$current_dir/$archive_name.zip" "${files[@]}" ;;
esac
