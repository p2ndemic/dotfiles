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

5. Где можно посмотреть иконки:
  5.1 Базовая/стандартная тема (fallback для всего): /usr/share/icons/hicolor/
  Здесь находятся иконки в папках по размерам: 16x16, 24x24, 32x32, 48x48, 64x64, 128x128, scalable и т.д., подкаталог apps/,     places/, actions/, devices/ и т.п.)

Тема Adwaita (стандарт GNOME, часто используется как fallback):
/usr/share/icons/Adwaita/

Тема Papirus (самая популярная цветная тема):
/usr/share/icons/Papirus//usr/share/icons/Papirus-Dark//usr/share/icons/Papirus-Light/

Тема Numix (Numix-Circle, Numix-Square):
/usr/share/icons/Numix//usr/share/icons/Numix-Circle//usr/share/icons/Numix-Circle-Light/
