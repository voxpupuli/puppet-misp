#!/bin/bash
cd "${0%/*}"
status() {
  workers=("$(redis-cli keys *email* )" "$(redis-cli keys *prio*)" "$(redis-cli keys *default*)" "$(redis-cli keys *cache*)" "$(redis-cli keys *_schdlr_*)")
  count=0
  for worker in "${workers[@]}"
  do
    pid="$(echo $worker | sed 's/[^0-9]*//g')"
    if [ -z "$pid" ]; then
      count=$(($count+1))
    else
      status="$(ps --no-headers -s -q $pid | awk '{ print $7 }')"
      if [[ ( -z "$status" ) || ( $status != "S" && $status != "D" && $status != "R" ) ]]; then
        count=$(($count+1))
      fi
    fi
  done
  return $count
}

status