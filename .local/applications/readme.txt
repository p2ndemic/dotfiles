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
Icon=org.gnome.Nautilus или Icon=nautilus (короткое название)

Примеры:
system-file-manager
folder
folder-blue / folder-cyan / folder-magenta / folder-red — цветные папки (очень популярны в Papirus)
thunar
folder-documents
folder-home
applications-system
file-manager
folder-visiting

3.2 Либо можно указать путь к кастомной иконке:
Icon=/home/твой_логин/Pictures/icons/my-cool-filemanager.svg

4. Обновляем базу .desktop-файлов (локальные и системные)
sudo update-desktop-database /usr/share/applications && update-desktop-database ~/.local/share/applications
