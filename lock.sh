#!/bin/bash
# wrap swaylock so that sway will close the session
# if swaylocks exits with status code != 0
lock='swaylock -c 000000'
$lock &
wait %1
case "$?" in
  "0"|"2")
    exit 0 ;;
  *)
    swaymsg exit ;;
esac
