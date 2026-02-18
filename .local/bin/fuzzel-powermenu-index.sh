#!/bin/bash

# --- Конфигурация интерфейса ---
# ВНИМАНИЕ: Fuzzel может некорректно обрабатывать имена шрифтов с пробелами.
# В качестве обходного решения (workaround) указываем прямой путь к файлу шрифта.

# JetBrainsMono Nerd Font Propo - Основной шрифт с поддержкой пропорций Nerd Fonts || Hack - запасной
FONT_PRIMARY="/usr/share/fonts/TTF/JetBrainsMonoNerdFontPropo-Medium.ttf"
FONT_FALLBACK="Hack"
FONT="$FONT_PRIMARY:size=24,$FONT_FALLBACK:size=24"

#Указать вот так если шрифт не имеет пробелов в имени:
#FONT=Hack:size=24

# --- Позиционирование окна на экране ---
# Доступно: top-left, top, top-right, left, center, right, bottom-left, bottom, bottom-right
ANCHOR="center" # Значение по умолчанию

# --- Обработка аргументов ---
# Проходимся по всем переданным аргументам
while [[ $# -gt 0 ]]; do
    case $1 in
        -a=*|--anchor=*)
            ANCHOR="${1#*=}"   # Извлекаем значение после знака "="
            shift              # Переходим к следующему аргументу
            ;;

        -a|--anchor)
            # Проверяем, что следующий аргумент существует и не начинается с дефиса
            # (чтобы отличить значение от другого флага)
            if [[ -n "$2" && "$2" != -* ]]; then
                ANCHOR="$2"     # Берем следующий аргумент как значение
                shift 2         # Пропускаем флаг и само значение
            else
                # Если после флага нет значения или идёт другой флаг — ошибка
                echo "Error: $1 requires an argument" >&2
                exit 1
            fi
            ;;

        *)
            echo "Warning: unknown option $1 ignored" >&2
            echo "Usage: $0 [-a POSITION | --anchor POSITION]" >&2
            shift
            ;;
    esac
done

# --- Сборка параметров Fuzzel в единую переменную ---
# Порядок: режим dmenu, индекс, шрифт, позиция, скрыть ввод, авто-высота, ширина, отступы
FUZZEL_OPTS="--dmenu \
    --index \
    --font=$FONT \
    --anchor=$ANCHOR \
    --hide-prompt \
    --minimal-lines \
    --width=14 \
    --horizontal-pad=160 \
    --vertical-pad=20 \
    --line-height=34"

# --- Источник данных ---

# Функция выводит пункты меню. Порядок строк определяет их будущий индекс (0, 1, 2...)
get_power_options() {
    echo "   Lock"      # Index [0]
    echo "  󰗼 Logout"    # Index [1]
    echo "  󰖔 Suspend"   # Index [2]
    echo "  󰜉 Reboot"    # Index [3]
    echo "  󰐥 Shutdown"  # Index [4]
}

# --- Логика работы ---

# Запускаем меню и сохраняем индекс выбранной строки в переменную CHOICE
CHOICE=$(get_power_options | fuzzel $FUZZEL_OPTS)

# Обработка выбора
case "$CHOICE" in
    0) # Index [0]
        loginctl lock-session                         # Блокировка [0]
        ;;
    1) # Index [1] (Рекомендовано при работе с UWSM)
        loginctl terminate-session "$XDG_SESSION_ID"  # Выход [1]
        ;;
    2) # Index [2]
        systemctl suspend                             # Сон [2]
        ;;
    3) # Index [3]
        systemctl reboot                              # Перезагрузка [3]
        ;;
    4) # Index [4]
        systemctl poweroff                            # Выключение [4]
        ;;
    *)
        # Срабатывает при нажатии Esc или закрытии окна
        exit 0
        ;;
esac
