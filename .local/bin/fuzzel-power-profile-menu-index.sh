#!/usr/bin/env bash
# fuzzel-power-profile-menu.sh — селектор режима питания (upower + fuzzel + upower)

# Если fuzzel уже запущен, закрываем его и выходим
pkill -x fuzzel && exit 0

# ---------------------------
# Получение данных батареи
# ---------------------------
# Извлекаем все нужные поля за один проход awk и формируем переменные окружения
# LC_ALL=C -> Устанавливаем локаль для корректного парсинга чисел (точка как разделитель)
# Это позволяет корректно производить округление и также заменяет запятую (,) на точку (.) в выводах с десятичными числами
BATTERY_OUTPUT=$(LC_ALL=C upower -i /org/freedesktop/UPower/devices/battery_BAT0 2>/dev/null)

BATTERY_VARS=$(echo "$BATTERY_OUTPUT" | gawk '
    /state:/                  { STATE = $2 }
    /percentage:/             { PERCENT = sprintf("%-3s", $2) }
    /time to (empty|full):/   {
        unit = ($5 == "hours") ? "h"   \
             : ($5 == "minutes") ? "min" \
             : $5
        TIME_TO = sprintf("%-8s", $4 " " unit)
    }
    /energy-full:/            { ENERGY_FULL = sprintf("%.1f %s", $2, $3) }
    /charge-cycles:/          { CHARGE_CYCLES = $2 }
    /capacity:/               { HEALTH = sprintf("%.0f", $2) }

    END {
    print STATE "|" PERCENT "|" TIME_TO "|" ENERGY_FULL "|" CHARGE_CYCLES "|" HEALTH
    }
')

# Разбираем всё за один раз
IFS='|' read -r STATE PERCENT TIME_TO ENERGY_FULL CHARGE_CYCLES HEALTH <<< "$BATTERY_VARS"

# ────────────────────────────────── #
# IFS='|'
# read смотрит на строку и разделяет её по символу |:
# "charging|85%|1.5 h|50.0 Wh|300|95"
# Теперь переменные готовы к использованию в скрипте:
# echo $STATE        # charging
# echo $PERCENT      # 85%
# echo $TIME_TO      # 1.5 h
# echo $ENERGY_FULL  # 50.0 Wh
# echo $CHARGE_CYCLES # 300
# echo $HEALTH       # 95
# ────────────────────────────────── #

# ---------------------------
# Определение текущего профиля tuned
# ---------------------------
CURRENT_PROFILE=$(tuned-adm active 2>/dev/null | gawk '{print $NF}' || echo "balanced")

# ---------------------------
# Кастомные уведомления
# ---------------------------
fn_notify() {
    local BODY="$1"
    notify-send \
        --urgency=low \
        --expire-time=2000 \
        --app-name=Tuned \
        --icon="/usr/share/icons/hicolor/scalable/apps/tuned.svg" \
        --transient \
        "Tuned" \
        "$BODY"
}

# ---------------------------
# Формирование строки состояния батареи
# ---------------------------
if [[ "$STATE" == "discharging" ]]; then
    STATE_ICON=""
    STATE_ARROW="↓"
    STATUS="Discharging"
else
    STATE_ICON=""
    STATE_ARROW="↑"
    STATUS="Charging   "
fi

# ---------------------------
# Определение индекса выбранного профиля для fuzzel
# ---------------------------
CURRENT_PROFILE_STR=""
case "$CURRENT_PROFILE" in
    powersave)
        SELECTION_INDEX=0
        CURRENT_PROFILE_STR="Powersave  "
        ;;
    balanced)
        SELECTION_INDEX=1
        CURRENT_PROFILE_STR="Balanced   "
        ;;
    performance)
        SELECTION_INDEX=2
        CURRENT_PROFILE_STR="Performance"
        ;;
    max_perf)
        SELECTION_INDEX=3
        CURRENT_PROFILE_STR="Max Perf   "
        ;;
    *)
        SELECTION_INDEX=1
        CURRENT_PROFILE_STR="Balanced   "
        ;;
esac

# ---------------------------
# Текст сообщения, отображаемого в fuzzel
# ---------------------------
MESG=" ┌─────────────────────────────────────┐
 │ |${STATE_ICON}| State     | ⤍ | ${STATUS} |${STATE_ICON}| │
 │ |%| Percent   | ⤍ | ${PERCENT}         |%| │
 │ || Remaining | ⤍ | ${TIME_TO}    || │
 │ || Capacity  | ⤍ | ${ENERGY_FULL}     || │
 │ || Cycles    | ⤍ | ${CHARGE_CYCLES}         || │
 │ || Health    | ⤍ | ${HEALTH}%         || │
 │ || Profile   | ⤍ | ${CURRENT_PROFILE_STR} || │
 └─────────────────────────────────────┘
 ┌─────────────────────────────────────┐
 │ ||    Select power profile     || │
 └─────────────────────────────────────┘"

# К сожалению при вставке эмодзи типа ⚙️ ❤️ в блок --mesg fuzzel падает: https://codeberg.org/dnkl/fuzzel/issues/736
# Дополнительные иконки 󰁫 ➟ ⤍ ⭬ 🢒 

# ---------------------------
# Сборка параметров Fuzzel в единый массив
# Порядок: режим dmenu, индекс, шрифт, позиция, скрыть ввод, авто-высота, ширина, отступы
# ---------------------------

FUZZEL_OPTS=(
    --dmenu
    --index
    --font="JetBrainsMono Nerd Font Mono:size=18"
    --hide-prompt
    --minimal-lines
    --mesg="$MESG"
    --mesg-mode=expand
    #--width 40
)
#--horizontal-pad=160 \
#--vertical-pad=20 \
#--line-height=34
#--mesg-mode=expand \

# ---------------------------
# Формирование пунктов меню (индексы 0..3)
# ---------------------------
fn_entries() {
    echo -e "   |1| Powersave"        # Index [0]
    echo -e "   |2| Balanced"         # Index [1]
    echo -e "   |3| Performance"      # Index [2]
    echo -e "   |4| Max Performance"  # Index [3]
}

# ---------------------------
# Запуск fuzzel с меню выбора профиля
# ---------------------------
FUZZEL_CHOICE=$(fn_entries | fuzzel "${FUZZEL_OPTS[@]}")

# ---------------------------
# Активация выбранного профиля
# ---------------------------
case "$FUZZEL_CHOICE" in
    0)
        tuned-adm profile powersave &
        fn_notify "Powersave profile activated ✅"
        ;;
    1)
        tuned-adm profile balanced &
        fn_notify "Balanced profile activated 🚀"
        ;;
    2)
        tuned-adm profile balanced &
        #fn_notify "Performance profile activated 🚀"
        ;;
    3)
        tuned-adm profile balanced &
        #fn_notify "Max Performance profile activated 🚀"
        ;;
esac
