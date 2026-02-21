#!/usr/bin/env bash
# power-menu — селектор режима питания (tuned-adm + fuzzel --index)

# === Парсинг батареи ===
# 1. Состояние (state)
STATE=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | gawk '/state:/ {print $2}')
# 2. Процент заряда (percentage
PERCENT=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | gawk '/percentage:/ {print $2}')
# 3. Время до разряда/заряда
TIME_TO=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | gawk '/time to (empty|full):/ {print $4}')
# 4. Здоровье аккумулятора (capacity) — округлено до целых
HEALTH=$(LC_ALL=C upower -i /org/freedesktop/UPower/devices/battery_BAT0 | gawk '/capacity:/ {printf "%.0f\n", $2}')
# 5. Полная емкость (energy-full) — округлено до десятых
ENERGY_FULL=$(LC_ALL=C upower -i /org/freedesktop/UPower/devices/battery_BAT0 | gawk '/energy-full:/ {printf "%.1f\n", $2}')
# 6. Кол-во циклов зарядки
CHARGE_CYCLES=$(LC_ALL=C upower -i /org/freedesktop/UPower/devices/battery_BAT0 | gawk '/charge-cycles:/ {print $2}')

if [[ "$STATE" == "discharging" ]]; then
    STATE_ICON=""
    STATE_ARROW="↓"
    STATUS="[discharging]"
    TIME_LABEL="Time remaining"
else
    STATE_ICON=""
    STATE_ARROW="↑"
    STATUS="[charging]   "
    TIME_LABEL="Time until full"
fi

# Текущий профиль tuned
CURRENT_PROFILE=$(tuned-adm active 2>/dev/null | gawk '{print $NF}' || echo "balanced")

case "$CURRENT_PROFILE" in
    powersave)
        SELECT=0
        ;;
    balanced)
        SELECT=1
        ;;
    performance)
        SELECT=2
        ;;
    *)
        SELECT=0
        ;;
esac

# Сообщение (точно как на твоей картинке)
MESG="┌─────────────────────────────────────┐
│ |${STATE_ICON}| State     | ⤍ | ${PERCENT} [${STATE_ARROW}]     |${STATE_ICON}| │
│ || Remaining | ⤍ | ${TIME_TO} hours   || │
│ || Capacity  | ⤍ | ${ENERGY_FULL} Wh     || │
│ || Cycles    | ⤍ | ${CHARGE_CYCLES}         || │
│ || Health    | ⤍ | ${HEALTH}%         || │
│ || Profile   | ⤍ | ${CURRENT_PROFILE}    || │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│ ||    Select power profile     || │
└─────────────────────────────────────┘" 

# К сожалению при вставке эмодзи типа ⚙️ ❤️ в блок --mesg fuzzel падает: https://codeberg.org/dnkl/fuzzel/issues/736
#  State ➟ ⤍ ⭬ 🢒
# 󰁫 Remaining  
#  Health
#  Capacity
#  Profile
#  Select power profile:
# ${STATE_ARROW}



# Формируем список (индекс 0 = Power Saver, индекс 1 = Balanced)
# Функция выводит пункты меню. Порядок строк определяет их будущий индекс (0, 1, 2...)
FN_ENTRIES() {
    echo -e "  |1| Power Save"      # Index [0]
    echo -e "  |2| Balanced"    # Index [1]
    echo -e "  |3| Performance"   # Index [2]
    echo -e "  |3| Max Performance"   # Index [3]
}


# Запуск fuzzel
CHOICE=$(FN_ENTRIES | fuzzel --dmenu \
    --index \
    --hide-prompt \
    --select-index=$SELECT \
    --mesg="$MESG" \
    --mesg-mode=expand \
    --icon-theme="Papirus-Dark" \
    --font="JetBrainsMono Nerd Font Mono:size=18" \
    --minimal-lines
    )

    #--select-index=2 \

case "$CHOICE" in
    0)
        exec tuned-adm profile powersave || tuned-adm profile laptop-battery-powersave &
        notify-send -i battery-caution-symbolic "Tuned" "Power Save активирован ✅"
        ;;
    1)
        exec tuned-adm profile balanced &
        notify-send -i preferences-system-power-management "Tuned" "Balanced активирован ✅"
        ;;
    2)
        tuned-adm profile balanced
        notify-send -i preferences-system-power-management "Tuned" "Balanced активирован ✅"
        ;;
esac
