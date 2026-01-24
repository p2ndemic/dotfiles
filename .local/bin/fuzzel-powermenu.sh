#!/bin/bash

# --- Конфигурация интерфейса ---

# Шрифт и размер
FONT="Hack:size=24"

# Расположение меню (center, top, bottom, left, right и др.)
ALIGN="center"

# Настройки Fuzzel (без флага --index)
FUZZEL_OPTS="--dmenu \
--font=$FONT \
--anchor=$ALIGN \
--hide-prompt \
--minimal-lines \
--width=14 \
--horizontal-pad=160 \
--vertical-pad=20"

# --- Определение пунктов меню ---

# Добавляем пробелы в начале для визуального отступа
LOCK="   Lock"
LOGOUT="  󰗼 Logout"
SUSPEND="  󰖔 Suspend"
REBOOT="  󰜉 Reboot"
SHUTDOWN="  󰐥 Shutdown"

# --- Запуск и получение выбора ---

# Объединяем переменные через символ переноса строки \n
MENU_LIST="$LOCK\n$LOGOUT\n$SUSPEND\n$REBOOT\n$SHUTDOWN"

# Вызываем Fuzzel и сохраняем текст выбранной строки
CHOICE=$(echo -e "$MENU_LIST" | fuzzel $FUZZEL_OPTS)

# --- Обработка выбора (Вариант 1: Вертикальный стиль) ---

case "$CHOICE" in
    "$LOCK")
        swaylock &
        ;;
    "$LOGOUT")
        loginctl terminate-user $USER
        ;;
    "$SUSPEND")
        systemctl suspend
        ;;
    "$REBOOT")
        systemctl reboot
        ;;
    "$SHUTDOWN")
        systemctl poweroff
        ;;
    *)
        # Выход без действий, если ничего не выбрано (Esc)
        exit 0
        ;;
esac
