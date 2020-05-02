#!/bin/bash
# Protect sway from swaylock accidental termination
#
# Args:
#   -f | --foreground : run in foreground
CMD='swaylock -i ~/Pictures/vulcanart.png'

lock() {
  # handle termination signals: SIGKILL can't be handled
  trap 'swaymsg exit && exit 0' SIGTERM SIGINT SIGQUIT SIGHUP

  $CMD &
  wait %1
  code=$?
  case "${code}" in
    "0"|"2")
      exit 0 ;;
    *)
      echo "[$(date '+%F %T')] swaylock exit code: ${code}" >> ~/swaylock.log
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
