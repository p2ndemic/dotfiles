#!/bin/bash
# https://specifications.freedesktop.org/notification-spec/latest/
# mkdir -p ~/.local/bin/ && touch ~/.local/bin/7z-compress.sh
# Полная версия скрипта архивации с управлением прерыванием и поддержкой горячик клавиш для завершения архивации
# Вариант с kdialog и notify-send [KDE native]

# ---------------------------
# Входные данные
# ---------------------------
action="$1"                      # Действие из .desktop файла (-pack7z, -packZip и т.д.)
files=("${@:2}")                 # Список всех выбранных файлов (%F)
current_dir="$(pwd -P)"          # Использовать полный физический путь к директории, игнорируя симлинки

# ---------------------------
# Функция обработки ошибок
# ---------------------------
handle_error() {
    local message="$1"  # Сообщение об ошибке
    dolphin_notify "❌ Error" "$message"
    exit 1
}

# ---------------------------
# Проверка зависимостей
# ---------------------------
command -v 7z >/dev/null 2>&1 || handle_error "7zip not installed"
command -v tar >/dev/null 2>&1 || handle_error "tar not installed"
command -v kdialog >/dev/null 2>&1 || handle_error "kdialog not installed"

# ---------------------------
# Проверка аргументов
# ---------------------------
if [ -z "$action" ] || [ ${#files[@]} -eq 0 ]; then
    handle_error "Invalid arguments. Usage: <-action> <file1> [file2 ...]"
fi

# ---------------------------
# Кастомные уведомления
# ---------------------------
dolphin_notify() {
    local summary="$1"
    local body="$2"
    notify-send \
        --app-name="🐬 Dolphin" \
        --expire-time=1000 \
        --urgency=normal \
        "$summary" \
        "$body"
}

# ---------------------------
# Конфигурационные параметры
# ---------------------------
PID_FILE="/tmp/7z-compress.pid"            # Файл для хранения PID процесса
CANCEL_SIGNAL="SIGUSR1"                    # Сигнал для прерывания архивации
archive_created=0                          # Флаг успешного завершения (0 - нет, 1 - да)

# ---------------------------
# Инициализация и очистка
# ---------------------------
echo $$ > "$PID_FILE"  # Сохраняем PID текущего процесса

cleanup() {
    rm -f "$PID_FILE"  # Удаляем PID-файл при завершении
    
    # Принудительно завершаем процесс архивации, если он активен
    [ -n "$archiving_pid" ] && kill -9 "$archiving_pid" 2>/dev/null
    
    # Удаляем частичный архив при неудачном завершении
    if [ "$archive_created" -ne 1 ] && [ -f "$archive_full_name" ]; then
        rm -f "$archive_full_name"
        dolphin_notify "❕Temporary Files Removed" "Incomplete archive deleted"
    fi
}
trap cleanup EXIT  # Регистрируем функцию очистки при выходе

# ---------------------------
# Обработчик прерывания
# ---------------------------
handle_cancel() {
    if [ -n "$archiving_pid" ]; then
        kill -TERM "$archiving_pid" 2>/dev/null  # Отправляем SIGTERM процессу архивации
        dolphin_notify "🚫 Archiving Canceled" "Process interrupted by user"
        exit 2
    fi
}
trap handle_cancel $CANCEL_SIGNAL  # Регистрируем обработчик сигнала

# ---------------------------
# Функция генерации имени архива
# ---------------------------
generate_archive_name() {
    if [ ${#files[@]} -eq 1 ]; then
        # Обработка одиночного файла
        local base_name="$(basename "${files[0]}")"
        
        # Для скрытых файлов сохраняем полное имя
        if [[ "$base_name" = .* ]]; then
            echo "$base_name"
        else
            # Удаляем все расширения для обычных файлов
            echo "${base_name%%.*}"
        fi
    else
        # Вывод окна kdialog для ввода имени архива при выборе нескольких файлов/папок
        local dir_name="$(basename "$current_dir")"
        local custom_name=$(kdialog --title "Archive Name" --inputbox "Enter archive name" "$dir_name")
        [ -z "$custom_name" ] && handle_error "Archive name not provided"
        echo "$custom_name"
    fi
}
archive_name=$(generate_archive_name)

# ---------------------------
# Определение расширения архива
# ---------------------------
get_archive_extension() {
    local current_action="$1"
    case "$current_action" in
        "-pack7z"|"-pack7zMax"|"-pack7zPass") echo ".7z" ;;
        "-packTarGz") echo ".tar.gz" ;;
        "-packZip") echo ".zip" ;;
        *) handle_error "Unknown action: $current_action" ;;
    esac
}

# Получить расширение и имя архива включая полный путь
extension="$(get_archive_extension "$action")"
archive_full_name="$current_dir/$archive_name$extension"

# ---------------------------
# Проверка существующего архива
# ---------------------------
check_existing_archive() {
    if [ -f "$archive_full_name" ]; then
        kdialog --title "Overwrite Warning" \
                --yesno "The file $archive_name$extension already exists. Overwrite?"
        || exit 1
    fi
}
check_existing_archive

# ---------------------------
# Процесс архивации
# ---------------------------
case "$action" in
    "-pack7z")
        7z a -t7z "$archive_full_name" "${files[@]}" -aoa &
        archiving_pid=$!
        wait $archiving_pid || handle_error "Failed to create $extension archive"
        ;;

    "-pack7zMax")
        7z a -t7z -m0=lzma2 -mx=9 "$archive_full_name" "${files[@]}" -aoa &
        archiving_pid=$!
        wait $archiving_pid || handle_error "Failed to create $extension archive"
        ;;

    "-pack7zPass")
        password=$(kdialog --title "Password Required" --password "Enter archive password")
        [ -z "$password" ] && handle_error "❕ Info" "Operation canceled"
        7z a -t7z -p"$password" "$archive_full_name" "${files[@]}" -aoa &
        archiving_pid=$!
        wait $archiving_pid || handle_error "Password protected archive failed"
        ;;

    "-packTarGz")
        tar -czf "$archive_full_name" -- "${files[@]}" &
        archiving_pid=$!
        wait $archiving_pid || handle_error "Failed to create $extension archive"
        ;;

    "-packZip")
        7z a -tzip "$archive_full_name" "${files[@]}" -aoa &
        archiving_pid=$!
        wait $archiving_pid || handle_error "Failed to create $extension archive"
        ;;

    *)
        handle_error "Unknown action: $action"
        ;;
esac

# Сохраняем PID процесса архивации
archiving_pid=$!
wait $archiving_pid || handle_error "Archiving process failed"

# ---------------------------
# Финальное уведомление
# ---------------------------
dolphin_notify --action="open=Open Location" "✅ Archive Created" "Successfully created: <b><a href='file://$archive_full_name'>${archive_name}${extension}</a></b>"

archive_created=1  # Помечаем успешное завершение
xdg-open "$current_dir" &  # Открываем директорию с архивом
