# Вариант 1: через and и not set -q (рекомендуемый fish-стиль, очень читаемо)
#if status is-login
#    and test "$XDG_SESSION_TYPE" = tty
#    and not set -q WAYLAND_DISPLAY
#    if uwsm check may-start; and uwsm select
#        exec uwsm start default
#    end
#end

# Вариант 2: через and и test -z (более POSIX-подобный стиль)
#if status is-login
#    and test "$XDG_SESSION_TYPE" = tty
#    and test -z "$WAYLAND_DISPLAY"
#    if uwsm check may-start; and uwsm select
#        exec uwsm start default
#    end
#end

# Вариант 3: через && и not set -q (активный, короткий, современный bash-like стиль)
if status --is-login && test "$XDG_SESSION_TYPE" = tty && not set -q WAYLAND_DISPLAY
    # Проверяем, что мы в login-оболочке + чистый TTY + графическая сессия ещё не запущена
    # not set -q WAYLAND_DISPLAY DISPLAY → обе переменные не установлены
    if uwsm check may-start && uwsm select
        # uwsm разрешает запуск и успешно выбрал сессию
        exec uwsm start default    # заменяем текущую оболочку на uwsm
    end
end

# Вариант 4: через && и test -z (компактный, привычный для ex-bash пользователей)
#if status --is-login && test "$XDG_SESSION_TYPE" = tty && test -z "$WAYLAND_DISPLAY"
#    if uwsm check may-start && uwsm select
#        exec uwsm start default
#    end
#end
