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

vol=$(
  pacmd list-sinks |
  awk '/muted/ {print $2 == "yes"? "🔇": "🔉"};
  /front-left:/ {print " L: " $5 " R: " $12}' | sort
)

# check if app is using mic
mic_app=$(
  pactl list source-outputs |
  awk '/application.process.binary / {print "🎤 " $3}' |
  sed 's/"//g' | uniq | grep -v 'pavucontrol'
)

bt=$(rfkill | awk '/bluetooth/ {print $4 " " $5}')
if [[ "$bt" == "unblocked unblocked" ]]; then
  bt_icon="ᛒ"
fi

brightness=$(brightnessctl | awk '/Current/ {print $4}' | sed 's/[()]//g')
brightness_icon="🔆"

networks=$(nmcli connection show --active | grep -E -v 'tun0|NAME' | awk '{print $1}')
if [[ "${networks}" != "" ]]; then network_icon="💻"; fi

# Additional emojis and characters for the status bar:
# Electricity: ⚡ ↯ ⭍ 🔌
# Audio: 🔈 🔊 🎧 🎶 🎵 🎤
# Separators: \| ❘ ❙ ❚
# Misc: 🐧 💎 💻 💡 ⭐ 📁 ↑ ↓ ✉ ✅ ❎
echo $mic_app $network_icon $networks $vol $brightness_icon $brightness \
     $battery_icon $battery_info 🐧 $date_formatted $bt_icon
