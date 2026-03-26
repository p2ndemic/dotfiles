#!/usr/bin/env bash

# ══════════════════════════════════════════════════════════════════════════════
# fuzzel-launch-menu-index.sh — Categorized application launcher using Fuzzel (dmenu mode)
# ══════════════════════════════════════════════════════════════════════════════

# ── Toggle: kill fuzzel if already running ────────────────────────────────────
pkill -x fuzzel && exit 0

# ══════════════════════════════════════════════════════════════════════════════
# Configuration
# ══════════════════════════════════════════════════════════════════════════════

# Launch prefix — wraps app execution inside a systemd transient scope.
#
# Defined as a bash ARRAY instead of a plain STRING. Here is why:
#
#   When a command is stored as a STRING, bash applies word splitting on spaces
#   before passing it to the shell — quoting it breaks things in the opposite way:
#
#     STRING="systemd-run --user --"
#     "$STRING" firefox     # WRONG — the entire string becomes ONE argument:
#                           #   ["systemd-run --user --"]  instead of
#                           #   ["systemd-run", "--user", "--"]
#
#   An array preserves each element as a separate argument, always correctly:
#
#     ARRAY=(systemd-run --user --)
#     "${PREFIX[@]}" firefox  # CORRECT — expands to individual tokens:
#                             #   ["systemd-run", "--user", "--", "firefox"]
#
#   This also handles arguments that intentionally contain spaces, e.g.:
#
#     ARRAY=(systemd-run --setenv="MY_VAR=hello world" --)
#     # A plain string would split "hello world" into two separate arguments.
#     # An array keeps it as one.
#
# Note: --launch-prefix and --terminal fuzzel flags only work in XDG app mode,
#       not in --dmenu mode. Apps are launched directly by this script instead.
# systemd-run --user --scope --slice=app-graphical.slice --collect --no-block --quiet --
LAUNCH_PREFIX=(systemd-run --user --slice=app-graphical.slice --collect --no-block --quiet --)
# LAUNCH_PREFIX=(uwsm app --)

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
        --font="$FONT" \
        --anchor="$ALIGN" \
        --y-margin=2 \
        --hide-prompt \
        --lines=11 \
        --width=20 \
        --horizontal-pad=12 \
        --vertical-pad=10 \
        --line-height=24
}

# ── Build a dmenu entry with an icon (Rofi/Fuzzel extended dmenu protocol) ────
# ── Usage: fuzzel_item "Label" "icon-name" ────────────────────────────────────
fuzzel_item() {
    printf '%s\0icon\x1f%s\n' "$1" "$2"
}

# ── Launch a GUI application via the launch prefix, then exit ─────────────────
# ── Usage: run_app firefox ────────────────────────────────────────────────────
run_app() {
    exec "${LAUNCH_PREFIX[@]}" "$@"
}

# ── Launch a TUI application inside a foot terminal window, then exit ─────────
# ── Sets app-id and title to the command name for compositor rules ────────────
# ── Usage: run_term btop ──────────────────────────────────────────────────────
run_term() {
    exec "${LAUNCH_PREFIX[@]}" foot --app-id="$1" --title="$1" "$@"
}

# ══════════════════════════════════════════════════════════════════════════════
# Menu definitions
# ══════════════════════════════════════════════════════════════════════════════

# ── Main category selector ────────────────────────────────────────────────────
show_main_menu() {
    local items=(
        "🖥️ Terminal"     # Index [0]
        "📂 Explorer"     # Index [1] | Alt_icon = 🗃️
        "🌐 Internet"     # Index [2]
        "💻 Development"  # Index [3]
        "🎨 Graphics"     # Index [4] | Alt_icon = 🖌️
        "🎬 Multimedia"   # Index [5]
        "🎮 Games"        # Index [6] | Alt_icon = 🕹️
        "⚙️ System"        # Index [7]
        "📦 Utilities"    # Index [8]
        "🔌 Power"        # Index [9]
        "❌ Exit"         # Index [9]
    )
    printf '%s\n' "${items[@]}"
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
    local items=(
        " Lock"      # Index [0] | Alt_icon = 󰌾
        "󰗽 Logout"    # Index [1] | Alt_icon = 󰗼
        "󰖔 Suspend"   # Index [2]
        "󰜉 Reboot"    # Index [3]
        "󰐥 Shutdown"  # Index [4]
    )
    printf '%s\n' "${items[@]}"
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
            0)  run_app foot          ;;  # Index [0]
            1)  run_app foot --server ;;  # Index [1]
            2)  run_app footclient    ;;  # Index [2]
            *)  CURRENT_MENU="main"   ;;  # ← Back
        esac

    # ── File managers ─────────────────────────────────────────────────────────
    elif [ "$CURRENT_MENU" = "explorer" ]; then
        CHOICE=$(show_explorer_menu | fuzzel_run)
        case "$CHOICE" in
            0)  run_app  pcmanfm-qt ;;  # Index [0]
            1)  run_term yazi       ;;  # Index [1]
            *)  CURRENT_MENU="main" ;;  # ← Back
        esac

    # ── Browsers and messengers ───────────────────────────────────────────────
    elif [ "$CURRENT_MENU" = "internet" ]; then
        CHOICE=$(show_internet_menu | fuzzel_run)
        case "$CHOICE" in
            0)  run_app firefox          ;;  # Index [0]
            1)  run_app brave            ;;  # Index [1]
            2)  run_app helium-browser   ;;  # Index [2]
            3)  run_app qbittorrent      ;;  # Index [3]
            4)  run_app telegram-desktop ;;  # Index [4]
            *)  CURRENT_MENU="main"      ;;  # ← Back
        esac

    # ── Development tools ─────────────────────────────────────────────────────
    elif [ "$CURRENT_MENU" = "development" ]; then
        CHOICE=$(show_development_menu | fuzzel_run)
        case "$CHOICE" in
            0)  run_app  zed        ;;  # Index [0]
            1)  run_app  code-oss   ;;  # Index [1]
            2)  run_app  featherpad ;;  # Index [2]
            3)  run_term micro      ;;  # Index [3]
            4)  run_app  meld       ;;  # Index [4]
            *)  CURRENT_MENU="main" ;;  # ← Back
        esac

    # ── Image viewers and document readers ───────────────────────────────────
    elif [ "$CURRENT_MENU" = "graphics" ]; then
        CHOICE=$(show_graphics_menu | fuzzel_run)
        case "$CHOICE" in
            0)  run_app oculante    ;;  # Index [0]
            1)  run_app zathura     ;;  # Index [1]
            *)  CURRENT_MENU="main" ;;  # ← Back
        esac

    # ── Media players ─────────────────────────────────────────────────────────
    elif [ "$CURRENT_MENU" = "multimedia" ]; then
        CHOICE=$(show_multimedia_menu | fuzzel_run)
        case "$CHOICE" in
            0)  run_app mpv         ;;  # Index [0]
            *)  CURRENT_MENU="main" ;;  # ← Back
        esac

    # ── Game launchers ────────────────────────────────────────────────────────
    elif [ "$CURRENT_MENU" = "games" ]; then
        CHOICE=$(show_games_menu | fuzzel_run)
        case "$CHOICE" in
            0)  run_app steam -no-cef-sandbox ;;  # Index [0]
            1)  run_app faugus-launcher       ;;  # Index [1]
            2)  run_app heroic                ;;  # Index [2]
            *)  CURRENT_MENU="main"           ;;  # ← Back
        esac

    # ── System utilities ──────────────────────────────────────────────────────
    elif [ "$CURRENT_MENU" = "system" ]; then
        CHOICE=$(show_system_menu | fuzzel_run)
        case "$CHOICE" in
            0)  run_term btop       ;;  # Index [0]
            1)  run_app  gparted    ;;  # Index [1]
            *)  CURRENT_MENU="main" ;;  # ← Back
        esac

    # ── Miscellaneous tools ───────────────────────────────────────────────────
    elif [ "$CURRENT_MENU" = "utilities" ]; then
        CHOICE=$(show_utilities_menu | fuzzel_run)
        case "$CHOICE" in
            0)  run_app qalculate-gtk ;;  # Index [0]
            1)  run_app grimshot      ;;  # Index [1]
            2)  run_app arqiver       ;;  # Index [2]
            *)  CURRENT_MENU="main"   ;;  # ← Back
        esac

    # ── Power management ──────────────────────────────────────────────────────
    elif [ "$CURRENT_MENU" = "power" ]; then
        CHOICE=$(show_power_menu | fuzzel_run)
        case "$CHOICE" in
            0)  loginctl lock-session "$XDG_SESSION_ID"      ;;  # Lock     [0]
            1)  loginctl terminate-session "$XDG_SESSION_ID" ;;  # Logout   [1]
            2)  systemctl suspend                            ;;  # Suspend  [2]
            3)  systemctl reboot                             ;;  # Reboot   [3]
            4)  systemctl poweroff                           ;;  # Shutdown [4]
            *)  CURRENT_MENU="main"                          ;;  # ← Back
        esac
    fi

done
