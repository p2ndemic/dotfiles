#!/bin/bash
# https://specifications.freedesktop.org/notification-spec/latest/
# mkdir -p ~/.local/bin/ && touch ~/.local/bin/7z-compress.sh
# Вариант с kdialog и notify-send [KDE native]

# Входные данные:
# $1 — desktop entry action (-pack7z, -packZip и т.д.)
# $2... — выбранные файлы (%F)

action="$1"
files=("${@:2}")
current_dir="$(pwd -P)" # Использовать физический путь к директории, игнорируя симлинки

# Функция обработки ошибок
handle_error() {
    local message="$1"  # Сообщение об ошибке
    notify-send --app-name="Dolphin" "❌ Error" "$message"
    exit 1
}

# Проверка зависимостей
command -v 7z >/dev/null 2>&1 || handle_error "7zip not installed"
command -v tar >/dev/null 2>&1 || handle_error "tar not installed"
command -v kdialog >/dev/null 2>&1 || handle_error "kdialog not installed"

# Проверка аргументов
if [ -z "$action" ] || [ ${#files[@]} -eq 0 ]; then
    handle_error "Usage: <-action> <file1> [file2 ...]"
fi

# Определить имя архива
if [ ${#files[@]} -eq 1 ]; then
    base_name="$(basename "${files[0]}")"
    # Для скрытых файлов/папок (начинающихся с точки) - сохранить полное имя
    if [[ "$base_name" = .* ]]; then
        archive_name="$base_name"
    else
        # Для обычных файлов - удалить все расширения
        archive_name="${base_name%%.*}"
    fi
else
    archive_name="$(basename "$current_dir")"
    # Вывод окна kdialog для ввода имени архива при выборе нескольких файлов/папок
    archive_name=$(kdialog --inputbox "Enter archive name" "$archive_name")
    [ -z "$archive_name" ] && handle_error "Archive name not provided"
fi

# Функция для получения расширения архива
get_archive_extension() {
    # FIX: Correct syntax for local variable assignment
    local current_action="$1"
    case "$current_action" in
        "-pack7z"|"-pack7zMax"|"-pack7zPass")
            echo ".7z"
            ;;
        "-packTarGz")
            echo ".tar.gz"
            ;;
        "-packZip")
            echo ".zip"
            ;;
        *)
            # Use the passed action in the error message
            handle_error "Unknown desktop action for extension: $current_action"
            ;;
    esac
}

# Получить расширение архива
extension="$(get_archive_extension "$action")"
archive_full_name="$current_dir/$archive_name$extension"

# Функция проверки существования архива
check_existing_archive() {
    if [ -f "$archive_full_name" ]; then
        kdialog --yesno "The file $archive_name$extension already exists. Overwrite?" || exit 1
    fi
}

# Проверка на существование архива перед созданием
check_existing_archive

# Создать архив
case "$action" in
    "-pack7z")
        7z a -t7z "$archive_full_name" "${files[@]}" -aoa || handle_error "Failed to create $extension archive"
        ;;
    "-pack7zMax")
        7z a -t7z -m0=lzma2 -mx=9 "$archive_full_name" "${files[@]}" -aoa || handle_error "Failed to create $extension archive"
        ;;
    "-pack7zPass")
        password="$(kdialog --password "Enter archive password" --title "Password dialog")"
        if [ -n "$password" ]; then
            7z a -y -t7z -p"$password" "$archive_full_name" "${files[@]}" -aoa || handle_error "Failed to create $extension archive"
        else
            notify-send --app-name="Dolphin" "❕ Info" "Operation canceled"
            exit 1
        fi
        ;;
    "-packTarGz")
        tar -czf "$archive_full_name" -- "${files[@]}" || handle_error "Failed to create $extension archive"
        ;;
    "-packZip")
        7z a -tzip "$archive_full_name" "${files[@]}" -aoa || handle_error "Failed to create $extension archive"
        ;;
    *)
        handle_error "Unknown action: $action"
        ;;
esac

# Уведомление
notify-send --app-name="Dolphin" \
--action="open=Open Location" \
"✅ Success" \
"Archive created successfully: <b><a href='file://$archive_full_name'>$archive_name$extension</a></b>"
# Обработка действия --action="open=Open Location"
xdg-open "$current_dir" &
