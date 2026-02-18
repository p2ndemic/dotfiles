#!/bin/bash

# Параметры
BIN_DIR="$HOME/.local/bin"
APP_DIR="$HOME/.local/share/applications"
FISH_CONF="$HOME/.config/fish/config.fish"
USER_NAME=$(whoami)

# Создаем директории, если их нет
mkdir -p "$BIN_DIR"
mkdir -p "$APP_DIR"

echo "🚀 Начинаем деплой Steam-TTY для пользователя $USER_NAME..."

# --- НОВОЕ: Запрос имени пользователя для автологина ---
echo -n -e "${BLUE}👤 Введите имя пользователя для автологина на TTY$TARGET_TTY [$USER_NAME]: ${NC}"
read INPUT_USER
# Если ввод пустой, используем текущего пользователя
AUTOLOGIN_USER=${INPUT_USER:-$USER_NAME}
echo -e "${GREEN}Используем пользователя: $AUTOLOGIN_USER${NC}"

# ----------------------------------------------------------------
# 1. Создаем скрипт: open-steamscope.fish
# ----------------------------------------------------------------
cat <<EOF > "$BIN_DIR/open-steamscope.fish"
#!/usr/bin/fish
set -l target_tty 3
set -l current_tty \$XDG_VTNR
set -l temp_file "/tmp/steam_tty_back"

echo \$current_tty > \$temp_file
echo "TTY \$current_tty сохранен. Переходим на TTY \$target_tty..."

sudo chvt \$target_tty
sudo openvt -s -c \$target_tty -- sudo -u $USER_NAME -i /usr/bin/fish -c "$BIN_DIR/steamscope-tty-engine.fish"
EOF

# ----------------------------------------------------------------
# 2. Создаем скрипт: steamscope-tty-engine.fish
# ----------------------------------------------------------------
cat <<EOF > "$BIN_DIR/steamscope-tty-engine.fish"
#!/usr/bin/fish
set -l SETENV_VARS \\
    --setenv=MANGOHUD=0

set -l GAMESCOPE_OPTS \\\
    --force-grab-cursor

echo "Сессия Gamescope активна. Используй 'leave-steamscope' для выхода."

systemd-inhibit --why="Gaming on TTY3" --who="Steamscope" --what="idle:sleep" \\
    systemd-run --user --scope --collect \\
    --unit=steam-gamescope-session \\
    --description="Steam Gamescope Session" \\
    \$SETENV_VARS \\
    gamescope \$GAMESCOPE_OPTS -- steam -gamepadui
EOF

# ----------------------------------------------------------------
# 3. Создаем скрипт: leave-steamscope.fish
# ----------------------------------------------------------------
cat <<EOF > "$BIN_DIR/leave-steamscope.fish"
#!/usr/bin/fish
set -l temp_file "/tmp/steam_tty_back"

if not test -f \$temp_file
    echo "Ошибка: Файл возврата \$temp_file не найден!"
    return 1
end

set -l back_tty (cat \$temp_file)
echo "Завершение и возврат на TTY \$back_tty..."

systemctl --user stop steam-gamescope-session.scope 2>/dev/null
rm \$temp_file

sudo chvt \$back_tty
exit
EOF

# Даем права на исполнение
chmod +x "$BIN_DIR/open-steamscope.fish"
chmod +x "$BIN_DIR/steamscope-tty-engine.fish"
chmod +x "$BIN_DIR/leave-steamscope.fish"

# ----------------------------------------------------------------
# 4. Настройка Sudoers (права на переключение TTY без пароля)
# ----------------------------------------------------------------
echo "🔐 Настройка прав sudo (потребуется пароль)..."
SUDOERS_FILE="/etc/sudoers.d/tty-games"
SUDO_CONTENT="$USER_NAME ALL=(ALL) NOPASSWD: /usr/bin/chvt, /usr/bin/openvt, /usr/bin/systemd-inhibit"

echo "$SUDO_CONTENT" | sudo tee "$SUDOERS_FILE" > /dev/null

# ----------------------------------------------------------------
# 6. НОВОЕ: Настройка Автологина в TTY (Systemd override)
# ----------------------------------------------------------------
echo -e "${GREEN}Настройка автологина для $AUTOLOGIN_USER на TTY$TARGET_TTY...${NC}"
TTY_CONF_DIR="/etc/systemd/system/getty@tty$TARGET_TTY.service.d"

sudo mkdir -p "$TTY_CONF_DIR"
cat <<EOF | sudo tee "$TTY_CONF_DIR/override.conf" > /dev/null
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin $AUTOLOGIN_USER --noclear %I \$TERM
EOF

# ----------------------------------------------------------------
# 7. Создание Desktop-файла для Fuzzel/Launcher
# ----------------------------------------------------------------
cat <<EOF > "$APP_DIR/steam-tty.desktop"
[Desktop Entry]
Name=Steam (TTY Mode)
Comment=Launch Gamescope on TTY3
Exec=$BIN_DIR/open-steamscope.fish
Icon=steam
Terminal=true
Type=Application
Categories=Game;
EOF

# ----------------------------------------------------------------
# 8. Интеграция в Fish (Алиасы и Бинды)
# ----------------------------------------------------------------
echo "🐟 Настройка Fish конфигурации..."

# Добавляем алиасы, если их еще нет
if ! grep -q "alias open-steamscope" "$FISH_CONF"; then
    echo "alias open-steamscope='$BIN_DIR/open-steamscope.fish'" >> "$FISH_CONF"
    echo "alias leave-steamscope='$BIN_DIR/leave-steamscope.fish'" >> "$FISH_CONF"
fi

# Добавляем функцию биндов, если её нет, или вставляем в существующую
if ! grep -q "function fish_user_key_bindings" "$FISH_CONF"; then
    cat <<EOF >> "$FISH_CONF"

function fish_user_key_bindings
    bind \e\cO open-steamscope
    bind \e\cL leave-steamscope
end
EOF
else
    echo "⚠️  Функция fish_user_key_bindings уже существует. Добавь бинды вручную:"
    echo "   bind \e\cO open-steamscope"
    echo "   bind \e\cL leave-steamscope"
fi

echo "✅ Деплой завершен! Перезапусти терминал или выполни 'source $FISH_CONF'"
