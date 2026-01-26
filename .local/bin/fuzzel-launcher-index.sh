#!/bin/bash

# --- Настройки ---

# --- Инициализация терминала ---
# Используем foot, если системная переменная $TERMINAL не определена
: "${TERMINAL:=foot}"

# --- Конфигурация интерфейса ---
# ВНИМАНИЕ: Fuzzel может некорректно обрабатывать имена шрифтов с пробелами.
# В качестве обходного решения (workaround) указываем прямой путь к файлу шрифта.
#FONT_PRIMARY="/usr/share/fonts/Adwaita/AdwaitaMono-Regular.ttf"
#FONT_FALLBACK="Hack"
#FONT="$FONT_PRIMARY:size=16,$FONT_FALLBACK:size=16"

FONT=Hack:size=14

# --- Позиционирование окна на экране ---
# Доступно: top-left, top, top-right, left, center, right, bottom-left, bottom, bottom-right
ALIGN="bottom-left"

# --- Сборка параметров Fuzzel в единую переменную ---
# Порядок: режим dmenu, индекс, шрифт, позиция, скрыть ввод, авто-высота, ширина, отступы
FUZZEL_OPTS="--dmenu \
    --index \
    --font=$FONT \
    --anchor=$ALIGN \
    --y-margin=10 \
    --hide-prompt \
    --lines=11 \
    --width=20 \
    --horizontal-pad=12 \
    --vertical-pad=10 \
    --line-height=24"

# --- Функции вывода списков ---

# Главное меню выбора категорий
show_main_menu() {
    echo -e "🖥️ Terminal"     # index [0]
    echo -e "📂 Explorer"     # index [1]
    echo -e "🌐 Internet"     # index [2]
    echo -e "💻 Development"  # index [3]
    echo -e "🖌️ Graphics"     # index [4]
    echo -e "🎬 Multimedia"   # index [5]
    echo -e "🎮 Games"        # index [6]
    echo -e "⚙️ System"       # index [7]
    echo -e "📦 Utilities"    # index [8]
    echo -e "🔌 Power"        # index [9]
    echo -e "❌ Exit"         # index [10]
}

# Список терминалов
show_terminal_menu() {
    echo -en "Foot\0icon\x1ffoot\n"               # index [0]
    echo -en "Alacritty\0icon\x1falacritty\n"     # index [1]
    echo -en "Kitty\0icon\x1fkitty\n"             # index [2]
    echo -en "WezTerm\0icon\x1fwezterm\n"         # index [3]
    echo -en "Black Box\0icon\x1fblackbox\n"      # index [4]
}

# Файловые менеджеры
show_explorer_menu() {
    echo -en "Thunar\0icon\x1forg.xfce.thunar\n"      # index [0]
    echo -en "Nautilus\0icon\x1forg.gnome.Nautilus\n" # index [1]
    echo -en "Dolphin\0icon\x1forg.kde.dolphin\n"     # index [2]
    echo -en "PCManFM-QT\0icon\x1fpcmanfm-qt\n"       # index [3]
    echo -en "Yazi\0icon\x1fyazi\n"                   # index [4]
    echo -en "Ranger\0icon\x1futilities-terminal\n"   # index [5]
}

# Браузеры и мессенджеры
show_internet_menu() {
    echo -en "Firefox\0icon\x1ffirefox\n"             # index [0]
    echo -en "Chromium\0icon\x1fchromium\n"           # index [1]
    echo -en "Brave\0icon\x1fbrave-browser\n"         # index [2]
    echo -en "Telegram\0icon\x1ftelegram\n"           # index [3]
    echo -en "qBittorrent\0icon\x1fqbittorrent\n"     # index [4]
}

# Инструменты разработки
show_development_menu() {
    echo -en "Zed\0icon\x1fzed\n"                     # index [0]
    echo -en "Meld\0icon\x1forg.gnome.Meld\n"         # index [1]
    echo -en "Neovim\0icon\x1fnvim\n"                 # index [2]
    echo -en "VSCodium\0icon\x1fvscodium\n"           # index [3]
    echo -en "Helix\0icon\x1fhelix\n"                 # index [4]
    echo -en "Micro\0icon\x1fmicro\n"                 # index [5]
    echo -en "Kate\0icon\x1fkate\n"                   # index [6]
}

# Графические редакторы и просмотрщики
show_graphics_menu() {
    echo -en "Oculante\0icon\x1foculante\n"           # index [0]
    echo -en "GIMP\0icon\x1fgimp\n"                   # index [1]
    echo -en "Inkscape\0icon\x1finkscape\n"           # index [2]
    echo -en "imv\0icon\x1fimage-viewer\n"            # index [3]
    echo -en "Feh\0icon\x1ffe\n"                      # index [4]
}

# Мультимедиа плееры
show_multimedia_menu() {
    echo -en "mpv\0icon\x1fmpv\n"                     # index [0]
    echo -en "VLC\0icon\x1fvlc\n"                     # index [1]
    echo -en "Celluloid\0icon\x1fcelluloid\n"         # index [2]
    echo -en "Audacious\0icon\x1faudacious\n"         # index [3]
    echo -en "Spotify\0icon\x1fspotify-client\n"      # index [4]
}

# Игровые лаунчеры
show_games_menu() {
    echo -en "Steam\0icon\x1fsteam\n"                 # index [0]
    echo -en "Lutris\0icon\x1flutris\n"               # index [1]
    echo -en "Heroic Games Launcher\0icon\x1fcom.heroicgameslauncher.hgl\n" # index [2]
}

# Системные утилиты
show_system_menu() {
    echo -en "GParted\0icon\x1fgparted\n"             # index [0]
    echo -en "Btop\0icon\x1futilities-terminal\n"     # index [1]
    echo -en "Htop\0icon\x1futilities-terminal\n"     # index [2]
    echo -en "Timeshift\0icon\x1ftimeshift\n"         # index [3]
}

# Различные инструменты
show_utilities_menu() {
    echo -en "Calculator\0icon\x1forg.gnome.Calculator\n" # index [0]
    echo -en "Screenshot\0icon\x1fcamera-photo\n"         # index [1]
    echo -en "Archive Manager\0icon\x1fgnome-ark\n"       # index [2]
}

# Меню управления питанием
show_power_menu() {
    echo -e " Lock"      # index [0]
    echo -e "󰗼 Logout"    # index [1]
    echo -e "󰖔 Suspend"   # index [2]
    echo -e "󰜉 Reboot"    # index [3]
    echo -e "󰐥 Shutdown"  # index [4]
}

# --- Логика навигации ---
CURRENT_MENU="main"

while true; do
    if [ "$CURRENT_MENU" = "main" ]; then
        CHOICE=$(show_main_menu | fuzzel $FUZZEL_OPTS)
        case "$CHOICE" in
            0)  CURRENT_MENU="terminal"    ;; # Переход: Терминалы
            1)  CURRENT_MENU="explorer"    ;; # Переход: Проводники
            2)  CURRENT_MENU="internet"    ;; # Переход: Интернет
            3)  CURRENT_MENU="development" ;; # Переход: Разработка
            4)  CURRENT_MENU="graphics"    ;; # Переход: Графика
            5)  CURRENT_MENU="multimedia"  ;; # Переход: Мультимедиа
            6)  CURRENT_MENU="games"       ;; # Переход: Игры
            7)  CURRENT_MENU="system"      ;; # Переход: Система
            8)  CURRENT_MENU="utilities"   ;; # Переход: Утилиты
            9)  CURRENT_MENU="power"       ;; # Переход: Питание
            *)  exit 0                     ;; # Выход
        esac

    elif [ "$CURRENT_MENU" = "terminal" ]; then
        CHOICE=$(show_terminal_menu | fuzzel $FUZZEL_OPTS)
        case "$CHOICE" in
            0)  foot & exit 0       ;; 
            1)  alacritty & exit 0  ;;
            2)  kitty & exit 0      ;;
            3)  wezterm & exit 0    ;;
            4)  blackbox & exit 0   ;;
            *)  CURRENT_MENU="main" ;; # Назад
        esac

    elif [ "$CURRENT_MENU" = "explorer" ]; then
        CHOICE=$(show_explorer_menu | fuzzel $FUZZEL_OPTS)
        case "$CHOICE" in
            0)  thunar & exit 0              ;;
            1)  nautilus & exit 0            ;;
            2)  dolphin & exit 0             ;;
            3)  pcmanfm-qt & exit 0          ;;
            4)  $TERMINAL -e yazi & exit 0   ;;
            5)  $TERMINAL -e ranger & exit 0 ;;
            *)  CURRENT_MENU="main"          ;; # Назад
        esac

    elif [ "$CURRENT_MENU" = "internet" ]; then
        CHOICE=$(show_internet_menu | fuzzel $FUZZEL_OPTS)
        case "$CHOICE" in
            0)  firefox & exit 0             ;;
            1)  chromium & exit 0            ;;
            2)  brave-browser & exit 0       ;;
            3)  telegram-desktop & exit 0    ;;
            4)  qbittorrent & exit 0         ;;
            *)  CURRENT_MENU="main"          ;; # Назад
        esac

    elif [ "$CURRENT_MENU" = "development" ]; then
        CHOICE=$(show_development_menu | fuzzel $FUZZEL_OPTS)
        case "$CHOICE" in
            0)  zed & exit 0                 ;;
            1)  meld & exit 0                ;;
            2)  $TERMINAL -e nvim & exit 0   ;;
            3)  codium & exit 0              ;;
            4)  $TERMINAL -e hx & exit 0     ;;
            5)  $TERMINAL -e micro & exit 0  ;;
            6)  kate & exit 0                ;;
            *)  CURRENT_MENU="main"          ;; # Назад
        esac

    elif [ "$CURRENT_MENU" = "graphics" ]; then
        CHOICE=$(show_graphics_menu | fuzzel $FUZZEL_OPTS)
        case "$CHOICE" in
            0)  oculante & exit 0    ;;
            1)  gimp & exit 0        ;;
            2)  inkscape & exit 0    ;;
            3)  imv & exit 0         ;;
            4)  feh & exit 0         ;;
            *)  CURRENT_MENU="main"  ;; # Назад
        esac

    elif [ "$CURRENT_MENU" = "multimedia" ]; then
        CHOICE=$(show_multimedia_menu | fuzzel $FUZZEL_OPTS)
        case "$CHOICE" in
            0)  mpv --player-operation-mode=pseudo-gui & exit 0 ;;
            1)  vlc & exit 0         ;;
            2)  celluloid & exit 0   ;;
            3)  audacious & exit 0   ;;
            4)  spotify & exit 0     ;;
            *)  CURRENT_MENU="main"  ;; # Назад
        esac

    elif [ "$CURRENT_MENU" = "games" ]; then
        CHOICE=$(show_games_menu | fuzzel $FUZZEL_OPTS)
        case "$CHOICE" in
            0)  steam & exit 0       ;;
            1)  lutris & exit 0      ;;
            2)  heroic & exit 0      ;;
            *)  CURRENT_MENU="main"  ;; # Назад
        esac

    elif [ "$CURRENT_MENU" = "system" ]; then
        CHOICE=$(show_system_menu | fuzzel $FUZZEL_OPTS)
        case "$CHOICE" in
            0)  gparted & exit 0               ;;
            1)  $TERMINAL -e btop & exit 0     ;;
            2)  $TERMINAL -e htop & exit 0     ;;
            3)  timeshift-launcher & exit 0    ;;
            *)  CURRENT_MENU="main"            ;; # Назад
        esac

    elif [ "$CURRENT_MENU" = "utilities" ]; then
        CHOICE=$(show_utilities_menu | fuzzel $FUZZEL_OPTS)
        case "$CHOICE" in
            0)  gnome-calculator & exit 0      ;;
            1)  grimshot copy area & exit 0    ;;
            2)  file-roller & exit 0           ;;
            *)  CURRENT_MENU="main"            ;; # Назад
        esac

    elif [ "$CURRENT_MENU" = "power" ]; then
        CHOICE=$(show_power_menu | fuzzel $FUZZEL_OPTS)
        case "$CHOICE" in
            0)
                loginctl lock-session                     # Блокировка [0]
                ;;
            1)
                labwc --exit                              # Выход [1]
                ;;
            2)
                systemctl suspend                         # Сон [2]
                ;;
            3)
                systemctl reboot                          # Перезагрузка [3]
                ;;
            4)
                systemctl poweroff                        # Выключение [4]
                ;;
            *)
                CURRENT_MENU="main"                       # Срабатывает при нажатии Esc или закрытии окна
                ;;
        esac
    fi
done
