# The Sway configuration file in ~/.config/sway/config calls this script.
# You should see changes to the status bar after saving this script.
# If not, do "killall swaybar" and $mod+Shift+c to reload the configuration.

# The abbreviated weekday (e.g., "Sat"), followed by the ISO-formatted date
# like 2018-10-06 and the time (e.g., 14:01). Check `man date` on how to format
# time and date.
date_formatted=$(date "+%a %F %H:%M")

# find the right path with
#   upower --enumerate | grep BAT
bat_path='/org/freedesktop/UPower/devices/battery_BAT0'
battery_info=$(upower --show-info $bat_path | awk '/state|percentage/ {print $2}')
battery_icon='🔋'

sinks=$(
  pactl list sinks |
  awk '''
    /Mute/ {icon = ($2 == "yes"? "🔇": "🔊")}
    /Description:/ {$1 = ""; desc = $0}
    /front-left:|aux0:/ {vol = (" L: " $5 " R: " $12)}
    /Active Port:/ {port = $3}
    /Formats/ {print icon desc " (" port ")" " 🎶 " vol}
  '''
)

# check if app is using mic
mic_app=$(
  pactl list source-outputs |
  awk '/application.process.binary / {print "🎤 " $3}' |
  sed 's/"//g' | uniq
)

bt=$(rfkill | awk '/bluetooth/ {print $4 " " $5}')
if [[ "$bt" == "unblocked unblocked" ]]; then
  bt_icon="ᛒ"
fi

brightness_path='/sys/class/backlight/intel_backlight'
brightness=$(cat $brightness_path/brightness)
# max_brightness=$(cat $brightness_path/max_brightness)
max_brightness=120000
brightness_percent=$(python -c "print(int($brightness / $max_brightness * 100))")%
brightness_icon="🔆"

networks=$(~/.config/sway/get_active_networks.py | grep -v -E 'tun0|lo')
networks=$(awk 'NF > 0 {print "🚀 " $0}'<<<"${networks}")

# Additional emojis and characters for the status bar:
# Electricity: ⚡ ↯ ⭍ 🔌
# Audio: 🔈 🔊 🎧 🎶 🎵 🎤
# Separators: \| ❘ ❙ ❚
# Misc: 🐧 💎 💻 💡 ⭐ 📁 ↑ ↓ ✉ ✅ ❎
echo $networks $mic_app $sinks $brightness_icon $brightness_percent \
     $battery_icon $battery_info 🐧 $date_formatted $bt_icon
