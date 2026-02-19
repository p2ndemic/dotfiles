# 1. Скопируй системный .desktop-файл к себе в домашнюю папку:
# mkdir -p ~/.local/share/applications
# cp /usr/share/applications/pcmanfm-qt.desktop ~/.local/share/applications/

# 2. Открой скопированный файл:
# nano ~/.local/share/applications/pcmanfm-qt.desktop
# или любой другой редактор: vim, geany, mousepad и т.д.

# 3. Найди строку, которая начинается с Icon=
# Обычно там что-то вроде:
# Icon=pcmanfm-qt

3.1 Замени название иконки на более подходящее:
Icon=org.gnome.Nautilus или thunar
