#!/usr/bin/env bash
set -euo pipefail

echo "== Gamescope TTY Session Deploy =="

# ──────────────────────────────────────────────────────────────
# Step 0: setcap for gamescope
# ──────────────────────────────────────────────────────────────
echo "[0/7] Setting cap_sys_nice for gamescope..."
sudo setcap 'cap_sys_nice=eip' "$(which gamescope)"

# ──────────────────────────────────────────────────────────────
# Step 1: groups
# ──────────────────────────────────────────────────────────────
echo "[1/7] Adding user to required groups..."
sudo usermod -aG audio,games,input,render,tty,video,wheel "$USER"

# ──────────────────────────────────────────────────────────────
# Step 2: sudoers for chvt
# ──────────────────────────────────────────────────────────────
echo "[2/7] Creating sudoers rule for passwordless chvt..."
sudo tee /etc/sudoers.d/90-chvt-nopasswd >/dev/null <<EOF
# Allow user $USER to switch to tty without entering a password
# This is safe for personal use — only affects virtual terminal 3
$USER ALL=(ALL) NOPASSWD: /usr/bin/chvt
EOF

sudo chmod 0440 /etc/sudoers.d/90-chvt-nopasswd

# ──────────────────────────────────────────────────────────────
# Step 3: config file
# ──────────────────────────────────────────────────────────────
echo "[3/7] Creating config file..."
mkdir -p ~/.config/environment.d

cat > ~/.config/environment.d/gamescope-tty-session.conf <<'EOF'
# Native monitor resolution (your current display resolution)
SCREEN_WIDTH=2560
SCREEN_HEIGHT=1600

# Internal resolution (scaling) — lower for better game performance
INTERNAL_WIDTH=1280
INTERNAL_HEIGHT=800

# Refresh rate (your monitor's refresh rate)
REFRESH_RATE=120

# Scaler type (upscaler) — controls how internal resolution is scaled to native
# Supported values:
#   auto     - automatic choice (recommended, usually best quality/performance)
#   integer  - nearest integer scaling (sharp, no blur, good for pixel art)
#   fit      - fit content preserving aspect ratio (black bars if needed)
#   fill     - fill screen, may crop edges
#   stretch  - stretch to fill screen, distorts aspect ratio
SCALER=auto

# Variable Refresh Rate (VRR) — FreeSync / G-Sync Compatible
ADAPTIVE_SYNC=0

# HDR support — enable only if monitor and games support it
ENABLE_HDR=0

# MangoHud overlay (via --mangoapp) — enable for FPS/CPU/GPU overlay
ENABLE_MANGOAPP=0

# Additional Gamescope arguments (only the ones you specified)
GAMESCOPE_EXTRA_ARGS="--xwayland-count 2"
EOF

# ──────────────────────────────────────────────────────────────
# Step 4: scripts
# ──────────────────────────────────────────────────────────────
echo "[4/7] Installing scripts..."
mkdir -p ~/.local/bin

cat > ~/.local/bin/gamescope-tty-session.sh <<'EOF'
#!/usr/bin/env bash
# ~/gamescope-tty-session.sh
# Main script to launch Gamescope + Steam session on dedicated TTY

# ──────────────────────────────────────────────────────────────
# Environment variables — placed at the very beginning
# ──────────────────────────────────────────────────────────────

# Проверяем XDG_RUNTIME_DIR (необходимо для Wayland сокетов и DBus)

#systemctl --user unset-environment DISPLAY XAUTHORITY
#dbus-update-activation-environment --systemd --all

#export XDG_RUNTIME_DIR="/run/user/$(id -u)"
#export XDG_SESSION_DESKTOP="gamescope"
#export XDG_CURRENT_DESKTOP="gamescope"

# Gamescope / Steam specific
export ENABLE_GAMESCOPE_WSI=1
export STEAM_MULTIPLE_XWAYLANDS=1
#export XCURSOR_THEME=steam
#export XCURSOR_SCALE=256

# Qt / GTK / Input method modules (Steam keyboard support)
export QT_IM_MODULE=steam
export GTK_IM_MODULE=Steam
export GTK_USE_PORTAL=0
export GDK_DEBUG=no-portals

# Vulkan / Rendering
export GSK_RENDERER=vulkan
export WLR_RENDERER=vulkan

# Proton / Performance tweaks
export PROTON_USE_NTSYNC=1
export PROTON_FORCE_LARGE_ADDRESS_AWARE=1

# Mesa / Shader cache
export MESA_SHADER_CACHE_MAX_SIZE=20G
export MESA_GLSL_CACHE_MAX_SIZE=20G

# VA-API / Hardware acceleration
export VAAPI_MPEG4_ENABLED=1

# Disable MSAA (performance)
export DRI_NO_MSAA=1

# ──────────────────────────────────────────────────────────────
# Load user configuration
# ──────────────────────────────────────────────────────────────

CONFIG="~/.config/environment.d/gamescope-tty-session.conf"
[[ -f "$CONFIG" ]] && source "$CONFIG"

# ──────────────────────────────────────────────────────────────
# Build Gamescope arguments from config
# ──────────────────────────────────────────────────────────────

RESOLUTION=""
[[ -n "$SCREEN_WIDTH" && -n "$SCREEN_HEIGHT" ]] && RESOLUTION="-W $SCREEN_WIDTH -H $SCREEN_HEIGHT"

INTERNAL_RESOLUTION=""
[[ -n "$INTERNAL_WIDTH" && -n "$INTERNAL_HEIGHT" ]] && INTERNAL_RESOLUTION="-w $INTERNAL_WIDTH -h $INTERNAL_HEIGHT"

REFRESH=""
[[ -n "$REFRESH_RATE" ]] && REFRESH="-r $REFRESH_RATE"

SCALER_OPTION=""
[[ -n "$SCALER" ]] && SCALER_OPTION="-S $SCALER"

# Инициализируем твою переменную
ADAPTIVE_SYNC_OPTION=""
if [[ "$ADAPTIVE_SYNC" == "1" ]]; then
    # Режим VRR (плавная частота)
    ADAPTIVE_SYNC_OPTION="--adaptive-sync"
    export STEAM_GAMESCOPE_VRR_SUPPORTED=1
else
    # Режим Tearing (минимальная задержка без VRR)
    ADAPTIVE_SYNC_OPTION="--immediate-flips"
    export STEAM_GAMESCOPE_TEARING_SUPPORTED=1
    export STEAM_GAMESCOPE_HAS_TEARING_SUPPORT=1
fi

HDR_OPTION=""
if [[ "$ENABLE_HDR" = "1" ]]; then
    HDR_OPTION="--hdr-enabled"
    export ENABLE_HDR_WSI=1
    export DXVK_HDR=1
    export PROTON_ENABLE_HDR=1
    export STEAM_GAMESCOPE_HDR_SUPPORTED=1
fi

EXTRA_ARGS="${GAMESCOPE_EXTRA_ARGS:-}"

MANGOAPP_OPTION=""
if [[ "$ENABLE_MANGOAPP" = "1" ]]; then
    MANGOAPP_OPTION="--mangoapp"
    export STEAM_MANGOAPP_PRESETS_SUPPORTED=1
    export STEAM_USE_MANGOAPP=1
    export STEAM_DISABLE_MANGOAPP_ATOM_WORKAROUND=1
    export STEAM_MANGOAPP_HORIZONTAL_SUPPORTED=1
fi

# ──────────────────────────────────────────────────────────────
# Start falcond if available
# ──────────────────────────────────────────────────────────────

if command -v falcond >/dev/null 2>&1; then
    systemctl --user is-active --quiet falcond.service || systemctl --user start falcond.service
fi

# ──────────────────────────────────────────────────────────────
# Launch Gamescope — each major option on its own line
# ──────────────────────────────────────────────────────────────

exec gamescope --backend drm --rt --steam \
    $RESOLUTION \
    $INTERNAL_RESOLUTION \
    $REFRESH \
    $SCALER_OPTION \
    $ADAPTIVE_SYNC_OPTION \
    $HDR_OPTION \
    $EXTRA_ARGS \
    $MANGOAPP_OPTION \
    -- steam -pipewire-dmabuf -no-cef-sandbox -console -tenfoot
EOF

cat > ~/.local/bin/enter-gamescope-tty-session.sh <<'EOF'
#!/usr/bin/env bash
# ~/enter-gamescope-tty-session.sh
# Switches to tty3 and gracefully logs out from the current KDE session

# Path to temporary file where we store the previous TTY number
TTY_FILE="/tmp/gamescope-tty-previous"

# Save current TTY
echo "$XDG_VTNR" > "$TTY_FILE"

# Switch to tty3 (this changes the active virtual terminal immediately)
sudo chvt 3 || exit 1

# Give the system a moment to settle after switching TTY
#sleep 1

#if [[ -n "$XDG_SESSION_ID" ]]; then
#    loginctl terminate-session "$XDG_SESSION_ID" 2>/dev/null || true
#fi
EOF

cat > ~/.local/bin/leave-gamescope-tty-session.sh <<'EOF'
#!/usr/bin/env bash
# ~/leave-gamescope-tty-session.sh
# Gracefully shuts down Steam and Gamescope, then returns to previous TTY

TTY_FILE="/tmp/gamescope-tty-previous"

echo "Shutting down Steam and Gamescope..."

# Graceful shutdown of Steam first (it's inside Gamescope session)
if pgrep -x steam >/dev/null 2>&1; then
    echo "Sending steam -shutdown..."
    steam -shutdown
fi

# Graceful shutdown of Gamescope
if command -v gamescopectl >/dev/null 2>&1 && pgrep -x gamescope >/dev/null 2>&1; then
    echo "Sending gamescopectl shutdown..."
    gamescopectl shutdown
fi

echo "Waiting for graceful shutdown (5 seconds)..."
sleep 5

# Final forceful kill if anything is still alive
if pgrep -x gamescope >/dev/null 2>&1 || pgrep -x steam >/dev/null 2>&1; then
    echo "Processes still alive → sending SIGKILL..."
    pkill -9 -x steam 2>/dev/null || true
    pkill -9 -x gamescope 2>/dev/null || true
    sleep 2.5
    echo "Cleanup completed."
else
    echo "All processes terminated cleanly."
fi

# Return to previous TTY
if [[ -f "$TTY_FILE" ]]; then
    PREV_TTY=$(cat "$TTY_FILE")
    sudo chvt "$PREV_TTY"
    rm -f "$TTY_FILE"
else
    sudo chvt 1 # Fallback to TTY1
fi
EOF

chmod +x ~/.local/bin/gamescope-tty-session.sh \
         ~/.local/bin/enter-gamescope-tty-session.sh \
         ~/.local/bin/leave-gamescope-tty-session.sh

# ──────────────────────────────────────────────────────────────
# Step 6: Desktop entry
# ──────────────────────────────────────────────────────────────
echo "[5/7] Creating KDE desktop entry..."
mkdir -p ~/.local/share/applications

cat > ~/.local/share/applications/gamescope-tty-session.desktop <<'EOF'
[Desktop Entry]
Name=Gamescope TTY Session
Comment=Switch to dedicated Gamescope + Steam session on tty3
Exec=~/.local/bin/enter-gamescope-tty-session.sh
Icon=steam
Type=Application
Terminal=false
Categories=Game;
StartupNotify=true
EOF

# ──────────────────────────────────────────────────────────────
# Step 5: optional autostart
# ──────────────────────────────────────────────────────────────
echo "[6/7] Optional autostart configuration..."
if command -v fish >/dev/null 2>&1; then
  mkdir -p ~/.config/fish/conf.d
  cat > ~/.config/fish/conf.d/gamescope-tty-session.fish <<'EOF'
# Automatically start Gamescope session only on tty3
# Delay 5 seconds to let the TTY fully initialize
set TTY3 (tty)
if [ "$TTY3" = "/dev/tty3" ]
    sleep 5
    exec ~/.local/bin/enter-gamescope-tty-session.sh
end
EOF
  echo "  - Fish autostart installed: ~/.config/fish/conf.d/gamescope-tty-session.fish"
else
  # Bash fallback
  PROFILE_FILE="$HOME/.bash_profile"
  [[ -f "$HOME/.profile" ]] && PROFILE_FILE="$HOME/.profile"

  if ! grep -q 'exec ~/.local/bin/enter-gamescope-tty-session.sh' "$PROFILE_FILE" 2>/dev/null; then
    cat >> "$PROFILE_FILE" <<'EOF'

# Automatically start Gamescope session only on tty3
# Delay 5 seconds to allow TTY to fully initialize
if [[ "$(tty)" = "/dev/tty3" ]]; then
    sleep 5
    exec ~/.local/bin/enter-gamescope-tty-session.sh
fi
EOF
    echo "  - Bash autostart appended to: $PROFILE_FILE"
  else
    echo "  - Bash autostart already present in: $PROFILE_FILE"
  fi
fi

# ──────────────────────────────────────────────────────────────
# Final
# ──────────────────────────────────────────────────────────────
echo "[7/7] Done."
echo
echo "IMPORTANT: You MUST logout/login or reboot for group changes to take effect."
echo "Launch from KDE menu: Gamescope TTY Session"
