# =============================================
# Иконки папок Adwaita:
# /usr/share/icons/Adwaita/scalable/places
# =============================================

# =============================================
# Есть отличная тема иконок - MoreWaita (https://github.com/somepaulo/MoreWaita) которая расширяет Adwaita. Можно комбинировать ее с Numix и Papirus
# =============================================

# =============================================
# Лучшие темы иконок для Linux
# =============================================

# MoreWaita = https://github.com/somepaulo/MoreWaita

# Numix = https://github.com/numixproject/numix-icon-theme-circle
# Numix Folders = https://github.com/numixproject/numix-folders

# Papirus = https://github.com/PapirusDevelopmentTeam/papirus-icon-theme
# Papirus Folders = https://github.com/PapirusDevelopmentTeam/papirus-folders
# =============================================


====================================================
ИНСТРУКЦИЯ: ИКОНКИ NUMIX-ADWAITA HYBRID
====================================================

ОПИСАНИЕ:
Данная тема является "прокси-темой". Она создана для того, чтобы 
использовать круглые иконки приложений из Numix Circle, но заменить 
стандартные папки на иконки в стиле Adwaita и MoreWaita.

СТРУКТУРА ТЕМЫ:
~/.local/share/icons/Numix-Hybrid-Folders/
├── index.theme          - Основной конфигурационный файл.
└── scalable/places/     - Папка с символическими ссылками на иконки 
                           папок из Adwaita и MoreWaita.

ЛОГИКА РАБОТЫ:
1. Система сначала ищет иконки в этой теме. Поскольку здесь 
   прописана только категория "places", она берет отсюда папки.
2. Для всех остальных иконок (приложения, панель, статусы) система 
   обращается к списку "Inherits" в файле index.theme.
3. Порядок наследования: Numix-Circle -> Numix -> Adwaita -> hicolor.

КАК УСТАНОВИТЬ:
1. Создайте структуру папок:

mkdir -p ~/.local/share/icons/Numix-Hybrid-Folders/scalable/places
====================================================
2. Создайте символические ссылки на иконки папок:

ln -s /usr/share/icons/Adwaita/scalable/places/* ~/.local/share/icons/Numix-Hybrid-Folders/scalable/places/
ln -sf /usr/share/icons/MoreWaita/scalable/places/* ~/.local/share/icons/Numix-Hybrid-Folders/scalable/places/
====================================================
3. Создайте index.theme (содержимое):

[Icon Theme]
Name=Numix Hybrid Folders
Comment=Numix Circle with Adwaita & MoreWaita folders
Inherits=Numix-Circle,Numix,Adwaita,hicolor
Example=folder

# Оставляем только то, что реально описывает структуру
Directories=scalable/places

[scalable/places]
Size=96
Context=Places
MinSize=16
MaxSize=512
Type=Scalable
====================================================
 4. Удалите лишние иконки:

rm ~/.local/share/icons/Numix-Hybrid-Folders/scalable/places/network-server.svg
rm ~/.local/share/icons/Numix-Hybrid-Folders/scalable/places/network-workgroup.svg
rm ~/.local/share/icons/Numix-Hybrid-Folders/scalable/places/user-trash.svg
====================================================

АКТИВАЦИЯ В SWAY / GTK:
Так как в Sway нет графического конфигуратора, пропишите тему в 
~/.config/gtk-3.0/settings.ini и ~/.config/gtk-4.0/settings.ini:

[Settings]
gtk-icon-theme-name=Numix-Hybrid-Folders

ОБНОВЛЕНИЕ КЭША (если иконки не появились):
gtk-update-icon-cache ~/.local/share/icons/Numix-Hybrid-Folders
====================================================
