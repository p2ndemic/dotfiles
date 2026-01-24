#!/bin/bash

# --- Конфигурация интерфейса ---

# Название и размер шрифта (убедитесь, что пакет ttf-hack установлен)
FONT="Hack:size=24"

# Позиционирование окна на экране
# Доступно: top-left, top, top-right, left, center, right, bottom-left, bottom, bottom-right
ALIGN="center"

# Сборка параметров Fuzzel в единую переменную
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
    echo -e " Lock"      # Index 0
    echo -e "󰗼 Logout"    # Index 1
    echo -e "󰖔 Suspend"   # Index 2
    echo -e "󰜉 Reboot"    # Index 3
    echo -e "󰐥 Shutdown"  # Index 4
}

# --- Логика работы ---

# Запускаем меню и сохраняем индекс выбранной строки в переменную CHOICE
CHOICE=$(get_power_options | fuzzel $FUZZEL_OPTS)

# Обработка выбора (Вариант 1: Вертикальный стиль)
case "$CHOICE" in
    0)
        swaylock &
        ;;
    1)
        loginctl terminate-user $USER
        ;;
    2)
        systemctl suspend
        ;;
    3)
        systemctl reboot
        ;;
    4)
        systemctl poweroff
        ;;
    *)
        # Срабатывает при нажатии Esc или закрытии окна
        exit 0
        ;;
esac
