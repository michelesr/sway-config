#!/bin/sh
# adapted from: https://legacy.sr.ht/EJ5C.sh
output_file="/tmp/screenshot-$(date '+%F-%T')"

case "$1" in
	"full")
		grim $output_file ;;
	"rect")
		grim -g "$(slurp)" $output_file ;;
	"active_window")
		grim -g "$(swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible? and .focused?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')" $output_file ;;
esac
