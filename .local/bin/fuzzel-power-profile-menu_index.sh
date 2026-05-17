#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════
#  fuzzel-power-profile-menu_index.sh
# ══════════════════════════════════════════════════════════════════════

# ── Toggle: kill fuzzel if already running ────────────────────────────
pkill -x fuzzel && exit 0

# ══════════════════════════════════════════════════════════════════════
#  Configuration
# ══════════════════════════════════════════════════════════════════════

# ── Sysfs battery path ────────────────────────────────────────────────
BATTERY_PATH="/sys/class/power_supply/BAT0"

# ── Default Tuned profile if detection fails ──────────────────────────
DEFAULT_PROFILE="balanced"

# ── Font used in the fuzzel window (FontConfig format) ────────────────
FONT="JetBrainsMono Nerd Font Mono:size=18"

# ══════════════════════════════════════════════════════════════════════
#  Notifications
# ══════════════════════════════════════════════════════════════════════

# ── Send desktop notification ─────────────────────────────────────────
send_notification() {
    local body="$1"
    notify-send \
        --urgency=low \
        --expire-time=2000 \
        --app-name="Tuned" \
        --icon="/usr/share/icons/hicolor/scalable/apps/tuned.svg" \
        --transient \
        "Tuned" \
        "$body"
}

# ══════════════════════════════════════════════════════════════════════
#  SysFS
# ══════════════════════════════════════════════════════════════════════

# ── Fetch and parse all battery fields in a single awk pass ───────────
# LC_ALL=C ensures correct number parsing (dot as decimal separator)
get_battery_info() {
    # Читаем значения напрямую из sysfs
    local status=$(<"$BATTERY_PATH/status")
    local capacity=$(<"$BATTERY_PATH/capacity")
    local current_now=$(<"$BATTERY_PATH/current_now")
    local charge_now=$(<"$BATTERY_PATH/charge_now")
    local charge_full=$(<"$BATTERY_PATH/charge_full")
    local charge_full_design=$(<"$BATTERY_PATH/charge_full_design")
    local voltage_min_design=$(<"$BATTERY_PATH/voltage_min_design")
    local cycle_count=$(<"$BATTERY_PATH/cycle_count")

    # Один вызов awk для всей логики и математики
    LC_ALL=C awk -v status="$status" \
                 -v capacity="$capacity" \
                 -v current_now="$current_now" \
                 -v charge_now="$charge_now" \
                 -v charge_full="$charge_full" \
                 -v charge_full_design="$charge_full_design" \
                 -v voltage_min_design="$voltage_min_design" \
                 -v cycle_count="$cycle_count" \
    'BEGIN {
        # 1. State
        bat_status = (status == "Charging" ? status "   " : status)

        # 2. Percentage
        bat_percent = capacity

        # 3. Time to empty/full
        bat_time = ""

        if (current_now > 0) {
            if (status == "Discharging") {
                time_minutes = (charge_now / current_now) * 60
            } else if (status == "Charging") {
                time_minutes = ((charge_full - charge_now) / current_now) * 60
            }

            # Округляем до целых
            time_minutes_str = sprintf("%.0f", time_minutes)

            # Добавляем пробелы в зависимости от кол-ва знаков
            if (length(time_minutes_str) == 1) {
                bat_time = time_minutes_str " min  "
            } else if (length(time_minutes_str) == 2) {
                bat_time = time_minutes_str " min "
            } else {
                bat_time = time_minutes_str " min"
            }
        } else {
            bat_time = "...     "
        }

        # 4. Energy-full [Wh]: charge_full [µAh] * voltage_min_design [µV] / 1000000000000
        bat_energy_full = sprintf("%.1f", (charge_full * voltage_min_design) / 1e12)

        # 5. Charge cycles
        bat_charge_cycles = cycle_count

        # 6. Health / Capacity
        bat_health = sprintf("%.0f", (charge_full / charge_full_design) * 100)

        # Print
        print bat_status "|" bat_percent "|" bat_time "|" bat_energy_full "|" bat_charge_cycles "|" bat_health
    }'
}

# ── Parse battery and profile info ────────────────────────────────────
IFS='|' read -r BAT_STATUS BAT_PERCENT BAT_TIME BAT_ENERGY_FULL BAT_CHARGE_CYCLES BAT_HEALTH <<< "$(get_battery_info)"

# ── Set icons and status label based on charging state ────────────────
if [[ "$BAT_STATUS" == "Discharging" ]]; then
    BAT_STATUS_ICON=""
    BAT_STATUS_ARROW="↓"
else
    BAT_STATUS_ICON=""
    BAT_STATUS_ARROW="↑"
fi

# ══════════════════════════════════════════════════════════════════════
#  Tuned
# ══════════════════════════════════════════════════════════════════════

# ── Fetch current active tuned profile ────────────────────────────────
get_current_profile() {
    tuned-adm active 2>/dev/null | awk '{print $NF}' || echo "$DEFAULT_PROFILE"
}
CURRENT_PROFILE="$(get_current_profile)"

# ── Determine current profile index for fuzzel pre-selection ──────────
case "$CURRENT_PROFILE" in
    powersave)
        SELECTION_INDEX=0
        CURRENT_PROFILE_LABEL="Powersave  "
        ;;
    balanced)
        SELECTION_INDEX=1
        CURRENT_PROFILE_LABEL="Balanced   "
        ;;
    performance)
        SELECTION_INDEX=2
        CURRENT_PROFILE_LABEL="Performance"
        ;;
    max_perf)
        SELECTION_INDEX=3
        CURRENT_PROFILE_LABEL="Max Perf   "
        ;;
    *)
        SELECTION_INDEX=1
        CURRENT_PROFILE_LABEL="Balanced   "
        ;;
esac

# ══════════════════════════════════════════════════════════════════════
#  Fuzzel
# ══════════════════════════════════════════════════════════════════════

# ── Fuzzel Message ────────────────────────────────────────────────────
MESG=" ┌─────────────────────────────────────┐
 │ |${BAT_STATUS_ICON}| State     | ⤍ | ${BAT_STATUS} |${BAT_STATUS_ICON}| │
 │ |%| Percent   | ⤍ | ${BAT_PERCENT} %        |%| │
 │ || Remaining | ⤍ | ${BAT_TIME}     || │
 │ || Capacity  | ⤍ | ${BAT_ENERGY_FULL} Wh     || │
 │ || Cycles    | ⤍ | ${BAT_CHARGE_CYCLES}         || │
 │ || Health    | ⤍ | ${BAT_HEALTH} %        || │
 │ || Profile   | ⤍ | ${CURRENT_PROFILE_LABEL} || │
 └─────────────────────────────────────┘
 ┌─────────────────────────────────────┐
 │ ||    Select power profile     || │
 └─────────────────────────────────────┘"

# ── Fuzzel menu ───────────────────────────────────────────────────────
show_profile_menu() {
    local items=(
        "   |1| Powersave"         # Index [0]
        "   |2| Balanced"          # Index [1]
        "   |3| Performance"       # Index [2]
        "   |4| Max Performance"   # Index [3]
    )
    printf '%s\n' "${items[@]}"
}

# ── Fuzzel Wrapper ────────────────────────────────────────────────────
fuzzel_run() {
    fuzzel \
        --dmenu \
        --index \
        --font="$FONT" \
        --hide-prompt \
        --minimal-lines \
        --select-index="$SELECTION_INDEX" \
        --mesg="$MESG" \
        --mesg-mode=expand
}

# ══════════════════════════════════════════════════════════════════════
#  Main Execution: Action Handler
# ══════════════════════════════════════════════════════════════════════

# ── Capture selection and execute action ──────────────────────────────
CHOICE=$(show_profile_menu | fuzzel_run)

case "$CHOICE" in
    0)  # [0] Powersave
        tuned-adm profile powersave &
        send_notification "Powersave profile activated ✅"
        ;;
    1)  # [1] Balanced
        tuned-adm profile balanced &
        send_notification "Balanced profile activated ✅"
        ;;
    2)  # [2] Performance
        tuned-adm profile performance &
        send_notification "Performance profile activated ✅"
        ;;
    3)  # [3] Max Perf
        tuned-adm profile max_perf &
        send_notification "Max Performance profile activated ✅"
        ;;
    *)  # Cancel / Close
        exit 0
        ;;
esac
#CURRENT_PROFILE=$(tuned-adm active 2>/dev/null | gawk '{print $NF}' || echo "balanced")
# ───────────────────────────────────────────── #
