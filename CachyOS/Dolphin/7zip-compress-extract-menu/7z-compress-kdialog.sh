#!/bin/bash
# https://specifications.freedesktop.org/notification-spec/latest/
# https://documentation.help/7-Zip/start.htm
# mkdir -p ~/.local/bin/ && touch ~/.local/bin/7z-compress.sh
# Полная версия скрипта архивации с управлением прерыванием и поддержкой горячик клавиш для завершения архивации
# Вариант с kdialog и notify-send [KDE native]
set -euo pipefail

# ---------------------------
# Кастомные уведомления
# ---------------------------
dolphin_notify() {
    local SUMMARY="$1"
    local BODY="$2"
    notify-send \
        --app-name="🐬 Dolphin" \
        --expire-time=2000 \
        --urgency=normal \
        "$SUMMARY" \
        "$BODY"
}

# ---------------------------
# Функция обработки ошибок
# ---------------------------
handle_error() {
    local MESSAGE="$1"  # Сообщение об ошибке
    dolphin_notify "❌ Error" "$MESSAGE"
    exit 1
}

# ---------------------------
# Проверка зависимостей
# ---------------------------
command -v 7z >/dev/null 2>&1 || handle_error "7zip not installed"
command -v tar >/dev/null 2>&1 || handle_error "tar not installed"
command -v kdialog >/dev/null 2>&1 || handle_error "kdialog not installed"

# ---------------------------
# Конфигурационные параметры
# ---------------------------
ARCHIVING_PID=""
PID_FILE="/tmp/7z-compress.pid"            # Файл для хранения PID процесса
CANCEL_SIGNAL="SIGUSR1"                    # Сигнал для прерывания архивации

# ---------------------------
# Регистрация PID и очистка
# ---------------------------
echo $$ > "$PID_FILE"  # Сохраняем PID текущего процесса

pid_cleanup() {
    rm -f "$PID_FILE"  # Удаляем PID-файл при завершении
    # Принудительно завершаем процесс архивации, если он активен
    if [ -n "$ARCHIVING_PID" ]; then
        kill -TERM "$ARCHIVING_PID" 2>/dev/null # Отправляем сигнал SIGTERM процессу архивации для корректного завершения
        sleep 1 # Даем 1 секунду на завершение. Если процесс все еще активен, используем kill -9
        kill -0 "$ARCHIVING_PID" 2>/dev/null && kill -9 "$ARCHIVING_PID" 2>/dev/null
    fi
}
trap pid_cleanup EXIT  # Регистрируем функцию очистки при выходе

# ---------------------------
# Обработчик сигнала отмены
# ---------------------------
handle_cancel() {
    if [ -n "$ARCHIVING_PID" ]; then
        kill -TERM "$ARCHIVING_PID" 2>/dev/null  # Отправляем SIGTERM процессу архивации
        dolphin_notify "🚫 Archiving Canceled" "Process interrupted by user"
        exit 2
    fi
}
trap handle_cancel $CANCEL_SIGNAL  # Регистрируем обработчик сигнала

# ---------------------------
# Входные данные
# ---------------------------
ACTION="$1"                      # Действие из .desktop файла (-pack7z, -packZip и т.д.)
FILES=("${@:2}")                 # Список всех выбранных файлов (%F)
CURRENT_DIR="$(pwd -P)"          # Использовать полный физический путь к директории, игнорируя симлинки

# ---------------------------
# Проверка аргументов
# ---------------------------
if [ -z "$ACTION" ] || [ ${#FILES[@]} -eq 0 ]; then
    handle_error "Invalid arguments. Usage: <-action> <file1> [file2 ...]"
fi

# ---------------------------
# Функция генерации имени архива
# ---------------------------
generate_archive_name() {
    if [ ${#FILES[@]} -eq 1 ]; then
        # Обработка одиночного файла
        local BASE_NAME="$(basename "${FILES[0]}")"
        
        # Для скрытых файлов сохраняем полное имя
        if [[ "$BASE_NAME" = .* ]]; then
            echo "$BASE_NAME"
        else
            # Удаляем только последнее расширение
            echo "${BASE_NAME%.*}"
        fi
    else
        # Ввод имени архива для нескольких файлов
        local DIR_NAME="$(basename "$CURRENT_DIR")"
        local CUSTOM_NAME=$(kdialog --title "Archive Name" --inputbox "Enter archive name" "$DIR_NAME")
        [ -z "$CUSTOM_NAME" ] && dolphin_notify "Archive name not provided"
        echo "$CUSTOM_NAME"
    fi
}
# Генерация имени архива
ARCHIVE_NAME=$(generate_archive_name)

# ---------------------------
# Функция определения расширения архива
# ---------------------------
get_archive_extension() {
    local CURRENT_ACTION="$1"
    case "$CURRENT_ACTION" in
        "-pack7z"|"-pack7zMax"|"-pack7zPass") echo ".7z" ;;
        "-packTarGz") echo ".tar.gz" ;;
        "-packZip") echo ".zip" ;;
        *) handle_error "Unknown action: $CURRENT_ACTION" ;;
    esac
}

# Получить расширение и имя архива включая полный путь
EXTENSION="$(get_archive_extension "$ACTION")"
ARCHIVE_FULL_NAME="$CURRENT_DIR/$ARCHIVE_NAME$EXTENSION"

# ---------------------------
# Функция проверки существующего архива
# ---------------------------
check_existing_archive() {
    if [ -f "$ARCHIVE_FULL_NAME" ]; then
        kdialog --title "Overwrite Warning" --yesno "The file $ARCHIVE_NAME$EXTENSION already exists. Overwrite?"
        [ $? -ne 0 ] && exit 1
    fi
}
# Проверка существования архива перед запуском процесса архивации
check_existing_archive

# ---------------------------
# Процесс архивации с отслеживанием PID
# ---------------------------
case "$ACTION" in
    "-pack7z")
        7z a -t7z "$ARCHIVE_FULL_NAME" "${FILES[@]}" -aoa &
        ARCHIVING_PID=$!
        wait $ARCHIVING_PID || handle_error "Failed to create $EXTENSION archive"
        ;;

    "-pack7zMax")
        7z a -t7z -m0=lzma2 -mx=9 "$ARCHIVE_FULL_NAME" "${FILES[@]}" -aoa &
        ARCHIVING_PID=$!
        wait $ARCHIVING_PID || handle_error "Failed to create $EXTENSION archive"
        ;;

    "-pack7zPass")
        PASSWORD=$(kdialog --title "Password protection" --password "Enter archive password:")
        # Проверяем код возврата kdialog (0 - OK, 1 - Cancel/пусто)
        if [ $? -ne 0 ] || [ -z "$PASSWORD" ]; then
             dolphin_notify "❕ Info" "Password entry canceled. Archive not created."
             exit 5 # Выход с кодом 5 (отмена ввода)
        fi
        7z a -t7z -p"$PASSWORD" -mhe=on "$ARCHIVE_FULL_NAME" "${FILES[@]}" -aoa &
        ARCHIVING_PID=$!
        wait $ARCHIVING_PID || handle_error "Failed to create password protected $EXTENSION archive"
        ;;

    "-packTarGz")
        tar -czf "$ARCHIVE_FULL_NAME" -- "${FILES[@]}" &
        ARCHIVING_PID=$!
        wait $ARCHIVING_PID || handle_error "Failed to create $EXTENSION archive"
        ;;

    "-packZip")
        7z a -tzip "$ARCHIVE_FULL_NAME" "${FILES[@]}" -aoa &
        ARCHIVING_PID=$!
        wait $ARCHIVING_PID || handle_error "Failed to create $EXTENSION archive"
        ;;

    *)
        handle_error "Unknown action"
        ;;
esac

# ---------------------------
# Отправка финального уведомления
# ---------------------------
dolphin_notify "✅ Success" "Archive Created: <a href='file://$ARCHIVE_FULL_NAME'>${ARCHIVE_NAME}${EXTENSION}</a>"
# Открываем директорию с архивом
xdg-open "$CURRENT_DIR" &  
exit 0
