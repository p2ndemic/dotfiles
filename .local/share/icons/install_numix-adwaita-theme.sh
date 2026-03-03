#!/usr/bin/env bash

echo "Начинаем установку гибридной темы Numix-Adwaita..."

# Исходные темы
# NUMIX="/usr/share/icons/Numix"
# NUMIX_LIGHT="/usr/share/icons/Numix-Light"
# MOREWAITA="/usr/share/icons/MoreWaita"
# ADWAITA="/usr/share/icons/Adwaita"

# Целевые темы
TARGET_THEME="$HOME/.local/share/icons/Numix-Adwaita"
TARGET_THEME_LIGHT="$HOME/.local/share/icons/Numix-Adwaita-Light"

# 1. Очистка старых версий
rm -rf ~/.local/share/icons/Numix-Adwaita
rm -rf ~/.local/share/icons/Numix-Adwaita-Light

# 2. Создание структуры
# Apps:
mkdir -p ~/.local/share/icons/Numix-Adwaita/scalable/apps
mkdir -p ~/.local/share/icons/Numix-Adwaita-Light/scalable/apps
# Places:
mkdir -p ~/.local/share/icons/Numix-Adwaita/scalable/places
mkdir -p ~/.local/share/icons/Numix-Adwaita-Light/scalable/places
# Devices:
mkdir -p ~/.local/share/icons/Numix-Adwaita/scalable/devices
mkdir -p ~/.local/share/icons/Numix-Adwaita-Light/scalable/devices
# Mimetypes:
mkdir -p ~/.local/share/icons/Numix-Adwaita/scalable/mimetypes
mkdir -p ~/.local/share/icons/Numix-Adwaita-Light/scalable/mimetypes

# 3. Линковка иконок (Adwaita + MoreWaita перекрывают Numix)
for theme in "$TARGET_THEME" "$TARGET_THEME_LIGHT"; do
    apps_path="$theme/scalable/apps"
    places_path="$theme/scalable/places"
    devices_path="$theme/scalable/devices"
    mimetypes_path="$theme/scalable/mimetypes"

    # Папки Adwaita
    # Places
    ln -sf /usr/share/icons/Adwaita/scalable/places/* "$places_path/" 2>/dev/null || true

    # Папки MoreWaita
    # Places
    ln -sf /usr/share/icons/MoreWaita/scalable/places/* "$places_path/" 2>/dev/null || true
    # Apps
    ln -sf /usr/share/icons/MoreWaita/scalable/apps/* "$apps_path/" 2>/dev/null || true
    # Devices
    ln -sf /usr/share/icons/MoreWaita/scalable/devices/* "$devices_path/" 2>/dev/null || true
    # Mimetypes
    ln -sf /usr/share/icons/MoreWaita/scalable/mimetypes/* "$mimetypes_path/" 2>/dev/null || true

    # Специфичные фиксы имён
    # Places
    ln -sf /usr/share/icons/Adwaita/scalable/places/folder.svg "$places_path/default-folder.svg" 2>/dev/null || true
    ln -sf /usr/share/icons/Adwaita/scalable/places/folder.svg "$places_path/folder_color_default.svg" 2>/dev/null || true
    ln -sf /usr/share/icons/Adwaita/scalable/places/folder.svg "$places_path/stock_folder.svg" 2>/dev/null || true
    ln -sf /usr/share/icons/Adwaita/scalable/places/folder.svg "$places_path/gtk-directory.svg" 2>/dev/null || true
    ln -sf /usr/share/icons/Adwaita/scalable/places/folder.svg "$places_path/gnome-folder.svg" 2>/dev/null || true
    ln -sf /usr/share/icons/Adwaita/scalable/mimetypes/inode-directory.svg "$places_path/inode-directory.svg" 2>/dev/null || true

    # Чистка ненужных/проблемных иконок
    rm -f "$places_path/network-server.svg" \
        "$places_path/network-workgroup.svg" \
        "$places_path/user-trash.svg" \
        "$places_path/user-trash-full.svg" \
        "$apps_path/chromium.svg" \
        "$apps_path/chromium-browser.svg" \
        "$apps_path/chromium-browser-privacy.svg" \
        "$apps_path/chromium-freeworld.svg" \
        "$apps_path/com.calibre_ebook.calibre.ebook_edit.svg" \
        "$apps_path/com.calibre_ebook.calibre.ebook_viewer.svg" \
        "$apps_path/com.calibre_ebook.calibre.ebook-edit.svg" \
        "$apps_path/com.calibre_ebook.calibre.ebook-viewer.svg" \
        "$apps_path/com.calibre_ebook.calibre.lrfviewer.svg" || true
done

# 4. Создание index.theme для основной темы
cat <<EOF > ~/.local/share/icons/Numix-Adwaita/index.theme
[Icon Theme]
Name=Numix-Adwaita
Comment=Classic Numix overridden with Adwaita & MoreWaita
Inherits=Numix,MoreWaita,Adwaita,hicolor
FollowsColorScheme=true
Example=folder
Directories=scalable/apps,scalable/devices,scalable/mimetypes,scalable/places

[scalable/apps]
Size=48
Context=Applications
MinSize=16
MaxSize=512
Type=Scalable

[scalable/devices]
Size=64
Context=Devices
MinSize=16
MaxSize=512
Type=Scalable

[scalable/places]
Size=48
Context=Places
MinSize=16
MaxSize=512
Type=Scalable

[scalable/mimetypes]
Context=MimeTypes
Size=64
MinSize=24
MaxSize=512
Type=Scalable
EOF

# 5. Создание index.theme для Light темы
cat <<EOF > ~/.local/share/icons/Numix-Adwaita-Light/index.theme
[Icon Theme]
Name=Numix-Adwaita-Light
Comment=Numix Light overridden with Adwaita & MoreWaita
Inherits=Numix-Light,Numix,MoreWaita,Adwaita,hicolor
FollowsColorScheme=true
Example=folder
Directories=scalable/apps,scalable/devices,scalable/mimetypes,scalable/places

[scalable/apps]
Size=48
Context=Applications
MinSize=16
MaxSize=512
Type=Scalable

[scalable/devices]
Size=64
Context=Devices
MinSize=16
MaxSize=512
Type=Scalable

[scalable/places]
Size=48
Context=Places
MinSize=16
MaxSize=512
Type=Scalable

[scalable/mimetypes]
Context=MimeTypes
Size=64
MinSize=24
MaxSize=512
Type=Scalable
EOF

echo "Обновление кэша..."

# 6. Обновление кэша
gtk-update-icon-cache -f "$TARGET_THEME/"
gtk-update-icon-cache -f "$TARGET_THEME_LIGHT/"

gtk4-update-icon-cache -f "$TARGET_THEME/"
gtk4-update-icon-cache -f "$TARGET_THEME_LIGHT/"

update-desktop-database ~/.local/share/applications
sudo update-desktop-database /usr/share/applications >/dev/null 2>&1

update-mime-database ~/.local/share/mime
sudo update-mime-database /usr/share/mime >/dev/null 2>&1

rm -rf ~/.cache/thumbnails/* ~/.cache/qtshadercache*

# Завершение установки
echo "Готово! Темы установлены в ~/.local/share/icons/"
