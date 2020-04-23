#!/bin/bash
# Protect sway from swaylock accidental termination
#
# Args:
#   -f | --foreground : run in foreground
CMD='swaylock -c 000000'

lock() {
  # handle termination signals: SIGKILL can't be handled
  trap 'swaymsg exit && exit 0' SIGTERM SIGINT SIGQUIT SIGHUP

  $CMD &
  wait %1
  case "$?" in
    "0"|"2")
      exit 0 ;;
    *)
      swaymsg exit ;;
  esac
}

if [[ "$1" == '-f' || "$1" == '--foreground' ]]; then
  lock
else
  lock &
  disown
  exit 0
fi
