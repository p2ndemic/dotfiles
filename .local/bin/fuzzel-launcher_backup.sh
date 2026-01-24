#!/bin/bash

# --- Настройки ---
# Используем minimal-lines, чтобы окно подстраивалось под количество пунктов
FUZZEL_OPTS="--dmenu --width=35 --minimal-lines"

# --- Функции вывода списков ---

show_main_menu() {
    echo -e "🖥️ Terminal"
    echo -e "📁 Explorer"
    echo -e "🌐 Internet"
    echo -e "💻 Development"
    echo -e "🎨 Graphics"
    echo -e "🎬 Multimedia"
    echo -e "🎮 Games"
    echo -e "⚙️ System"
    echo -e "🛠️ Utilities"
    echo -e "🔌 Power"
    echo -e "❌ Exit"
}

show_terminal_menu() {
    echo -en "Foot\0icon\x1ffoot\n"
    echo -en "Alacritty\0icon\x1falacritty\n"
    echo -en "Kitty\0icon\x1fkitty\n"
    echo -en "WezTerm\0icon\x1fwezterm\n"
    echo -en "Black Box\0icon\x1fblackbox\n"
}

show_explorer_menu() {
    echo -en "Thunar\0icon\x1forg.xfce.thunar\n"
    echo -en "Nautilus\0icon\x1forg.gnome.Nautilus\n"
    echo -en "Dolphin\0icon\x1forg.kde.dolphin\n"
    echo -en "PCManFM-QT\0icon\x1fpcmanfm-qt\n"
    echo -en "Yazi\0icon\x1fyazi\n"
    echo -en "Ranger\0icon\x1futilities-terminal\n"
}

show_internet_menu() {
    echo -en "Firefox\0icon\x1ffirefox\n"
    echo -en "Chromium\0icon\x1fchromium\n"
    echo -en "Brave\0icon\x1fbrave-browser\n"
    echo -en "Telegram\0icon\x1ftelegram\n"
    echo -en "qBittorrent\0icon\x1fqbittorrent\n"
}

show_development_menu() {
    echo -en "Zed\0icon\x1fzed\n"
    echo -en "Meld\0icon\x1forg.gnome.Meld\n"
    echo -en "Neovim\0icon\x1fnvim\n"
    echo -en "VSCodium\0icon\x1fvscodium\n"
    echo -en "Helix\0icon\x1fhelix\n"
    echo -en "Micro\0icon\x1fmicro\n"
    echo -en "Kate\0icon\x1fkate\n"
}

show_graphics_menu() {
    echo -en "Oculante\0icon\x1foculante\n"
    echo -en "GIMP\0icon\x1fgimp\n"
    echo -en "Inkscape\0icon\x1finkscape\n"
    echo -en "imv\0icon\x1fimage-viewer\n"
    echo -en "Feh\0icon\x1ffe\n"
}

show_multimedia_menu() {
    echo -en "mpv\0icon\x1fmpv\n"
    echo -en "VLC\0icon\x1fvlc\n"
    echo -en "Celluloid\0icon\x1fcelluloid\n"
    echo -en "Audacious\0icon\x1faudacious\n"
    echo -en "Spotify\0icon\x1fspotify-client\n"
}

show_games_menu() {
    echo -en "Steam\0icon\x1fsteam\n"
    echo -en "Lutris\0icon\x1flutris\n"
    echo -en "Heroic Games Launcher\0icon\x1fcom.heroicgameslauncher.hgl\n"
}

show_system_menu() {
    echo -en "GParted\0icon\x1fgparted\n"
    echo -en "Btop\0icon\x1futilities-terminal\n"
    echo -en "Htop\0icon\x1futilities-terminal\n"
    echo -en "Timeshift\0icon\x1ftimeshift\n"
}

show_utilities_menu() {
    echo -en "Calculator\0icon\x1forg.gnome.Calculator\n"
    echo -en "Screenshot\0icon\x1fcamera-photo\n"
    echo -en "Archive Manager\0icon\x1fgnome-ark\n"
}

show_power_menu() {
    echo -e " Lock" # 
    echo -e "󰗼 Logout"
    echo -e "󰖔 Suspend" # 󰤄 󰒲
    echo -e "󰜉 Reboot"
    echo -e "󰐥 Shutdown"
}

# --- Логика навигации ---

current_menu="main"

while true; do
    if [ "$current_menu" = "main" ]; then
        choice=$(show_main_menu | fuzzel $FUZZEL_OPTS --prompt="Apps: ")

        case "$choice" in
            "🖥️ Terminal")
                current_menu="terminal"
                ;;
            "📁 Explorer")
                current_menu="explorer"
                ;;
            "🌐 Internet")
                current_menu="internet"
                ;;
            "💻 Development")
                current_menu="development"
                ;;
            "🎨 Graphics")
                current_menu="graphics"
                ;;
            "🎬 Multimedia")
                current_menu="multimedia"
                ;;
            "🎮 Games")
                current_menu="games"
                ;;
            "⚙️ System")
                current_menu="system"
                ;;
            "🛠️ Utilities")
                current_menu="utilities"
                ;;
            "🔌 Power")
                current_menu="power"
                ;;
            "❌ Exit"|"")
                exit 0
                ;;
            *)
                exit 0
                ;;
        esac

    elif [ "$current_menu" = "terminal" ]; then
        choice=$(show_terminal_menu | fuzzel $FUZZEL_OPTS --prompt="Terminal: ")
        case "$choice" in
            "")
                current_menu="main"
                ;;
            "Foot")
                foot &
                exit 0
                ;;
            "Alacritty")
                alacritty &
                exit 0
                ;;
            "Kitty")
                kitty &
                exit 0
                ;;
            "WezTerm")
                wezterm &
                exit 0
                ;;
            "Black Box")
                blackbox &
                exit 0
                ;;
        esac

    elif [ "$current_menu" = "explorer" ]; then
        choice=$(show_explorer_menu | fuzzel $FUZZEL_OPTS --prompt="Explorer: ")
        case "$choice" in
            "")
                current_menu="main"
                ;;
            "Thunar")
                thunar &
                exit 0
                ;;
            "Nautilus")
                nautilus &
                exit 0
                ;;
            "Dolphin")
                dolphin &
                exit 0
                ;;
            "PCManFM-QT")
                pcmanfm-qt &
                exit 0
                ;;
            "Yazi")
                foot -e yazi &
                exit 0
                ;;
            "Ranger")
                foot -e ranger &
                exit 0
                ;;
        esac

    elif [ "$current_menu" = "internet" ]; then
        choice=$(show_internet_menu | fuzzel $FUZZEL_OPTS --prompt="Internet: ")
        case "$choice" in
            "")
                current_menu="main"
                ;;
            "Firefox")
                firefox &
                exit 0
                ;;
            "Chromium")
                chromium &
                exit 0
                ;;
            "Brave")
                brave-browser &
                exit 0
                ;;
            "Telegram")
                telegram-desktop &
                exit 0
                ;;
            "qBittorrent")
                qbittorrent &
                exit 0
                ;;
        esac

    elif [ "$current_menu" = "development" ]; then
        choice=$(show_development_menu | fuzzel $FUZZEL_OPTS --prompt="Development: ")
        case "$choice" in
            "")
                current_menu="main"
                ;;
            "Zed")
                zed &
                exit 0
                ;;
            "Meld")
                meld &
                exit 0
                ;;
            "Neovim")
                alacritty -e nvim &
                exit 0
                ;;
            "VSCodium")
                codium &
                exit 0
                ;;
            "Helix")
                alacritty -e hx &
                exit 0
                ;;
            "Micro")
                foot -e micro &
                exit 0
                ;;
            "Kate")
                kate &
                exit 0
                ;;
        esac

    elif [ "$current_menu" = "graphics" ]; then
        choice=$(show_graphics_menu | fuzzel $FUZZEL_OPTS --prompt="Graphics: ")
        case "$choice" in
            "")
                current_menu="main"
                ;;
            "Oculante")
                oculante &
                exit 0
                ;;
            "GIMP")
                gimp &
                exit 0
                ;;
            "Inkscape")
                inkscape &
                exit 0
                ;;
            "imv")
                imv &
                exit 0
                ;;
            "Feh")
                feh &
                exit 0
                ;;
        esac

    elif [ "$current_menu" = "multimedia" ]; then
        choice=$(show_multimedia_menu | fuzzel $FUZZEL_OPTS --prompt="Multimedia: ")
        case "$choice" in
            "")
                current_menu="main"
                ;;
            "mpv")
                mpv --player-operation-mode=pseudo-gui &
                exit 0
                ;;
            "VLC")
                vlc &
                exit 0
                ;;
            "Celluloid")
                celluloid &
                exit 0
                ;;
            "Audacious")
                audacious &
                exit 0
                ;;
            "Spotify")
                spotify &
                exit 0
                ;;
        esac

    elif [ "$current_menu" = "games" ]; then
        choice=$(show_games_menu | fuzzel $FUZZEL_OPTS --prompt="Games: ")
        case "$choice" in
            "")
                current_menu="main"
                ;;
            "Steam")
                steam &
                exit 0
                ;;
            "Lutris")
                lutris &
                exit 0
                ;;
            "Heroic Games Launcher")
                heroic &
                exit 0
                ;;
        esac

    elif [ "$current_menu" = "system" ]; then
        choice=$(show_system_menu | fuzzel $FUZZEL_OPTS --prompt="System: ")
        case "$choice" in
            "")
                current_menu="main"
                ;;
            "GParted")
                gparted &
                exit 0
                ;;
            "Btop")
                foot -e btop &
                exit 0
                ;;
            "Htop")
                foot -e htop &
                exit 0
                ;;
            "Timeshift")
                timeshift-launcher &
                exit 0
                ;;
        esac

    elif [ "$current_menu" = "utilities" ]; then
        choice=$(show_utilities_menu | fuzzel $FUZZEL_OPTS --prompt="Utilities: ")
        case "$choice" in
            "")
                current_menu="main"
                ;;
            "Calculator")
                gnome-calculator &
                exit 0
                ;;
            "Screenshot")
                grimshot copy area &
                exit 0
                ;;
            "Archive Manager")
                file-roller &
                exit 0
                ;;
        esac

    elif [ "$current_menu" = "power" ]; then
        choice=$(show_power_menu | fuzzel $FUZZEL_OPTS --prompt="Power: ")
        case "$choice" in
            "")
                current_menu="main"
                ;;
            " Lock")
                swaylock &
                exit 0
                ;;
            "󰗼 Logout")
                loginctl terminate-user $USER
                ;;
            "󰖔 Suspend")
                systemctl suspend
                exit 0
                ;;
            "󰜉 Reboot")
                systemctl reboot
                ;;
            "󰐥 Shutdown")
                systemctl poweroff
                ;;
        esac
    fi
done
