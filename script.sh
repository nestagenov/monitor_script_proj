#!/bin/bash

# Function to calculate CPU usage
get_cpu_usage() {
    # Get the CPU usage from /proc/stat
    cpu_info=(`grep 'cpu ' /proc/stat`)
    idle=${cpu_info[4]} # idle CPU time
    total=0

    for value in "${cpu_info[@]:1}"; do
        total=$((total+value))
    done

    # Calculate the CPU usage percentage
    cpu_usage=$((100*( (total-idle) / total) ))
    echo "$cpu_usage"
}

# Function to calculate memory usage percentage
get_memory_usage() {
    memory_info=(`free | grep Mem`)
    used=${memory_info[2]} # used memory
    total=${memory_info[1]} # total memory

    # Calculate the memory usage percentage
    memory_usage=$((used * 100 / total))
    echo "$memory_usage"
}

# Function to get memory usage in MB
get_memory_usage_mi() {
    memory_info=(`free -h | awk '/Mem/{print $3}'`)
    echo "${memory_info[0]}"
}

# Function to get free memory
get_memory_free() {
    memory_info=(`free -h | awk '/Mem/{print $4}'`)
    echo "${memory_info[0]}"
}

# Function to get total memory
get_memory_total() {
    memory_info=(`free -h | awk '/Mem/{print $2}'`)
    echo "${memory_info[0]}"
}

while true; do
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    cpu=$(get_cpu_usage)
    memory=$(get_memory_usage)
    memory_in_mi=$(get_memory_usage_mi)
    memory_free=$(get_memory_free)
    memory_total=$(get_memory_total)

    echo "$timestamp" >> monitoring.log
    echo "CPU: $cpu%" >> monitoring.log
    echo "Memory: $memory%" >> monitoring.log
    echo "TOTAL memory: $memory_total" >> monitoring.log
    echo "USED memory: $memory_in_mi" >> monitoring.log
    echo "FREE memory: $memory_free" >> monitoring.log

    echo "" >> monitoring.log

    # set the time
    sleep 5 
done
