# =============================================
#    UWSM
# =============================================
# Ref: https://github.com/Vladimir-csp/uwsm
# Ref: https://wiki.archlinux.org/title/Universal_Wayland_Session_Manager
# =============================================

if [ -n "$XDG_SESSION_TYPE" ] || [ -z "$DISPLAY" ]; then
    if uwsm check may-start && uwsm select; then
        uwsm start default
    fi
fi
