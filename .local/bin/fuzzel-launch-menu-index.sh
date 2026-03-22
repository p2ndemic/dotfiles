#!/usr/bin/env bash

# ══════════════════════════════════════════════════════════════════════════════
# fuzzel-launch-menu-index.sh — Categorized application launcher using Fuzzel (dmenu mode)
# ══════════════════════════════════════════════════════════════════════════════

# ── Toggle: kill fuzzel if already running ────────────────────────────────────
pkill -x fuzzel && exit 0

# ══════════════════════════════════════════════════════════════════════════════
# Configuration
# ══════════════════════════════════════════════════════════════════════════════

# Launch prefix — wraps app execution inside a systemd transient scope
LAUNCH_PREFIX="systemd-run --user --scope --slice=app-graphical.slice --collect --no-block --quiet --"
# LAUNCH_PREFIX="uwsm app --"

# Terminal command
TERMINAL_CMD="foot -a '{cmd}' -T '{cmd}' {cmd}"

# Font used in the fuzzel window (FontConfig format)
FONT="BlexMono Nerd Font Mono:size=14"

# Window anchor position on screen
# Options: top-left | top | top-right | left | center | right | bottom-left | bottom | bottom-right
ALIGN="bottom-left"

# ══════════════════════════════════════════════════════════════════════════════
# Helpers
# ══════════════════════════════════════════════════════════════════════════════

# ── Fuzzel runner — shared options for all menus ──────────────────────────────
fuzzel_run() {
    fuzzel \
        --dmenu \
        --index \
        --launch-prefix="$LAUNCH_PREFIX" \
        --terminal="$TERMINAL_CMD" \
        --font="$FONT" \
        --anchor="$ALIGN" \
        --y-margin=10 \
        --hide-prompt \
        --lines=11 \
        --width=20 \
        --horizontal-pad=12 \
        --vertical-pad=10 \
        --line-height=24
}

# ── Build a dmenu entry with an icon (Rofi/Fuzzel extended dmenu protocol) ───────────
# ── Usage: fuzzel_item "Label" "icon-name" ──
fuzzel_item() {
    printf '%s\0icon\x1f%s\n' "$1" "$2"
}

# ══════════════════════════════════════════════════════════════════════════════
# Menu definitions
# ══════════════════════════════════════════════════════════════════════════════

# ── Main category selector ────────────────────────────────────────────────────
show_main_menu() {
    echo -e "🖥️ Terminal"    # Index [0]
    echo -e "📂 Explorer"    # Index [1] | Alt_icon = 🗃️
    echo -e "🌐 Internet"    # Index [2] | Alt_icon = 🖌️
    echo -e "💻 Development" # Index [3] | Alt_icon = 🕹️
    echo -e "🎨 Graphics"    # Index [4]
    echo -e "🎬 Multimedia"  # Index [5]
    echo -e "🎮 Games"       # Index [6]
    echo -e "⚙️ System"      # Index [7]
    echo -e "📦 Utilities"   # Index [8]
    echo -e "🔌 Power"       # Index [9]
    echo -e "❌ Exit"        # Index [10]
}

# ── Terminal emulators ────────────────────────────────────────────────────────
show_terminal_menu() {
    fuzzel_item "Foot"        "foot"  # Index [0]
    fuzzel_item "Foot-Server" "foot"  # Index [1]
    fuzzel_item "Foot-Client" "foot"  # Index [2]
}

# ── File managers ─────────────────────────────────────────────────────────────
show_explorer_menu() {
    fuzzel_item "PCManFM-QT" "pcmanfm-qt"  # Index [0]
    fuzzel_item "Yazi"       "yazi"        # Index [1]
}

# ── Browsers and messengers ───────────────────────────────────────────────────
show_internet_menu() {
    fuzzel_item "Firefox"     "firefox"        # Index [0]
    fuzzel_item "Brave"       "brave-desktop"  # Index [1]
    fuzzel_item "Helium"      "helium"         # Index [2]
    fuzzel_item "qBittorrent" "qbittorrent"    # Index [3]
    fuzzel_item "Telegram"    "telegram"       # Index [4]
}

# ── Development tools ─────────────────────────────────────────────────────────
show_development_menu() {
    fuzzel_item "Zed"        "zed"                        # Index [0]
    fuzzel_item "Code-OSS"   "com.visualstudio.code.oss"  # Index [1]
    fuzzel_item "Featherpad" "featherpad"                 # Index [2]
    fuzzel_item "Micro"      "micro"                      # Index [3]
    fuzzel_item "Meld"       "org.gnome.Meld"             # Index [4]
}

# ── Image viewers and document readers ───────────────────────────────────────
show_graphics_menu() {
    fuzzel_item "Oculante" "oculante"          # Index [0]
    fuzzel_item "Zathura"  "org.pwmt.zathura"  # Index [1]
}

# ── Media players ─────────────────────────────────────────────────────────────
show_multimedia_menu() {
    fuzzel_item "mpv" "mpv"  # Index [0]
}

# ── Game launchers ────────────────────────────────────────────────────────────
show_games_menu() {
    fuzzel_item "Steam"  "steam"            # Index [0]
    fuzzel_item "Faugus" "faugus-launcher"  # Index [1]
    fuzzel_item "Heroic" "heroic"           # Index [2]
}

# ── System utilities ──────────────────────────────────────────────────────────
show_system_menu() {
    fuzzel_item "Btop"    "utilities-terminal"  # Index [0]
    fuzzel_item "GParted" "gparted"             # Index [1]
}

# ── Miscellaneous tools ───────────────────────────────────────────────────────
show_utilities_menu() {
    fuzzel_item "Qalculate"  "qalculate"     # Index [0]
    fuzzel_item "Screenshot" "camera-photo"  # Index [1]
    fuzzel_item "Arqiver"    "arqiver"       # Index [2]
}

# ── Power management ──────────────────────────────────────────────────────────
show_power_menu() {
    echo -e " Lock"      # Index [0] | Alt_icon = 󰌾
    echo -e "󰗽 Logout"    # Index [1] | Alt_icon = 󰗼
    echo -e "󰖔 Suspend"   # Index [2]
    echo -e "󰜉 Reboot"    # Index [3]
    echo -e "󰐥 Shutdown"  # Index [4]
}

# ══════════════════════════════════════════════════════════════════════════════
# Navigation loop
# ══════════════════════════════════════════════════════════════════════════════

CURRENT_MENU="main"

while true; do

    # ── Main menu: category selection ─────────────────────────────────────────
    if [ "$CURRENT_MENU" = "main" ]; then
        CHOICE=$(show_main_menu | fuzzel_run)
        case "$CHOICE" in
            0)  CURRENT_MENU="terminal"    ;;  # → Terminal
            1)  CURRENT_MENU="explorer"    ;;  # → Explorer
            2)  CURRENT_MENU="internet"    ;;  # → Internet
            3)  CURRENT_MENU="development" ;;  # → Development
            4)  CURRENT_MENU="graphics"    ;;  # → Graphics
            5)  CURRENT_MENU="multimedia"  ;;  # → Multimedia
            6)  CURRENT_MENU="games"       ;;  # → Games
            7)  CURRENT_MENU="system"      ;;  # → System
            8)  CURRENT_MENU="utilities"   ;;  # → Utilities
            9)  CURRENT_MENU="power"       ;;  # → Power
            *)  exit 0                     ;;  # Exit | Esc
        esac

    # ── Terminal emulators ────────────────────────────────────────────────────
    elif [ "$CURRENT_MENU" = "terminal" ]; then
        CHOICE=$(show_terminal_menu | fuzzel_run)
        case "$CHOICE" in
            0)  foot          ; exit 0 ;;  # Index [0]
            1)  foot --server ; exit 0 ;;  # Index [1]
            2)  footclient    ; exit 0 ;;  # Index [2]
            *)  CURRENT_MENU="main"    ;;  # ← Back
        esac

    # ── File managers ─────────────────────────────────────────────────────────
    elif [ "$CURRENT_MENU" = "explorer" ]; then
        CHOICE=$(show_explorer_menu | fuzzel_run)
        case "$CHOICE" in
            0)  pcmanfm-qt ; exit 0 ;;  # Index [0]
            1)  yazi       ; exit 0 ;;  # Index [1]
            *)  CURRENT_MENU="main" ;;  # ← Back
        esac

    # ── Browsers and messengers ───────────────────────────────────────────────
    elif [ "$CURRENT_MENU" = "internet" ]; then
        CHOICE=$(show_internet_menu | fuzzel_run)
        case "$CHOICE" in
            0)  firefox          ; exit 0 ;;  # Index [0]
            1)  brave            ; exit 0 ;;  # Index [1]
            2)  helium-browser   ; exit 0 ;;  # Index [2]
            3)  qbittorrent      ; exit 0 ;;  # Index [3]
            4)  telegram-desktop ; exit 0 ;;  # Index [4]
            *)  CURRENT_MENU="main"       ;;  # ← Back
        esac

    # ── Development tools ─────────────────────────────────────────────────────
    elif [ "$CURRENT_MENU" = "development" ]; then
        CHOICE=$(show_development_menu | fuzzel_run)
        case "$CHOICE" in
            0)  zed        ; exit 0 ;;  # Index [0]
            1)  code-oss   ; exit 0 ;;  # Index [1]
            2)  featherpad ; exit 0 ;;  # Index [2]
            3)  micro      ; exit 0 ;;  # Index [3]
            4)  meld       ; exit 0 ;;  # Index [4]
            *)  CURRENT_MENU="main" ;;  # ← Back
        esac

    # ── Image viewers and document readers ───────────────────────────────────
    elif [ "$CURRENT_MENU" = "graphics" ]; then
        CHOICE=$(show_graphics_menu | fuzzel_run)
        case "$CHOICE" in
            0)  oculante ; exit 0   ;;  # Index [0]
            1)  zathura  ; exit 0   ;;  # Index [1]
            *)  CURRENT_MENU="main" ;;  # ← Back
        esac

    # ── Media players ─────────────────────────────────────────────────────────
    elif [ "$CURRENT_MENU" = "multimedia" ]; then
        CHOICE=$(show_multimedia_menu | fuzzel_run)
        case "$CHOICE" in
            0)  mpv ; exit 0        ;;  # Index [0]
            *)  CURRENT_MENU="main" ;;  # ← Back
        esac

    # ── Game launchers ────────────────────────────────────────────────────────
    elif [ "$CURRENT_MENU" = "games" ]; then
        CHOICE=$(show_games_menu | fuzzel_run)
        case "$CHOICE" in
            0)  steam           ; exit 0 ;;  # Index [0]
            1)  faugus-launcher ; exit 0 ;;  # Index [1]
            2)  heroic          ; exit 0 ;;  # Index [2]
            *)  CURRENT_MENU="main"      ;;  # ← Back
        esac

    # ── System utilities ──────────────────────────────────────────────────────
    elif [ "$CURRENT_MENU" = "system" ]; then
        CHOICE=$(show_system_menu | fuzzel_run)
        case "$CHOICE" in
            0)  btop    ; exit 0    ;;  # Index [0]
            1)  gparted ; exit 0    ;;  # Index [1]
            *)  CURRENT_MENU="main" ;;  # ← Back
        esac

    # ── Miscellaneous tools ───────────────────────────────────────────────────
    elif [ "$CURRENT_MENU" = "utilities" ]; then
        CHOICE=$(show_utilities_menu | fuzzel_run)
        case "$CHOICE" in
            0)  qalculate-gtk ; exit 0 ;;  # Index [0]
            1)  grimshot      ; exit 0 ;;  # Index [1]
            2)  arqiver       ; exit 0 ;;  # Index [2]
            *)  CURRENT_MENU="main"    ;;  # ← Back
        esac

    # ── Power management ──────────────────────────────────────────────────────
    elif [ "$CURRENT_MENU" = "power" ]; then
        CHOICE=$(show_power_menu | fuzzel_run)
        case "$CHOICE" in
            0)  loginctl lock-session      "$XDG_SESSION_ID" ;;  # Lock     Index [0]
            1)  loginctl terminate-session "$XDG_SESSION_ID" ;;  # Logout   Index [1]
            2)  systemctl suspend                            ;;  # Suspend  Index [2]
            3)  systemctl reboot                             ;;  # Reboot   Index [3]
            4)  systemctl poweroff                           ;;  # Shutdown Index [4]
            *)  CURRENT_MENU="main"                          ;;  # ← Back
        esac
    fi

done
