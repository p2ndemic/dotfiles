#!/bin/bash

# --- Конфигурация интерфейса ---
# ВНИМАНИЕ: Fuzzel может некорректно обрабатывать имена шрифтов с пробелами.
# В качестве обходного решения (workaround) указываем прямой путь к файлу шрифта.
#FONT_PRIMARY="/usr/share/fonts/Adwaita/AdwaitaMono-Regular.ttf"
#FONT_FALLBACK="Hack"
#FONT="$FONT_PRIMARY:size=24,$FONT_FALLBACK:size=24"

FONT=Hack:size=24

# --- Позиционирование окна на экране ---
# Доступно: top-left, top, top-right, left, center, right, bottom-left, bottom, bottom-right
ALIGN="center"

# --- Сборка параметров Fuzzel в единую переменную ---
# Порядок: режим dmenu, индекс, шрифт, позиция, скрыть ввод, авто-высота, ширина, отступы
FUZZEL_OPTS="--dmenu \
    --index \
    --font=$FONT \
    --anchor=$ALIGN \
    --hide-prompt \
    --minimal-lines \
    --width=14 \
    --horizontal-pad=160 \
    --vertical-pad=20"

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
        swaylock & exit 0                       # Блокировка [0]
        ;;
    1) # Index [1]
        loginctl terminate-user $USER & exit 0  # Выход [1]
        ;;
    2) # Index [2]
        systemctl suspend & exit 0              # Сон [2]
        ;;
    3) # Index [3]
        systemctl reboot                        # Перезагрузка [3]
        ;;
    4) # Index [4]
        systemctl poweroff                      # Выключение [4]
        ;;
    *)
        # Срабатывает при нажатии Esc или закрытии окна
        exit 0
        ;;
esac
