#!/bin/bash
# https://specifications.freedesktop.org/notification-spec/latest/
# https://documentation.help/7-Zip/start.htm
# mkdir -p ~/.local/bin/ && touch ~/.local/bin/7z-compress.sh
# Полная версия скрипта архивации с управлением прерыванием и поддержкой горячик клавиш для завершения архивации
# Вариант с kdialog и notify-send [KDE native]

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
check_deps() {
    local CMD
    for CMD in 7z tar kdialog; do
        if ! command -v "$CMD" &>/dev/null; then
            handle_error "$CMD not installed"
        fi
    done
}
check_deps

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
    [ -n "$ARCHIVING_PID" ] && kill -9 "$ARCHIVING_PID" 2>/dev/null
}
trap pid_cleanup EXIT  # Регистрируем функцию очистки при выходе

# ---------------------------
# Обработчик сигнала отмены
# ---------------------------
handle_cancel() {
    if [[ -n "$ARCHIVING_PID" ]]; then
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
if [[ -z "$ACTION" ]] || [[ ${#FILES[@]} -eq 0 ]]; then
    handle_error "Invalid arguments. Usage: <-action> <file1> [[file2 ...]]"
fi

# ---------------------------
#  Фунция генерации имени архива
# ---------------------------
generate_archive_name() {
    local BASE_NAME
    local DIR_NAME
    local EXIT_CODE
    # ARCHIVE_NAME - Глобальная переменная внутри функции

    # Определить имя архива
    if [[ ${#FILES[@]} -eq 1 ]]; then
        BASE_NAME="$(basename "${FILES[0]}")"
        # Для скрытых файлов/папок (начинающихся с точки) - сохранить полное имя
        if [[ "$BASE_NAME" = .* ]]; then
            ARCHIVE_NAME="$BASE_NAME"
        else
            # Для обычных файлов - удалить все расширения
            ARCHIVE_NAME="${BASE_NAME%%.*}"
        fi
    else
        # Получаем имя директории/папки без пути
        DIR_NAME="$(basename "$CURRENT_DIR")"
        # Вывод окна kdialog для ввода имени архива при выборе нескольких файлов/папок
        ARCHIVE_NAME="$(kdialog --title "Archive Name" --inputbox "Enter archive name" "$DIR_NAME")"
        EXIT_CODE=$? # сразу присваиваем код возврата последней команды ($?) в локальную переменную EXIT_CODE и ссылаемся на нее для надежности
        # Если пользователь нажал Cancel
        if [[ "$EXIT_CODE" -eq 1 ]]; then
            dolphin_notify "❕ Info" "Operation canceled"
            exit 1
        fi
        # Если пользователь оставил поле пустым
        if [[ -z "$ARCHIVE_NAME" ]]; then
            dolphin_notify "❕ Info" "Archive name cannot be empty"
            exit 1
        fi
    fi
}
generate_archive_name # Вызываем функцию генерации имени архива с глобальной переменной $ARCHIVE_NAME

# ---------------------------
# Функция определения расширения архива
# ---------------------------
get_archive_extension() {
    local CURRENT_ACTION="$1"
    case "$CURRENT_ACTION" in
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
            handle_error "Unknown action: $CURRENT_ACTION"
            ;;
    esac
}

# Получить расширение и имя архива включая полный путь
EXTENSION="$(get_archive_extension "$ACTION")"
ARCHIVE_FULL_NAME="$CURRENT_DIR/$ARCHIVE_NAME$EXTENSION"

# ---------------------------
# Функция проверки существующего архива
# ---------------------------
check_existing_archive() {
    local EXIT_CODE
    if [[ -f "$ARCHIVE_FULL_NAME" ]]; then
        kdialog --title "Confirm Overwrite" --yesno "The file $ARCHIVE_NAME$EXTENSION already exists. Overwrite?"
        EXIT_CODE=$? # сразу присваиваем код возврата последней команды ($?) в локальную переменную EXIT_CODE и ссылаемся на нее для надежности
        if [[ "$EXIT_CODE" -eq 1 ]]; then
            # Нажато "No" — завершаем программу
            exit 1 # Тихо завершаем завершаем работу без уведомления чтобы не раздражать пользователя
        fi
        # Нажато "Yes" — продолжаем выполнение
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
        if [[ -n "$PASSWORD" ]]; then
        # [[ -n "$password" ]] проверяет, не пуста ли переменная $password
        # Если пользователь ввел пароль и нажал "OK", $password содержит значение == условие истинно
        # Если пользователь нажал "Cancel" или оставил поле пустым, $password будет пустой == условие ложно
        7z a -t7z -p"$PASSWORD" -mhe=on "$ARCHIVE_FULL_NAME" "${FILES[@]}" -aoa &
        ARCHIVING_PID=$!
        wait $ARCHIVING_PID || handle_error "Failed to create password protected $EXTENSION archive"
        else
            dolphin_notify "❕ Info" "Password entry canceled"
            exit 1
        fi
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
dolphin_notify "✅ Success" "Archive Created: <a href='file://$ARCHIVE_FULL_NAME'>$ARCHIVE_NAME$EXTENSION</a>"
# Открываем директорию с архивом
xdg-open "$CURRENT_DIR" &  
exit 0
