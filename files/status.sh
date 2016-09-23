#!/bin/bash
cd "${0%/*}"
status() {
  workers="$(../cake CakeResque.CakeResque stats | grep -e email -e cache -e prio -e default -e "Workers count" | sed 's/[^0-9]*//g')"
  for worker in $workers
  do
    if [ ${#worker} -gt 1 ]; then
      pid="$(echo $worker | sed 's/^.\(.*\).$/\1/')"
      status="$(ps --no-headers -s -q $pid | awk '{ print $7 }')"
      if [ $status != "S" ] && [ $status != "D" ] && [ $status != "R" ]; then
        return 1
      fi
    elif [ ${#worker} -eq 1 ] && [ $worker -ne 5 ]; then
      return $((5-${#worker}))
    fi
  done
  return 0
}

status