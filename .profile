# =============================================
#    UWSM
# =============================================
# Ref: https://github.com/Vladimir-csp/uwsm
# Ref: https://wiki.archlinux.org/title/Universal_Wayland_Session_Manager
# =============================================

if [ -n "$XDG_SESSION_TYPE" ] || [ -z "$WAYLAND_DISPLAY" ]; then
    if uwsm check may-start && uwsm select; then
        uwsm start default
    fi
fi

# Проверяем, что не запущен ни X11, ни Wayland
#if [ -z "$XDG_SESSION_TYPE" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
#    uwsm check may-start && uwsm select && exec uwsm start default
#fi
