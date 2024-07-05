#!/bin/bash

# Find all listening processes
LISTENING_PROCESSES=$(sudo lsof -i -P -n | grep LISTEN | awk '{print $2}')

# Stop each listening process
for PID in $LISTENING_PROCESSES; do
    echo "Killing process $PID"
    sudo kill -9 $PID
done

echo "All listening processes have been killed."

