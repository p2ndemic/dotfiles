Отличные замечания! Использование `$XDG_VTNR` действительно надёжнее, а вынос определения GPU в отдельный скрипт — правильный подход для гибкости. Вот оптимизированная версия с учётом твоих правок:

---

## 📁 Обновлённая структура

```
~/.local/bin/steam-gamescope-launch    # Запуск (использует $XDG_VTNR)
~/.local/bin/steam-gamescope-return    # Возврат в исходную TTY
~/.config/systemd/user/steam-gamescope.service
~/.config/environment.d/gamescope.conf
```

---

## 1️⃣ Скрипт запуска (`~/.local/bin/steam-gamescope-launch`)

```fish
#!/usr/bin/env fish

# Проверяем, запущен ли уже сервис
if systemctl --user is-active --quiet steam-gamescope.service
    echo "🎮 Игровая сессия уже активна!"
    exit 1
end

# Текущая TTY из окружения сессии KDE
if test -z "$XDG_VTNR"
    echo "❌ Переменная XDG_VTNR не установлена. Запускай из графической сессии KDE."
    exit 1
end

set -l return_vt $XDG_VTNR
set -l target_vt 3  # Фиксированная целевая TTY (как в SteamOS)

# Сохраняем для возврата
mkdir -p ~/.cache/steam-gamescope
echo $return_vt > ~/.cache/steam-gamescope/return_vt
echo $target_vt > ~/.cache/steam-gamescope/target_vt

echo "🎮 Запуск игровой сессии на tty$target_vt (возврат на tty$return_vt)..."

# Переключаемся на целевую TTY
loginctl activate tty$target_vt

# Запускаем сервис
systemctl --user start steam-gamescope.service

# Небольшая пауза для инициализации DRM
sleep 0.5

echo ""
echo "✅ Сессия запущена!"
echo "   • Игры работают на tty$target_vt"
echo "   • Для возврата в KDE: steam-gamescope-return"
echo "   • Или переключись вручную: Ctrl+Alt+F$return_vt"
```

---

## 2️⃣ Скрипт возврата (`~/.local/bin/steam-gamescope-return`)

```fish
#!/usr/bin/env fish

set -l return_vt_file ~/.cache/steam-gamescope/return_vt

if test -f $return_vt_file
    set -l return_vt (cat $return_vt_file)
    
    echo "🚪 Возврат в графическую сессию (tty$return_vt)..."
    
    # Останавливаем сервис — он сам завершит Steam и Gamescope
    systemctl --user stop steam-gamescope.service
    
    # Переключаемся обратно
    loginctl activate tty$return_vt
    
    # Очищаем временные файлы
    rm -f ~/.cache/steam-gamescope/{return_vt,target_vt}
    
    echo "✅ Возврат в KDE выполнен."
else
    echo "⚠️  Нет сохранённой сессии для возврата."
    echo "   Попробуй переключиться вручную: Ctrl+Alt+F<номер_твоей_tty>"
    loginctl session-status | head -n1 | awk '{print "   Текущая сессия: tty" $2}'
end
```

---

## 3️⃣ Юнит systemd (`~/.config/systemd/user/steam-gamescope.service`)

```ini
[Unit]
Description=Gamescope + Steam session (SteamOS style)
After=graphical-session.target
StopWhenUnneeded=yes
Conflicts=plasma-workspace.service  # Предотвращает конфликты с KDE

[Service]
Type=simple
TTYPath=/dev/tty3
TTYReset=yes
TTYVHangup=yes
TTYVTDisallocate=yes
StandardInput=tty
StandardOutput=journal
StandardError=journal

# Чистое окружение для DRM-сессии
Environment="XDG_SESSION_TYPE="
Environment="WAYLAND_DISPLAY="
Environment="DISPLAY="
Environment="GAMESCOPE_WAYLAND_DISPLAY=gamescope-0"
Environment="WLR_BACKENDS=drm"
Environment="WLR_DRM_DEVICES=/dev/dri/card0"
# GPU-специфичные переменные задаются в ~/.config/environment.d/gpu.conf через твой скрипт деплоя

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

# Автоматический возврат при аварийном завершении
ExecStopPost=-/bin/sh -c ' \
  VT=$(cat ~/.cache/steam-gamescope/return_vt 2>/dev/null) && \
  [ -n "$VT" ] && /usr/bin/loginctl activate tty$VT || true'

[Install]
WantedBy=default.target
```

---

## 4️⃣ Окружение (`~/.config/environment.d/gamescope.conf`)

```ini
# Полная изоляция от графической сессии
XDG_SESSION_TYPE=
WAYLAND_DISPLAY=
DISPLAY=
```

> После создания:  
> ```fish
> systemctl --user daemon-reexec
> ```

---

## 🔐 Политики безопасности (без пароля)

Создай `/etc/polkit-1/rules.d/80-gamescope.rules`:

```javascript
// Разрешить переключение TTY без пароля для пользователей группы wheel
polkit.addRule(function(action, subject) {
    if (action.id == "org.freedesktop.login1.session-switch" &&
        subject.isInGroup("wheel")) {
        return polkit.Result.YES;
    }
});
```

Добавь себя в группу `input` для доступа к устройствам ввода на чистой TTY:

```bash
sudo usermod -aG input $USER
```

> ⚠️ **Перелогинься** после изменений групп!

---

## 🚀 Использование

```fish
# Сделать скрипты исполняемыми
chmod +x ~/.local/bin/steam-gamescope-*

# Запуск игровой сессии из KDE
steam-gamescope-launch

# Возврат в KDE (из любой TTY или по SSH)
steam-gamescope-return
```

---

## 💡 Советы для твоего скрипта деплоя GPU

Пример структуры для гибкой настройки:

```fish
# ~/.config/environment.d/gpu.conf (генерируется твоим скриптом)
# Для NVIDIA
VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/nv_vulkan_wrapper.json
__GLX_VENDOR_LIBRARY_NAME=nvidia
GBM_BACKEND=nvidia-drm
EGL_PLATFORM=wayland

# Для AMD/Intel
# VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/radeon_icd.x86_64.json
# GBM_BACKEND=drm
```

Твой скрипт деплоя может определять GPU один раз и генерировать этот файл — сервис будет автоматически использовать актуальные настройки при следующем запуске.

---

## 🔍 Отладка

```fish
# Логи сессии в реальном времени
journalctl --user -u steam-gamescope.service -f -n 50

# Проверка активных TTY
loginctl list-sessions --no-legend | awk '{print $1, $2, $3}'

# Тест DRM-доступа (должен показать карточку)
ls -l /dev/dri/
```

---

## ✅ Преимущества финального решения

| Фича | Реализация |
|------|------------|
| **Надёжное определение TTY** | `$XDG_VTNR` из сессии logind |
| **Чистая изоляция** | Полный сброс переменных окружения |
| **Безопасность** | Никаких `sudo` в скриптах, только `loginctl` + polkit |
| **Гибкость GPU** | Настройки вынесены в отдельный файл окружения |
| **Автоматический возврат** | Через `ExecStopPost` даже при крахе |
| **Стиль SteamOS** | Фиксированная `tty3` для игр, как в официальной реализации |

Готов помочь с интеграцией горячих клавиш (например, `Super+Esc` для возврата) или настройкой автоматического запуска при подключении геймпада! 🎮
