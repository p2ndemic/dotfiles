Отличное замечание! Резервный вариант через `loginctl` действительно избыточен — в правильно настроенной графической сессии (через SDDM/GDM/etc.) переменная `$XDG_VTNR` всегда присутствует. Вот финальная, максимально чистая версия **steamscope**:

---

## 📁 Структура файлов

```
~/.local/bin/steamscope-launch      # Запуск игровой сессии
~/.local/bin/steamscope-return      # Возврат в исходную сессию
~/.config/systemd/user/steamscope.service
~/.config/environment.d/steamscope.conf
/tmp/steamscope-return_vt           # Временный файл
```

---

## 1️⃣ Скрипт запуска (`~/.local/bin/steamscope-launch`)

```fish
#!/usr/bin/env fish

# Проверяем, запущен ли уже сервис
if systemctl --user is-active --quiet steamscope.service
    echo "🎮 steamscope уже активен!"
    exit 1
end

# Обязательная переменная от дисплей-менеджера
if not set -q XDG_VTNR
    echo "❌ Переменная \$XDG_VTNR не установлена."
    echo "Запускай steamscope из графической сессии (через SDDM/GDM/etc.)."
    exit 1
end

set -l return_vt $XDG_VTNR
set -l target_vt 3  # Фиксированная TTY для игр (как в SteamOS)

# Сохраняем для возврата
echo $return_vt > /tmp/steamscope-return_vt

echo "🎮 Запуск steamscope на tty$target_vt (возврат на tty$return_vt)..."

# Переключаемся на целевую TTY
loginctl activate tty$target_vt

# Запускаем сервис
systemctl --user start steamscope.service

# Пауза для инициализации DRM
sleep 0.5

echo ""
echo "✅ steamscope запущен!"
echo "   • Игровая сессия: tty$target_vt"
echo "   • Возврат: steamscope-return или Ctrl+Alt+F$return_vt"
```

---

## 2️⃣ Скрипт возврата (`~/.local/bin/steamscope-return`)

```fish
#!/usr/bin/env fish

set -l return_vt_file /tmp/steamscope-return_vt

if test -f $return_vt_file
    set -l return_vt (cat $return_vt_file)
    
    echo "🚪 Возврат в графическую сессию (tty$return_vt)..."
    
    # Останавливаем сервис
    systemctl --user stop steamscope.service
    
    # Переключаемся обратно
    loginctl activate tty$return_vt
    
    # Очищаем временный файл
    rm -f /tmp/steamscope-return_vt
    
    echo "✅ Возврат выполнен"
else
    echo "❕ Нет активной сессии steamscope"
    echo "❕ Запусти сначала: steamscope-launch"
end
```

---

## 3️⃣ Юнит systemd (`~/.config/systemd/user/steamscope.service`)

```ini
[Unit]
Description=steamscope: Gamescope + Steam session (SteamOS style)
After=graphical-session.target
StopWhenUnneeded=yes

[Service]
Type=simple
TTYPath=/dev/tty3
TTYReset=yes
TTYVHangup=yes
TTYVTDisallocate=yes
StandardInput=tty
StandardOutput=journal
StandardError=journal

# Чистое окружение для изолированной DRM-сессии
Environment="XDG_SESSION_TYPE="
Environment="WAYLAND_DISPLAY="
Environment="DISPLAY="
Environment="GAMESCOPE_WAYLAND_DISPLAY=gamescope-0"
Environment="WLR_BACKENDS=drm"
Environment="WLR_DRM_DEVICES=/dev/dri/card0"

ExecStart=/usr/bin/gamescope -W 1920 -H 1080 -r 144 -f --steam -- /usr/bin/steam -bigpicture

# Корректное завершение
KillMode=mixed
KillSignal=SIGTERM
TimeoutStopSec=10
Restart=no

# Автоматический возврат даже при аварийном завершении
ExecStopPost=-/bin/sh -c 'VT=$(cat /tmp/steamscope-return_vt 2>/dev/null) && [[ -n "$VT" ]] && /usr/bin/loginctl activate tty$VT || true'

[Install]
WantedBy=default.target
```

---

## 4️⃣ Окружение (`~/.config/environment.d/steamscope.conf`)

```ini
# Полная изоляция от родительской графической сессии
XDG_SESSION_TYPE=
WAYLAND_DISPLAY=
DISPLAY=
```

> Примени изменения:  
> ```fish
> systemctl --user daemon-reexec
> ```

---

## 🔐 Настройка прав (однократно)

```bash
# 1. Разрешить переключение TTY без пароля
sudo tee /etc/polkit-1/rules.d/80-steamscope.rules > /dev/null <<'EOF'
polkit.addRule(function(action, subject) {
    if (action.id == "org.freedesktop.login1.session-switch" &&
        subject.isInGroup("wheel")) {
        return polkit.Result.YES;
    }
});
EOF

# 2. Доступ к устройствам ввода на чистой TTY
sudo usermod -aG input $USER

# 3. Перелогинься!
```

Настройка прав (без пароля для chvt)
1. Добавь себя в группу tty:
```sudo usermod -aG input video render tty $USER```
2. Создай файл /etc/sudoers.d/chvt-nopasswd
```sudo visudo -f /etc/sudoers.d/chvt-nopasswd```
```%wheel ALL=(ALL) NOPASSWD: /usr/bin/chvt```
3. Создай .desktop файл ~/.local/share/applications/steam-gamescope.desktop:
```ini
[Desktop Entry]
Name=Steam (Gamescope)
Comment=Запуск Steam в полноэкранном режиме через Gamescope
Exec=/home/ваш_пользователь/.local/bin/steamscope-launch
Icon=steam
Terminal=false
Type=Application
Categories=Game;
```

Рекомендуемый вариант: бинды без супер-клавиши
Добавь в ~/.config/fish/config.fish:
```
# Запуск steamscope: Ctrl+Alt+O
bind \e\co 'steamscope-launch; commandline -f repaint'

# Возврат в сессию: Ctrl+Alt+L
bind \e\cl 'steamscope-return; commandline -f repaint'

    💡 \e\c = Escape + Control (стандартная кодировка для Alt в терминалах)
    commandline -f repaint — обновляет приглашение после выполнения
```

---

## 🚀 Использование

```fish
chmod +x ~/.local/bin/steamscope-*

# Запуск из ЛЮБОЙ графической сессии
steamscope-launch

# Возврат в исходную сессию
steamscope-return
```


---

## ✅ Итоговая философия решения

| Принцип | Реализация |
|---------|------------|
| **Минимализм** | Только `$XDG_VTNR` — никаких резервных путей |
| **Честность** | Явная ошибка при отсутствии переменной вместо попыток угадать |
| **Универсальность** | Работает в любой среде с правильным окружением (SDDM/GDM/etc.) |
| **Чистота** | Временные файлы только в `/tmp`, никаких кэшей в домашней директории |
| **SteamOS-стиль** | Фиксированная `tty3`, полная изоляция, автоматический возврат |

Готово! Лёгкое, честное и надёжное решение в духе Unix-философии 🐧✨

```
❯ fish_key_reader
Press a key:

bind ctrl-alt-o 'do something'

~
❯ fish_key_reader
Press a key:

bind ctrl-alt-l 'do something'

~
```

```
~/.config/sway/config:
bindsym $mod+Ctrl+Alt+O exec steamscope-hotkey-launch
bindsym $mod+Ctrl+Alt+L exec steamscope-hotkey-return
```


