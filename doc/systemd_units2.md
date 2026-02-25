```markdown
# README: Полный конспект по systemd unit-файлам (.service)
## Лучшие практики 2026 | Для Wayland, Sway, labwc, niri, mango и обычных систем

**Автор:** Grok + команда  
**Версия:** 1.0 (февраль 2026)  
**Цель:** Разобраться от А до Я, почему одни сервисы используют `wayland-session@*.target`, другие — `graphical-session.target`, а третьи — `multi-user.target`.  
**Как использовать:**  
```bash
# Скопируй этот файл как README.md или readme.txt
# Создавай .service в ~/.config/systemd/user/ (user) или /etc/systemd/system/ (system)
systemctl --user daemon-reload          # после изменений
systemctl --user enable --now my.service
journalctl --user -u my.service -f      # логи
```

---

## 1. Основы systemd: логика от нуля (пошагово)

### Шаг 1. Что такое unit?
- **Unit** — это конфиг-файл, которым управляет systemd.
- Главные типы:
  - `.service` — запускает процесс
  - `.target` — "цель", группа юнитов (аналог runlevel)
  - `.slice` — ограничение ресурсов (CPU, память)
  - `.timer`, `.path`, `.socket` и др.

### Шаг 2. Три обязательные секции
```ini
[Unit]          # ← метаданные + зависимости + условия
[Service]       # ← как запускать/перезапускать
[Install]       # ← когда включать автоматически
```

### Шаг 3. Главная магия — зависимости
| Директива      | Что делает                                      | Когда использовать                     |
|----------------|-------------------------------------------------|----------------------------------------|
| `After=`       | Запускать **после** этого юнита                 | Всегда (порядок)                       |
| `Before=`      | Запускать **до**                                | Редко                                  |
| `Wants=`       | "Хочу, чтобы запустился" (слабая связь)        | Soft-зависимость                       |
| `Requires=`    | Жёстко требует (если упал — падает и я)        | Критические сервисы                    |
| `PartOf=`      | "Я — часть этого target" (при stop — stop меня)| Wayland-сессии                         |
| `WantedBy=`    | При `enable` создаёт symlink в `.wants/`        | Автозапуск                             |

**Важно:** `PartOf=` + `WantedBy=` = сервис живёт и умирает вместе с сессией.

### Шаг 4. Targets (цели)
- `multi-user.target` — серверный режим (без графики)
- `graphical.target` — полная графика
- `graphical-session.target` — **стандартная** для всех DE/WM
- `wayland-session@sway.desktop.target` — **специфичный** target от uwsm/sway-session и т.д. (для sway, labwc, niri, mango)
- `default.target` — symlink на то, что выбрано в сессии пользователя

### Шаг 5. User vs System сервисы
- **User** (`~/.config/systemd/user/`):
  - Запускаются от твоего пользователя
  - `WantedBy=default.target` или `graphical-session.target`
  - Не требуют sudo
- **System** (`/etc/systemd/system/`):
  - От root
  - `WantedBy=multi-user.target`

### Шаг 6. Что будет, если **НЕ** указывать секцию `[Install]`?
- Сервис **НЕ** будет запускаться автоматически при загрузке.
- `systemctl enable` создаст только пустой symlink (или выдаст предупреждение).
- Можно запускать только вручную: `systemctl --user start my.service`
- Полезно для:
  - one-shot скриптов, которые вызываются из другого сервиса
  - тестовых сервисов
  - сервисов, управляемых таймером/сокетом

---

## 2. Варианты сервисов (готовые шаблоны)

### Вариант 1: Mako (notification daemon) — привязка к конкретным Wayland-сессиям
```ini
[Unit]
Description=Lightweight notification daemon for Wayland
Documentation=man:mako(1) man:makoctl(1)

# Живём и умираем вместе с сессией
PartOf=wayland-session@sway.desktop.target
PartOf=wayland-session@labwc.desktop.target
PartOf=wayland-session@mango.desktop.target
PartOf=wayland-session@niri.desktop.target

# Запускаемся ТОЛЬКО после полной инициализации сессии
After=wayland-session@sway.desktop.target
After=wayland-session@labwc.desktop.target
After=wayland-session@mango.desktop.target
After=wayland-session@niri.desktop.target

[Service]
Type=exec
ExecStart=/usr/bin/mako
Restart=on-failure
Slice=background-graphical.slice   # ← лёгкий фон, не жрёт ресурсы

[Install]
WantedBy=wayland-session@sway.desktop.target
WantedBy=wayland-session@labwc.desktop.target
WantedBy=wayland-session@mango.desktop.target
WantedBy=wayland-session@niri.desktop.target
```
**Плюсы:** Работает только в нужных WM, не запускается в KDE/GNOME.

### Вариант 2: Waybar — тот же подход + app-graphical.slice + ExecReload
```ini
[Service]
Type=exec
ExecStart=waybar --log-level off
ExecReload=kill -SIGUSR2 $MAINPID   # перезагрузка конфига
Restart=on-failure
Slice=app-graphical.slice           # ← для GUI-приложений в фоне
```
(Остальное — как в варианте 1)

### Вариант 3: Mako через `graphical-session.target` + положительные условия
```ini
[Unit]
PartOf=graphical-session.target
After=graphical-session.target

# Запускать ТОЛЬКО в этих DE
ConditionEnvironment=|XDG_CURRENT_DESKTOP=sway
ConditionEnvironment=|XDG_CURRENT_DESKTOP=labwc
ConditionEnvironment=|XDG_CURRENT_DESKTOP=mangowc
ConditionEnvironment=|XDG_CURRENT_DESKTOP=niri

[Install]
WantedBy=graphical-session.target
```
**Когда использовать:** Если не хочешь создавать отдельные `wayland-session@` targets.

### Вариант 4: Через отрицание (исключаем KDE/GNOME)
```ini
[Unit]
PartOf=graphical-session.target
After=graphical-session.target

ConditionEnvironment=!XDG_CURRENT_DESKTOP=KDE
ConditionEnvironment=!XDG_CURRENT_DESKTOP=GNOME
ConditionEnvironment=!XDG_CURRENT_DESKTOP=gamescope
ConditionEnvironment=!XDG_CURRENT_DESKTOP=gamescope:wlroots

[Install]
WantedBy=graphical-session.target
```
**Минус:** Если появится новый DE — может запуститься случайно.

### Вариант 5: Фоновые сервисы `Type=simple` (пример: ydotoold)
```ini
[Unit]
Description=Starts ydotoold service

[Service]
Type=simple          # ← процесс сразу считается запущенным
Restart=always
ExecStart=/usr/bin/ydotoold
ExecReload=/usr/bin/kill -HUP $MAINPID
KillMode=process
TimeoutSec=180

[Install]
WantedBy=default.target   # или graphical-session.target
```

### Вариант 6: Пользовательские one-shot сервисы
```ini
[Unit]
Description=Auto Wi-Fi network scan using iwctl
After=network.target

[Service]
Type=oneshot                     # ← выполнился → завершён
RemainAfterExit=yes              # ← считается "активным" после выхода
ExecStart=%h/.local/bin/iwctl-auto-scan.sh

[Install]
WantedBy=default.target
```
`%h` = HOME пользователя.

### Вариант 7: Системные one-shot сервисы (примеры)
**Пример 1:** Одноразовая настройка после загрузки
```ini
[Unit]
Description=One-time system tuning after boot
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/system-tune.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

**Пример 2:** Обновление сертификатов Let's Encrypt
```ini
ExecStart=/usr/bin/certbot renew --quiet --deploy-hook "systemctl reload nginx"
```

**Особенность:** Такие сервисы часто используются в `/etc/systemd/system/` и запускаются **один раз** за загрузку.

### Вариант 8: Пользовательские сервисы с разрешением менять приоритет (gamescope, wine, etc.)
```ini
[Service]
Type=exec
ExecStart=/usr/bin/gamescope -- %COMMAND%

# Разрешаем приложению самому поднимать nice/realtime
AmbientCapabilities=CAP_SYS_NICE
CapabilityBoundingSet=CAP_SYS_NICE
# (опционально) LimitRTPRIO=99
# (опционально) Nice=-10   ← базовый приоритет
```

**Почему нужно:** Gamescope хочет realtime scheduling. Без `AmbientCapabilities` ядро откажет.

### Вариант 9: Системные сервисы с nice-привилегиями (пример: аудио-демон или rtkit)
```ini
[Unit]
Description=High-priority audio service
After=sound.target
PartOf=multi-user.target

[Service]
Type=simple
ExecStart=/usr/bin/my-audio-daemon
Restart=always

# Привилегии
CapabilityBoundingSet=CAP_SYS_NICE CAP_IPC_LOCK
AmbientCapabilities=CAP_SYS_NICE CAP_IPC_LOCK
Nice=-20

[Install]
WantedBy=multi-user.target
```

---

## 3. Полезные команды (шпаргалка)

```bash
# Перезагрузка конфигов
systemctl --user daemon-reload

# Включить + сразу запустить
systemctl --user enable --now mako.service

# Посмотреть зависимости
systemctl --user list-dependencies graphical-session.target

# Логи
journalctl --user -u waybar -f -n 100
```

---

**Готово!**  
Теперь у тебя есть универсальный шаблон под любой сценарий: от лёгкого уведомлялки в Sway до системного one-shot скрипта с realtime-привилегиями.

Если что-то не работает — пиши `journalctl -b -p err` и ищи красные строки.  
Удачи в конфигурировании!
```

Скопируй весь текст выше в файл `readme.txt` или `README.md` — будет красиво отформатировано в любом редакторе/терминале.  
Если нужно добавить примеры или поправить — говори! 🚀
