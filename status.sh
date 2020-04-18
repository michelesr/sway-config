# The Sway configuration file in ~/.config/sway/config calls this script.
# You should see changes to the status bar after saving this script.
# If not, do "killall swaybar" and $mod+Shift+c to reload the configuration.

# The abbreviated weekday (e.g., "Sat"), followed by the ISO-formatted date
# like 2018-10-06 and the time (e.g., 14:01). Check `man date` on how to format
# time and date.
date_formatted=$(date "+%a %F %H:%M")

# "upower --enumerate | grep 'BAT'" gets the battery name (e.g.,
# "/org/freedesktop/UPower/devices/battery_BAT0") from all power devices.
# "upower --show-info" prints battery information from which we get
# the state (such as "charging" or "fully-charged") and the battery's
# charge percentage. With awk, we cut away the column containing
# identifiers. i3 and sway convert the newline between battery state and
# the charge percentage automatically to a space, producing a result like
# "charging 59%" or "fully-charged 100%".
battery_info=$(upower --show-info $(upower --enumerate |\
grep 'BAT') |\
egrep "state|percentage" |\
awk '{print $2}')

case $(pamixer --get-mute) in
  'true')  vol_icon="🔇" ;;
  'false') vol_icon="🔉" ;;
esac

vol=$(pacmd list-sinks | awk '/front-left:/ {print "L: " $5 " R: " $12}')

# check if app is using mic
mic_app=$(pactl list source-outputs | awk '/application.process.binary / {print $3}' | sed 's/"//g' | uniq | grep -v 'pavucontrol')
if [[ "$mic_app" != "" ]]; then
  mic_app="🎤 $mic_app"
fi

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
echo $mic_app $network_icon $networks $vol_icon $vol $brightness_icon $brightness 🔋 $battery_info 🐧 $date_formatted $bt_icon
