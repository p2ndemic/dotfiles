Есть несколько вариантов создания сервисов:

1. 
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


2. Тоже самое что 1, только с Slice=app-graphical.slice для графических приложений который работают в фоне и кастомным ExecReload
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


3. 

[Unit]
Description=Lightweight notification daemon for Wayland
Documentation=man:mako(1) man:makoctl(1)

# Stop and restart the service whenever the specific graphical session stops or restarts
PartOf=graphical-session.target

# Start the service strictly after the specific session has fully initialized
After=graphical-session.target

# Strictly restrict execution to the required desktop environments (preventing launch in KDE/GNOME)
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
# Enable auto-start by creating symlinks in the .wants/ directory of these specific targets
WantedBy=graphical-session.target




4. Тоже самое что и 3, только через отрицание !XDG_CURRENT_DESKTOP

[Unit]
Description=Lightweight notification daemon for Wayland
Documentation=man:mako(1) man:makoctl(1)

# Stop and restart the service whenever the specific graphical session stops or restarts
PartOf=graphical-session.target

# Start the service strictly after the specific session has fully initialized
After=graphical-session.target

# 
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
# Enable auto-start by creating symlinks in the .wants/ directory of these specific targets
WantedBy=graphical-session.target


5. Фоновые сервисы с Type=simple

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


6. Пользовательские oneshot сервисы

[Unit]
Description=Auto Wi-Fi network scan using iwctl
# Note: User services can't strictly depend on system services via After=
# but iwd usually starts much earlier, so this is generally safe.
After=network.target

[Service]
Type=oneshot
# Use the full path to your script in ~/.local/bin
ExecStart=%h/.local/bin/iwctl-auto-scan.sh

[Install]
WantedBy=default.target



7. Системные oneshot сервисы, расскажи про них с примерами


8. Пользовательские сервисы где разрешаем приложению изменять приоритет. Например чтобы gamescope мог сам себе повышать права.


9. Системные сервисы с WantedBy=multi-user.target и CapabilityBoundingSet=CAP_SYS_NICE AmbientCapabilities=CAP_SYS_NICE


Задача, создай текстовый readme.txt и опиши все это, с комментами и примерами чтобы было понятно. Красово оформи все.
