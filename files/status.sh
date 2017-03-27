#!/bin/bash

status() {
  # Get the list of MISP background workers from Redis
  workers=( $(redis-cli smembers resque:workers) )
  ret_code=$?
  num_workers=${#workers[@]}
  if [ $num_workers -eq 5 ]; then
    return "$((5-$num_workers))"
  fi

  if [ $ret_code -eq 0 ]; then
    # Extract PIDs from worker names
    pids=`echo "${workers[@]}" | tr ' ' '\n' | sed -n 's/.*:\([0-9]\+\):.*/\1/p' | tr '\n' ' '`
    # Get the status of the processes
    process_states=( $(ps --no-headers -o state -p $pids) )
    # Check that it was possible to get the process status for all workers
    if [ ${#process_states[@]} -ne ${#workers[@]} ]; then
      let ret_code=${#workers[@]}-${#process_states[@]}
    else
      # Check how many of the workers are running
      running_processes=`echo "${process_states[@]}" | tr ' ' '\n' | grep -c "[SRD]"`
      let ret_code=${#workers[@]}-${running_processes}
    fi
  fi
  return $ret_code
}

status
