#!/bin/bash

# Сохранение списка установленных пакетов
# pacman -Q > installed_packages.txt

# Если вы хотите сохранить только имена пакетов без версий, используйте:
# pacman -Q | cut -d' ' -f1 | sort | uniq > installed_packages.txt

# Путь к файлу со списком старых пакетов
OLD_PACKAGES_FILE="installed_packages.txt"

# Проверяем, существует ли файл
if [ ! -f "$OLD_PACKAGES_FILE" ]; then
    echo "Ошибка: файл $OLD_PACKAGES_FILE не найден!"
    exit 1
fi

# Получаем список текущих установленных пакетов (только имена)
CURRENT_PACKAGES=$(pacman -Q | cut -d' ' -f1 | sort | uniq)

# Читаем список старых пакетов и сортируем
OLD_PACKAGES=$(cat "$OLD_PACKAGES_FILE" | cut -d' ' -f1 | sort | uniq)

# Находим недостающие пакеты (те, что есть в старом списке, но нет в текущем)
MISSING_PACKAGES=$(comm -23 <(echo "$OLD_PACKAGES") <(echo "$CURRENT_PACKAGES"))

# Проверяем, есть ли недостающие пакеты
if [ -z "$MISSING_PACKAGES" ]; then
    echo "Все пакеты из списка уже установлены."
    exit 0
fi

# Выводим недостающие пакеты
echo "Недостающие пакеты:"
echo "$MISSING_PACKAGES"

# Устанавливаем недостающие пакеты
read -p "Установить недостающие пакеты? (y/n): " CONFIRM
if [ "$CONFIRM" = "y" ]; then
    sudo pacman -S $MISSING_PACKAGES
else
    echo "Установка отменена."
fi
