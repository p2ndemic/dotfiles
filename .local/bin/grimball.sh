#!/bin/bash

# grimsnap.sh – универсальный скрипт для скриншотов (grim + slurp + swappy)
# Зависимости: grim, slurp, wl-clipboard (wl-copy), swappy (опционально для аннотаций)

set -euo pipefail

# Директория для сохранения по умолчанию (используем XDG_PICTURES_DIR или ~/Pictures)
PICTURES_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}"
FILENAME="ps_$(date +%Y%m%d%H%M%S).png"
DEFAULT_SAVE_PATH="$PICTURES_DIR/$FILENAME"

# Временный файл для аннотаций
TEMP_FILE="/tmp/screenshot_$FILENAME"

# Справка
usage() {
    cat <<EOF
Использование: $0 [OPTIONS]

Опции:
  -f, --full       Захват всего экрана
  -a, --area       Захват выделенной области
  -c, --copy       Копировать в буфер обмена (по умолчанию, если не указано -o)
  -o, --save       Сохранить в файл (в PICTURES_DIR с датой)
  -p, --path PATH  Сохранить по указанному пути (вместо стандартного)
  -n, --annotate   Открыть в swappy для аннотаций после захвата
  -h, --help       Показать эту справку

Примеры:
  $0 -f               # весь экран в буфер обмена
  $0 -a -o            # область в файл
  $0 -a -n -o         # область с аннотациями (после редактирования сохранить)
EOF
    exit 0
}

# Парсинг аргументов
MODE=""
COPY=true
SAVE=false
ANNOTATE=false
OUTPUT_PATH=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--full)
            MODE="full"
            shift
            ;;
        -a|--area)
            MODE="area"
            shift
            ;;
        -c|--copy)
            COPY=true
            SAVE=false
            shift
            ;;
        -o|--save)
            SAVE=true
            COPY=false
            shift
            ;;
        -p|--path)
            OUTPUT_PATH="$2"
            shift 2
            ;;
        -n|--annotate)
            ANNOTATE=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Неизвестная опция: $1"
            usage
            ;;
    esac
done

# Проверка обязательных опций
if [[ -z "$MODE" ]]; then
    echo "Ошибка: не указан режим захвата (--full или --area)"
    usage
fi

# Проверка наличия необходимых программ
for cmd in grim slurp wl-copy; do
    if ! command -v $cmd &> /dev/null; then
        echo "Ошибка: $cmd не установлен."
        exit 1
    fi
done

if [[ "$ANNOTATE" == true ]] && ! command -v swappy &> /dev/null; then
    echo "Ошибка: swappy не установлен. Установите его для использования аннотаций."
    exit 1
fi

# Определение пути сохранения (если нужно)
if [[ "$SAVE" == true ]]; then
    if [[ -n "$OUTPUT_PATH" ]]; then
        FINAL_PATH="$OUTPUT_PATH"
    else
        FINAL_PATH="$DEFAULT_SAVE_PATH"
    fi
fi

# Функция захвата (grim + возможно slurp)
take_screenshot() {
    local geom=""
    if [[ "$MODE" == "area" ]]; then
        geom=$(slurp)
        if [[ -z "$geom" ]]; then
            echo "Область не выбрана, выход."
            exit 1
        fi
        grim -g "$geom" "$@"
    else
        grim "$@"
    fi
}

# Основная логика
if [[ "$ANNOTATE" == true ]]; then
    # Сначала делаем скриншот во временный файл
    take_screenshot "$TEMP_FILE"

    # Открываем редактор swappy
    swappy -f "$TEMP_FILE"

    # После закрытия swappy обрабатываем результат
    if [[ "$SAVE" == true ]]; then
        mv "$TEMP_FILE" "$FINAL_PATH"
        echo "Скриншот с аннотациями сохранён: $FINAL_PATH"
    elif [[ "$COPY" == true ]]; then
        wl-copy < "$TEMP_FILE"
        rm "$TEMP_FILE"
        echo "Скриншот с аннотациями скопирован в буфер обмена"
    else
        # Если не указано ни --save, ни --copy – просто удаляем временный файл
        rm "$TEMP_FILE"
    fi
else
    # Без аннотаций
    if [[ "$SAVE" == true ]]; then
        take_screenshot "$FINAL_PATH"
        echo "Скриншот сохранён: $FINAL_PATH"
    else
        # По умолчанию копируем в буфер
        take_screenshot - | wl-copy
        echo "Скриншот скопирован в буфер обмена"
    fi
fi
