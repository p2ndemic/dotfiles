╔═══════════════════════════════════════════════════════════════════════════════╗
║                  SYSTEMD UNIT ФАЙЛЫ: ПОДРОБНЫЙ КОНСПЕКТ                       ║
╚═══════════════════════════════════════════════════════════════════════════════╝

Данный документ описывает различные варианты создания сервисов в systemd (как
пользовательских, так и системных), объясняет логику работы unit-файлов,
ключевые директивы и особенности, а также разбирает приведённые примеры.

────────────────────────────────────────────────────────────────────────────────
1. ОСНОВНЫЕ ПОНЯТИЯ
────────────────────────────────────────────────────────────────────────────────

Systemd — система инициализации и менеджер сервисов в Linux. Все объекты,
которыми управляет systemd, описываются в unit-файлах. Основные типы юнитов:
  • service — сервис (запускаемый процесс);
  • target — группа юнитов (аналог runlevel);
  • socket — сокет;
  • timer — таймер (аналог cron);
  • slice — группа для управления ресурсами (cgroups);
  • и другие.

Расположение unit-файлов:
  • Системные: /etc/systemd/system/, /usr/lib/systemd/system/
  • Пользовательские: ~/.config/systemd/user/, /etc/systemd/user/

Запуск пользовательских сервисов происходит при старте пользовательской сессии
(обычно через systemd --user менеджер).

────────────────────────────────────────────────────────────────────────────────
2. СТРУКТУРА UNIT-ФАЙЛА
────────────────────────────────────────────────────────────────────────────────

Типовой unit-файл состоит из трёх основных секций:

[Unit]        → общая информация и зависимости
[Service]     → настройки запуска (только для service)
[Install]     → привязка к targets (для автоматического запуска)

2.1 Секция [Unit]
   • Description=          — краткое описание
   • Documentation=        — ссылки на документацию (man, https)
   • PartOf=               — остановить/перезапустить юнит вместе с указанным
   • After= / Before=      — порядок запуска (строгий)
   • Requires= / Wants=    — жёсткие/мягкие зависимости (Requires — юнит должен
                              успешно запуститься, иначе текущий не стартует)
   • BindsTo=              — сильнее Requires: если привязанный юнит падает,
                              текущий тоже останавливается
   • Conflicts=            — взаимное исключение
   • Condition...=         — условия запуска (ConditionEnvironment,
                              ConditionPathExists, ConditionHost и т.д.)

2.2 Секция [Service]
   • Type=                  — способ запуска:
        - simple       — процесс не форкается (ExecStart — основной процесс)
        - exec         — аналогично simple, но считается запущенным после fork
                         и exec (более новый)
        - forking      — процесс форкается, родитель завершается
        - oneshot      — однократное действие (обычно для скриптов)
        - dbus         — ожидает регистрации на D-Bus
        - notify       — уведомляет через sd_notify
   • ExecStart=             — команда запуска (абсолютный путь)
   • ExecReload=            — команда перезагрузки конфигурации (kill -HUP и т.п.)
   • Restart=               — политика перезапуска (no, on-success, on-failure,
                              on-abnormal, on-watchdog, always)
   • RestartSec=            — пауза перед перезапуском
   • KillMode=              — как убивать процесс (control-group, process, mixed,
                              none)
   • TimeoutSec=            — таймаут на остановку/запуск
   • Slice=                  — имя slice (cgroup), в котором запускать сервис
   • CapabilityBoundingSet=  — ограничение возможностей (capabilities) для процесса
   • AmbientCapabilities=    — дополнительные capabilities, передаваемые процессу
   • Environment=            — переменные окружения

2.3 Секция [Install]
   • WantedBy=              — создаёт симлинк в .wants/ указанного target,
                              обеспечивая автоматический запуск при активации target
   • RequiredBy=            — аналогично, но жёсткая зависимость
   • Alias=                  — альтернативное имя
   • Also=                   — установить вместе с другими юнитами

Если секция [Install] отсутствует, юнит не будет включён ни в один target,
следовательно, не запустится автоматически при старте системы/сессии.
Его можно запустить только вручную (systemctl start) или через зависимости
от других юнитов (например, если на него есть Requires= из другого юнита).

────────────────────────────────────────────────────────────────────────────────
3. ПОНЯТИЕ TARGET И ЗАВИСИМОСТИ
────────────────────────────────────────────────────────────────────────────────

Target — это группа юнитов, которая может быть активирована (запущена). При
запуске target systemd запускает все юниты, которые имеют WantedBy= или
RequiredBy= на этот target (через симлинки в .wants/ или .requires/).

Примеры стандартных target:
  • graphical-session.target   — пользовательская графическая сессия
  • default.target             — цель по умолчанию (аналог runlevel 5)
  • multi-user.target          — многопользовательский режим без графики
  • wayland-session@.target     — параметризованный target для конкретного WM

Параметризованные юниты (например, wayland-session@sway.desktop.target)
позволяют создавать экземпляры для разных окружений.

Директива PartOf= связывает жизненные циклы: если основной юнит (target)
останавливается или перезапускается, все помеченные PartOf тоже останавливаются
или перезапускаются. Это полезно для сервисов, которые должны работать только
в рамках конкретной сессии.

────────────────────────────────────────────────────────────────────────────────
4. РАЗБОР ПРИМЕРОВ
────────────────────────────────────────────────────────────────────────────────

Пример 1: mako – Жесткая привязка к таргетам сессий (UWSM)
Этот подход идеален, если ваш дистрибутив или дисплейный менеджер использует шаблонные таргеты вида wayland-session@<wm>.desktop.target (например, через UWSM).
────────────────────────────────────────────────────────────────────────────────
[Unit]
Description=Lightweight notification daemon for Wayland
Documentation=man:mako(1) man:makoctl(1)
# Stop and restart the service whenever the specific graphical session stops or restarts
PartOf=wayland-session@sway.desktop.target
PartOf=wayland-session@labwc.desktop.target
PartOf=wayland-session@mango.desktop.target
PartOf=wayland-session@niri.desktop.target
# Start the service strictly after the specific session has fully initialized
After=wayland-session@sway.desktop.target
After=wayland-session@labwc.desktop.target
After=wayland-session@mango.desktop.target
After=wayland-session@niri.desktop.target

[Service]
Type=exec
ExecStart=/usr/bin/mako
Restart=on-failure
Slice=background-graphical.slice

[Install]
# Enable auto-start by creating symlinks in the .wants/ directory of these specific targets
WantedBy=wayland-session@sway.desktop.target
WantedBy=wayland-session@labwc.desktop.target
WantedBy=wayland-session@mango.desktop.target
WantedBy=wayland-session@niri.desktop.target
────────────────────────────────────────────────────────────────────────────────

Комментарии:
  • PartOf и After перечисляют несколько таргетов — сервис будет привязан к
    каждому из них. При запуске любого из указанных target сервис запустится
    после него (After), а при остановке target — сервис тоже остановится (PartOf).
  • Type=exec — современная альтернатива simple, процесс не должен форкаться.
  • Restart=on-failure — перезапускать при ненулевом коде возврата или сигнале.
  • Slice=background-graphical.slice — помещает сервис в группу управления
    ресурсами для фоновых графических задач (обычно задаётся администратором).
  • WantedBy= — при включении сервиса создаются симлинки в .wants/ указанных
    target, поэтому сервис будет автоматически запускаться при старте любой из
    этих сессий.
────────────────────────────────────────────────────────────────────────────────

Пример 2: waybar – аналогично, но с ExecReload и другим slice
────────────────────────────────────────────────────────────────────────────────
[Unit]
Description=Highly customizable Wayland bar for Sway and Wlroots based compositors.
Documentation=man:waybar(5)
# Stop and restart the service whenever the specific graphical session stops or restarts
PartOf=wayland-session@sway.desktop.target
PartOf=wayland-session@labwc.desktop.target
PartOf=wayland-session@mango.desktop.target
PartOf=wayland-session@niri.desktop.target
# Start the service strictly after the specific session has fully initialized
After=wayland-session@sway.desktop.target
After=wayland-session@labwc.desktop.target
After=wayland-session@mango.desktop.target
After=wayland-session@niri.desktop.target

[Service]
Type=exec
ExecStart=waybar --log-level off
ExecReload=kill -SIGUSR2 $MAINPID
Restart=on-failure
Slice=app-graphical.slice

[Install]
# Enable auto-start by creating symlinks in the .wants/ directory of these specific targets
WantedBy=wayland-session@sway.desktop.target
WantedBy=wayland-session@labwc.desktop.target
WantedBy=wayland-session@mango.desktop.target
WantedBy=wayland-session@niri.desktop.target
────────────────────────────────────────────────────────────────────────────────

Комментарии:
  • ExecReload определяет команду для перезагрузки конфигурации (обычно
    посылает сигнал процессу). systemctl reload waybar вызовет эту команду.
  • Slice=app-graphical.slice — предполагается, что waybar требует больше
    ресурсов или интерактивен, поэтому относится к группе приложений,
    а не фоновых задач.

────────────────────────────────────────────────────────────────────────────────

Универсальная привязка с фильтрацией (Белый и Черный списки)

Самый переносимый (portable) вариант. Мы привязываемся к универсальному graphical-session.target, который есть в любом дистрибутиве, а фильтруем запуск через переменные окружения.

Вариант 3: Белый список (Логическое ИЛИ |)
────────────────────────────────────────────────────────────────────────────────
[Unit]
Description=Lightweight notification daemon for Wayland
Documentation=man:mako(1) man:makoctl(1)
PartOf=graphical-session.target
After=graphical-session.target
ConditionEnvironment=|XDG_CURRENT_DESKTOP=sway
ConditionEnvironment=|XDG_CURRENT_DESKTOP=labwc
ConditionEnvironment=|XDG_CURRENT_DESKTOP=mangowc
ConditionEnvironment=|XDG_CURRENT_DESKTOP=niri

[Service]
Type=exec
ExecStart=/usr/bin/mako
Restart=on-failure
Slice=background-graphical.slice

[Install]
WantedBy=graphical-session.target

Комментарии:
  • PartOf и After привязаны к общему graphical-session.target, что проще.
  • ConditionEnvironment=|... — условие выполняется, если переменная окружения
    XDG_CURRENT_DESKTOP равна одному из указанных значений. Вертикальная черта
    означает логическое ИЛИ между условиями.
  • Таким образом сервис запустится только в нужных окружениях (sway, labwc и т.д.),
    даже если target graphical-session общий.
  • WantedBy=graphical-session.target — включается при старте любой графической
    сессии, но из-за ConditionEnvironment фактически запустится не везде.
────────────────────────────────────────────────────────────────────────────────
Вариант 4: Черный список (Отрицание !)
────────────────────────────────────────────────────────────────────────────────
[Unit]
Description=Lightweight notification daemon for Wayland
Documentation=man:mako(1) man:makoctl(1)
PartOf=graphical-session.target
After=graphical-session.target
ConditionEnvironment=!XDG_CURRENT_DESKTOP=KDE
ConditionEnvironment=!XDG_CURRENT_DESKTOP=GNOME
ConditionEnvironment=!XDG_CURRENT_DESKTOP=gamescope
ConditionEnvironment=!XDG_CURRENT_DESKTOP=gamescope:wlroots

[Service]
Type=exec
ExecStart=/usr/bin/mako
Restart=on-failure
Slice=background-graphical.slice

[Install]
WantedBy=graphical-session.target

Комментарии:
  • ! означает отрицание. Сервис будет запущен только если переменная
    XDG_CURRENT_DESKTOP НЕ равна указанным значениям.
  • Такой подход позволяет исключить нежелательные окружения, но может быть
    менее надёжным, если появятся новые окружения с неучтёнными именами.
────────────────────────────────────────────────────────────────────────────────
Сценарий 5: Классические фоновые сервисы (Type=simple)

Для демонов, которые просто висят в фоне и не привязаны жестко к графике.
────────────────────────────────────────────────────────────────────────────────
[Unit]
Description=Starts ydotoold service

[Service]
Type=simple
Restart=always
ExecStart=/usr/bin/ydotoold
ExecReload=/usr/bin/kill -HUP $MAINPID
KillMode=process
TimeoutSec=180

[Install]
WantedBy=default.target

Комментарии:
  • Type=simple — процесс не форкается, systemd считает его запущенным сразу
    после ExecStart.
  • Restart=always — перезапускать при любом завершении (кроме остановки
    администратором).
  • KillMode=process — при остановке сервиса убивать только основной процесс,
    а не всю контрольную группу (осторожно: могут остаться дочерние процессы).
  • TimeoutSec=180 — максимальное время ожидания остановки/запуска.
  • WantedBy=default.target — запускается при старте пользовательской сессии
    (обычно default.target — это графический сеанс).
────────────────────────────────────────────────────────────────────────────────

Одноразовые задачи (Type=oneshot)

oneshot используется для скриптов, которые должны выполнить задачу и завершиться. Systemd будет ждать их полного завершения, прежде чем запускать следующие зависимые юниты.

Вариант 6: Пользовательский oneshot
────────────────────────────────────────────────────────────────────────────────
[Unit]
Description=Auto Wi-Fi network scan using iwctl
After=network.target

[Service]
Type=oneshot
ExecStart=%h/.local/bin/iwctl-auto-scan.sh

[Install]
WantedBy=default.target

Комментарии:
  • Type=oneshot — сервис выполняет однократное действие (скрипт) и завершается.
    Systemd ожидает завершения и считает юнит успешным, если код возврата 0.
  • %h — подстановка пути к домашней директории пользователя.
  • After=network.target — запускается после достижения network.target
    (в пользовательском контексте network.target может быть не так строг,
    но обычно работает).
  • WantedBy=default.target — запускается при старте сессии.
────────────────────────────────────────────────────────────────────────────────

Вариант 7: Системный oneshot
Системные oneshot-сервисы (лежат в /etc/systemd/system/) часто используются администраторами для разовой настройки железа при загрузке ОС.
────────────────────────────────────────────────────────────────────────────────
Системные oneshot-сервисы часто используются для задач инициализации, очистки,
настройки оборудования перед запуском основных сервисов.
────────────────────────────────────────────────────────────────────────────────
Пример: очистка временного каталога при загрузке
[Unit]
Description=Clean temporary directory
Before=local-fs.target
Wants=local-fs.target

[Service]
Type=oneshot
ExecStart=/usr/bin/rm -rf /tmp/*
RemainAfterExit=yes   # после выполнения сервис считается активным (для зависимостей)

[Install]
WantedBy=sysinit.target
────────────────────────────────────────────────────────────────────────────────
Другой пример: запуск скрипта настройки сети
────────────────────────────────────────────────────────────────────────────────
[Unit]
Description=Custom network setup
After=network-pre.target
Before=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/setup-network.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
────────────────────────────────────────────────────────────────────────────────
Комментарии:
  • В системных юнитах таргеты более стандартизированы: multi-user.target,
    graphical.target, sysinit.target и т.д.
  • Oneshot удобен для задач, которые должны выполниться один раз при загрузке
    или перед запуском других сервисов.
  • RemainAfterExit=yes позволяет помечать юнит как активный даже после
    завершения ExecStart (полезно, если другие юниты требуют его).

Пример 8: пользовательский сервис с возможностью повышения приоритета
────────────────────────────────────────────────────────────────────────────────
[Unit]
Description=Gamescope compositor
After=graphical-session.target
PartOf=graphical-session.target

[Service]
Type=exec
ExecStart=/usr/bin/gamescope -- %command%
Restart=on-failure
Slice=app-graphical.slice
# Разрешаем gamescope изменять приоритет (nice) и устанавливать реальное время
AmbientCapabilities=CAP_SYS_NICE
CapabilityBoundingSet=CAP_SYS_NICE

[Install]
WantedBy=graphical-session.target
────────────────────────────────────────────────────────────────────────────────
Комментарии:
  • AmbientCapabilities=CAP_SYS_NICE — позволяет процессу использовать
    системные вызовы, требующие этой capability (например, setpriority,
    sched_setscheduler и т.д.).
  • CapabilityBoundingSet=CAP_SYS_NICE — ограничивает максимальный набор
    capabilities, которые может получить процесс (здесь только CAP_SYS_NICE).
  • Без этих настроек процесс не сможет поднять себе приоритет (nice -20),
    даже если запущен от пользователя.
  • В пользовательских сервисах capabilities требуют, чтобы systemd --user
    имел соответствующие права (обычно это возможно, если сессия запущена
    через user@.service с необходимыми разрешениями).

Пример 9: системный сервис с multi-user.target и capabilities
────────────────────────────────────────────────────────────────────────────────
[Unit]
Description=Low-latency audio service
After=multi-user.target

[Service]
Type=simple
ExecStart=/usr/bin/my-audio-daemon
Restart=on-failure
# Даём возможность повышать приоритет и использовать реальное время
AmbientCapabilities=CAP_SYS_NICE CAP_SYS_TIME
CapabilityBoundingSet=CAP_SYS_NICE CAP_SYS_TIME

[Install]
WantedBy=multi-user.target

Комментарии:
  • В системном контексте capabilities работают напрямую (процесс запускается
    от root, но может ограничить себя через bounding set).
  • CAP_SYS_TIME позволяет изменять системное время.
  • WantedBy=multi-user.target — запускается при входе в многопользовательский
    режим (обычно перед стартом графики).

────────────────────────────────────────────────────────────────────────────────
5. ЧТО БУДЕТ, ЕСЛИ НЕ УКАЗЫВАТЬ [Install]?
────────────────────────────────────────────────────────────────────────────────

Если в unit-файле отсутствует секция [Install], systemd не создаёт симлинки
в .wants/ или .requires/ каталогах target'ов. Это означает:

  • Юнит не запустится автоматически при старте системы или сессии.
  • Его можно запустить только вручную командой systemctl start <unit>.
  • Если другой юнит имеет Requires= или Wants= на этот юнит, то он может
    запуститься автоматически при запуске зависимого юнита.
  • Юнит может быть запущен через socket-активацию (если есть соответствующий
    socket unit) или по таймеру.

Таким образом, [Install] нужен для включения юнита в стандартные механизмы
автозапуска.

────────────────────────────────────────────────────────────────────────────────
6. ЗАКЛЮЧЕНИЕ
────────────────────────────────────────────────────────────────────────────────

Выбор типа сервиса и директив зависит от назначения:
  • Для графических приложений, которые должны жить в рамках сессии,
    используйте PartOf=graphical-session.target (или конкретных wayland-сессий)
    и WantedBy= соответствующих target.
  • Для фоновых процессов, не требующих графики, можно использовать
    default.target или multi-user.target.
  • Для однократных задач — Type=oneshot.
  • Для ограничения по окружению — ConditionEnvironment.
  • Для управления ресурсами — Slice=.
  • Для дополнительных привилегий — AmbientCapabilities и CapabilityBoundingSet.

Всегда проверяйте синтаксис и корректность путей. Используйте systemd-analyze
verify для проверки unit-файлов.

Документация: man systemd.unit, man systemd.service, man systemd.target,
man systemd.exec, man capabilities.

────────────────────────────────────────────────────────────────────────────────
© 2025 | Составлено для ознакомления с примерами создания systemd-сервисов.
