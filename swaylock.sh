#!/bin/bash
# wrap swaylock so that sway will close the session
# if swaylocks exits with status code not in
#   0: success
#   2: screen already locked

# handle termination signals: SIGKILL can't be handled
trap 'swaymsg exit && exit 0' SIGTERM SIGINT SIGQUIT SIGHUP

lock='swaylock -c 000000'
$lock &
wait %1
case "$?" in
  "0"|"2")
    exit 0 ;;
  *)
    swaymsg exit ;;
esac
