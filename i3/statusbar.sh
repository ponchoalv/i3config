#!/bin/bash
/usr/bin/i3status | (read line && echo $line && read line && echo $line && while :
do
  read line
  monitor_mode=`cat /tmp/monitor_mode.dat`
  monitor_json="{\"name\":\"monitors_mode\",\"full_text\":\"$monitor_mode\"}"

  id=$(xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}')
  if [ x$id != x ]; then
    name=$(xprop -id $id | awk '/_NET_WM_NAME/{$1=$2="";print}' | cut -d'"' -f2)
    name=${name//\\/\\\\}
    name=${name//\"/\\\"}
    dat="[{\"name\":\"title\",\"full_text\":\"$name\"},"
    echo "${line/[/$dat$monitor_json,}" || exit 1
  else
    echo "${line/[/$monitor_json}" || exit 1
  fi
done)