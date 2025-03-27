#!/bin/bash

# Параметры:
# $1 — тип архива (pack7z, packZip и т.д.)
# $2... — выбранные файлы (%F)

current_dir="$PWD"
files=("${@:2}")  # Все файлы, кроме первого аргумента (типа архива)

# Определить имя архива
if [ ${#files[@]} -eq 1 ]; then
    # Один файл/папка: имя_файла.расширение
    base_name=$(basename "${files[0]}")
    archive_name="${base_name%.*.*}"  # Убрать расширение
else
    # Несколько файлов: имя_текущей_папки
    archive_name=$(basename "$current_dir")
fi

# Создать архив
case "$1" in
    "pack7z")
        7z a -t7z "$current_dir/$archive_name.7z" "${files[@]}" ;;
    "pack7zMax")
        7z a -t7z -m0=lzma2 -mx=9 "$current_dir/$archive_name.7z" "${files[@]}" ;;
    "pack7zPass")
        7z a -t7z -p"qweasd123" "$current_dir/$archive_name.7z" "${files[@]}" ;;
    "packTarGz")
        tar -czvf "$current_dir/$archive_name.tar.gz" -- "${files[@]}" ;;
    "packZip")
        7z a -tzip "$current_dir/$archive_name.zip" "${files[@]}" ;;
esac
