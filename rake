#!/bin/bash

# simple script to test the kill-rake.sh script 
# this script will create a process named rake
# as written this script will consume approximately 20% cpu. Your mileage may vary.
# to get it to consume nearly 100% cpu, comment out the sleep command
# ./rake & # to run in the background
# kill %1 # to kill manually if this is first script running in the background

while true; do
    sleep 0.000001
    true
done

exit 0
