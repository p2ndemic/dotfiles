Отлично! Вот полностью универсальное решение под названием **steamscope** — без привязки к KDE, с временными файлами в `/tmp` и готовое к использованию в любой графической среде (Wayland/X11):

---

## 📁 Структура файлов

```
~/.local/bin/steamscope-launch      # Запуск игровой сессии
~/.local/bin/steamscope-return      # Возврат в исходную сессию
~/.config/systemd/user/steamscope.service
~/.config/environment.d/steamscope.conf
/tmp/steamscope-return_vt           # Временный файл (создаётся автоматически)
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

# Определяем исходную TTY (из графической сессии)
if set -q XDG_VTNR
    set -l return_vt $XDG_VTNR
else
    # Резервный вариант: через loginctl
    set -l session (loginctl session-status | head -n1 | awk '{print $1}')
    set -l return_vt (loginctl show-session $session -p VTNumber --value)
    
    if test -z "$return_vt"
        echo "❌ Не удалось определить исходную TTY."
        echo "Убедись, что запускаешь из графической сессии (есть \$XDG_VTNR)."
        exit 1
    end
end

set -l target_vt 3  # Фиксированная TTY для игр (как в SteamOS)

# Сохраняем для возврата
echo $return_vt > /tmp/steamscope-return_vt
echo $target_vt > /tmp/steamscope-target_vt

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
echo "   • Возврат в сессию: steamscope-return или Ctrl+Alt+F$return_vt"
```

---

## 2️⃣ Скрипт возврата (`~/.local/bin/steamscope-return`)

```fish
#!/usr/bin/env fish

set -l return_vt_file /tmp/steamscope-return_vt

if test -f $return_vt_file
    set -l return_vt (cat $return_vt_file)
    
    echo "🚪 Возврат в графическую сессию (tty$return_vt)..."
    
    # Останавливаем сервис — он сам завершит Steam и Gamescope
    systemctl --user stop steamscope.service
    
    # Переключаемся обратно
    loginctl activate tty$return_vt
    
    # Очищаем временные файлы
    rm -f /tmp/steamscope-{return_vt,target_vt}
    
    echo "✅ Возврат выполнен."
else
    echo "⚠️  Нет активной сессии steamscope."
    echo "   Текущие сессии:"
    loginctl list-sessions --no-legend | while read -l line
        set parts (string split ' ' $line)
        echo "   • tty$(loginctl show-session $parts[1] -p VTNumber --value): $parts[3]"
    end
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

# GPU-настройки подгружаются из ~/.config/environment.d/gpu.conf (твой скрипт деплоя)

ExecStart=/usr/bin/gamescope \
  -W 1920 -H 1080 \
  -r 144 \
  -f \
  --steam \
  -- \
  /usr/bin/steam -bigpicture

# Корректное завершение
KillMode=mixed
KillSignal=SIGTERM
TimeoutStopSec=10
Restart=no

# Автоматический возврат даже при аварийном завершении
ExecStopPost=-/bin/sh -c ' \
  VT=$(cat /tmp/steamscope-return_vt 2>/dev/null) && \
  [ -n "$VT" ] && /usr/bin/loginctl activate tty$VT || true'

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

# 3. Перелогинься для применения групп и политик!
```

---

## 🚀 Использование (универсально для любого DE/WM)

```fish
# Сделать исполняемыми
chmod +x ~/.local/bin/steamscope-*

# Запуск из ЛЮБОЙ графической сессии (KDE, GNOME, Sway, Hyprland...)
steamscope-launch

# Возврат в исходную сессию
steamscope-return
```

---

## 💡 `.desktop` файл для меню приложений

`~/.local/share/applications/steamscope.desktop`:
```ini
[Desktop Entry]
Name=steamscope
Comment=Полноэкранная игровая сессия Steam (SteamOS style)
Exec=steamscope-launch
Icon=steam
Terminal=false
Type=Application
Categories=Game;
StartupNotify=false
```

Обнови кэш:
```fish
# Для KDE
kbuildsycoca5

# Для GNOME
update-desktop-database ~/.local/share/applications
```

---

## 🔍 Отладка

```fish
# Статус сервиса
systemctl --user status steamscope

# Логи в реальном времени
journalctl --user -u steamscope -f

# Проверка активных сессий
loginctl list-sessions --no-legend | while read -l s; set p (string split ' ' $s); echo "tty$(loginctl show-session $p[1] -p VTNumber --value): $p[3]"; end
```

---

## ✅ Ключевые преимущества решения

| Фича | Реализация |
|------|------------|
| **Универсальность** | Работает в любой графической среде (KDE/GNOME/Sway/Hyprland) |
| **Чистота** | Полная изоляция окружения через `environment.d` |
| **Безопасность** | Никаких `sudo`, только `loginctl` + polkit |
| **Надёжность** | Автоматический возврат даже при крахе через `ExecStopPost` |
| **SteamOS-стиль** | Фиксированная `tty3` для игр, как в официальной реализации |
| **Временные файлы** | `/tmp/steamscope-*` — автоматически очищаются при перезагрузке |

---

## ⚠️ Важно помнить

1. **Переменная `$XDG_VTNR`** должна быть установлена в твоей графической сессии (обычно так и есть при запуске через display manager).

2. **NVIDIA**: Убедись, что в параметрах ядра есть `nvidia-drm.modeset=1` для корректной работы DRM на отдельной TTY.

3. **Тестовый запуск**: Перед первым использованием проверь работу Gamescope:
   ```fish
   gamescope -t  # тестовый режим на текущей TTY
   ```

Готово! Теперь у тебя есть полностью универсальное, надёжное и стильное решение в духе SteamOS 🎮✨
