#!/bin/bash

cpu_usage() {
    read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
    idle_before=$((idle + iowait))
    total_before=$((user + nice + system + idle + iowait + irq + softirq + steal))
    sleep 0.1
    read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
    idle_after=$((idle + iowait))
    total_after=$((user + nice + system + idle + iowait + irq + softirq + steal))
    total_delta=$((total_after - total_before))
    idle_delta=$((idle_after - idle_before))
    [[ "$total_delta" -gt 0 ]] && printf '%s%%' $((100 * (total_delta - idle_delta) / total_delta))
}

gpu_usage() {
    if command -v rocm-smi >/dev/null 2>&1; then
        rocm-smi --showuse --csv 2>/dev/null |
            awk -F, 'NR > 1 {
                gsub(/[[:space:]]/, "", $2)
                if ($2 ~ /^[0-9]+$/ && !found) {
                    printf "%s%%", $2
                    found = 1
                }
            } END { if (!found) printf "--" }'
        return
    fi

    for busy_path in /sys/class/drm/card*/device/gpu_busy_percent; do
        if [[ -r "$busy_path" ]]; then
            printf '%s%%' "$(<"$busy_path")"
            return
        fi
    done

    printf '%s' '--'
}

case "$1" in
    cpu)
        printf '󰻠 CPU %s' "$(cpu_usage)"
        ;;
    gpu)
        printf '󰢮 GPU %s' "$(gpu_usage)"
        ;;
    memory)
        memory=$(awk '/MemTotal:/ { total = $2 } /MemAvailable:/ { available = $2 } END {
            if (total > 0) printf "%d%%", (100 * (total - available) / total)
        }' /proc/meminfo)
        printf ' MEM %s' "${memory:---}"
        ;;
    uptime)
        seconds=$(awk '{ print int($1) }' /proc/uptime)
        days=$((seconds / 86400))
        hours=$(((seconds % 86400) / 3600))
        minutes=$(((seconds % 3600) / 60))
        if [[ "$days" -gt 0 ]]; then
            printf '󰔚 UP %dd %02dh' "$days" "$hours"
        else
            printf '󰔚 UP %02dh %02dm' "$hours" "$minutes"
        fi
        ;;
    network)
        device=$(nmcli -t -f DEVICE,TYPE,STATE device status 2>/dev/null |
            awk -F: '$2 == "wifi" && $3 == "connected" { print $1; exit }')
        ssid=$(nmcli -g GENERAL.CONNECTION device show "$device" 2>/dev/null)
        [[ -n "$ssid" ]] && printf '󰤨 %s' "$ssid" || printf '󰤭 offline'
        ;;
esac
