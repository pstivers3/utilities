#!/bin/bash
# kill-rake
# Paul Stivers
# last updated: 2011-12-31

# this program will kill rake processes that have been running longer than the time_limit
# and consuming more cpu than the cpu_limit.

# declare integer variables. This is not strictly required in bash, but is correct and more portable.
declare -i time_limit cpu_limit etime_char_count min cpu_int

time_limit=2 # minutes
cpu_limit=30 # percent 

grep_rake=$(ps -eo euser,pid,%cpu,%mem,etime,comm | egrep 'rake' | egrep -v 'grep' | egrep -v 'kill-rake')

# if no rake processes running, notify the user and exit.
if [ -z "$grep_rake"  ]; then
    echo
    echo "There are no rake processes running."
    echo
    exit 1
fi

# create a function to parse the appropriate fields from a pid row from grep_rake.
parsestring() {
    pid=$2
    cpu_float=$3
    etime=$5
}

# while there are still rows in "$grep_rake", process the row for possible action.
# double quotes are needed around "$grep_rake" to preserver the separate row for each pid.

echo
echo "euser pid %cpu %mem etime comm"

let i=1
parse_row=$(echo "$grep_rake" | awk "NR==$i")
while [ -n "$parse_row" ]; do
    echo $parse_row
    # call parsestring with $parse_row as it's argument.
    # do not double quote $parse_row or it will be seen as a single command line argument by parsestring.
    parsestring $parse_row
    cpu_int=${cpu_float%.*} # delete the decimal remainder if it exists
  
    # calculate elapsed time
        # obtain minutes by cutting the 2nd field from the right. Do it this way incase there are days or hours on the left.
        # the format for etime is [[dd-]hh:]mm:ss
        min=$(echo $etime | awk -F: '{print $(NF-1)}') 
    etime_char_count=$(echo -n $etime | wc -m) # -n is no carriage return so that wc -m counts only the charactes in etime
  
    # if elapsed minutes is greater than or equal to time_limit or etime has hour or day characters.
    # and if cpu utilization greater than or equal to cpu_limit.
    # then kill the rake process
    if (( (min >= time_limit) || (etime_char_count > 5) )) && ((cpu_int >= cpu_limit)); then
        date=$(date)
        sudo kill -9 $pid
        echo "rake process $pid was killed on $date"
    fi
    # if elapsed minutes is less than time_limit and etime has no hour or day characters.
    if (( (min < time_limit) && (etime_char_count <= 5) )); then
        echo "The rake process $pid has been running for less than $time_limit minutes."
    fi
    # if cpu utilization is less than cpu_limit
    if (( cpu_int <= cpu_limit )); then 
        echo "The rake process $pid is consuming less than ${cpu_limit}% cpu."
    fi
    ((++i))
    parse_row=$(echo "$grep_rake" | awk "NR==$i")
    echo
done

exit 0

