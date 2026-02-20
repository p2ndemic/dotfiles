#!/usr/bin/env bash
# power-menu — селектор режима питания (tuned-adm + fuzzel --index)

#1. Состояние (state)
# upower -i /org/freedesktop/UPower/devices/battery_BAT0 | gawk '/state:/ {print $2}'
#2. Процент заряда (percentage)
# upower -i /org/freedesktop/UPower/devices/battery_BAT0 | gawk '/percentage:/ {print $2}'
#3. Полная емкость (energy-full) — округлено до десятых
# LC_ALL=C upower -i /org/freedesktop/UPower/devices/battery_BAT0 | gawk '/energy-full:/ {printf "%.1f\n", $2}'
#4. Здоровье аккумулятора (capacity) — округлено до десятых
# LC_ALL=C upower -i /org/freedesktop/UPower/devices/battery_BAT0 | gawk '/capacity:/ {printf "%.1f\n", $2}'
#4.1 Здоровье аккумулятора (capacity) — целое число
# LC_ALL=C upower -i /org/freedesktop/UPower/devices/battery_BAT0 | gawk '/capacity:/ {printf "%.0f\n", $2}'
# 5. Время до разряда/заряда
# upower -i /org/freedesktop/UPower/devices/battery_BAT0 | gawk '/time to (empty|full):/ {print $4}'

# === Парсинг батареи ===
STATE=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | gawk '/state:/ {print $2}')
PERCENT=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | gawk '/percentage:/ {print $2}')
TIME_TO=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | gawk '/time to (empty|full):/ {print $4}')
HEALTH=$(LC_ALL=C upower -i /org/freedesktop/UPower/devices/battery_BAT0 | gawk '/capacity:/ {printf "%.0f\n", $2}')
ENERGY=$(LC_ALL=C upower -i /org/freedesktop/UPower/devices/battery_BAT0 | gawk '/energy-full:/ {printf "%.1f\n", $2}')

if [[ "$STATE" == "Discharging" ]]; then
    STATE_ICON="🔋"
    STATUS="Discharging"
    TIME_LABEL="Time remaining"
else
    STATE_ICON="🔌"
    STATUS="Charging"
    TIME_LABEL="Time until full"
fi

# Сообщение (точно как на твоей картинке)
MESG="Status ➟ Discharging
Persent ➟ 72%
Remaining ➟ 1h 37m
Health ➟ 90%
Capacity ➟ 58.7 Wh
Profile ➟ Balanced

⚡  Режим питания"


# Текущий профиль tuned
CURRENT_PROFILE=$(tuned-adm active 2>/dev/null | gawk '{print $NF}' || echo "balanced")

# Индекс для предвыбора
case "$CURRENT_PROFILE" in
    *powersave*) SELECT=0 ;;
    *balanced*)  SELECT=1 ;;
    *performance*) SELECT=2 ;;
    *) SELECT=0 ;;
esac

# Формируем список (индекс 0 = Power Saver, индекс 1 = Balanced)
# Функция выводит пункты меню. Порядок строк определяет их будущий индекс (0, 1, 2...)
FN_ENTRIES() {
    echo "    Lock"      # Index [0]
    echo " 󰗼   Logout"    # Index [1]
    echo " 󰖔   Suspend"   # Index [2]
    echo " 󰜉   Reboot"    # Index [3]
    echo " 󰐥   Shutdown"  # Index [4]
}

# Запуск fuzzel
CHOICE=$(FN_ENTRIES | fuzzel --dmenu \
    --index \
    --select-index=2 \
    --hide-prompt \
    --mesg "$MESG" \
    --width=42 \
    --lines=4 \
    --icon-theme="Papirus" \
    --font="JetBrainsMono Nerd Font:size=13.5" \
    --border-radius=14 \
    --horizontal-pad=36 \
    --vertical-pad=22 \
    --inner-pad=14
    #--background="1e1e2eff" \
    #--text-color="cdd6f4ff" \
    #--selection-color="1e1e2eff" \
    #--selection-text-color="1e1e2eff" \
    #--match-color="fab387ff"
    )

case "$CHOICE" in
    0)
        tuned-adm profile powersave || tuned-adm profile laptop-battery-powersave
        notify-send -i battery-caution-symbolic "Tuned" "Power Saver активирован ✅"
        ;;
    1)
        tuned-adm profile balanced
        notify-send -i preferences-system-power-management "Tuned" "Balanced активирован ✅"
        ;;
esac
