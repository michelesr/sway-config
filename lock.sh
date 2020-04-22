#!/bin/bash
# wrap swaylock so that sway will close the session
# if swaylocks exits with status code != 0
lock='swaylock -c 000000'
$lock &
if ! wait %1; then
  swaymsg exit
fi
