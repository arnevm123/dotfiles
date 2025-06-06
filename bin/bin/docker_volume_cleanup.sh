#!/bin/bash

# Define what's considered "idle" time (in days)
IDLE_DAYS=7

echo "Looking for dangling volumes older than $IDLE_DAYS days..."

# Get dangling volumes with their last modification time
docker volume ls -qf dangling=true | while read -r volume; do
    # Get volume info (including mountpoint)
    vol_info=$(docker volume inspect "$volume")
    mountpoint=$(echo "$vol_info" | grep "Mountpoint" | awk '{print $2}' | tr -d '",')

    # Get the last modification time of the volume data
    if [ -d "$mountpoint" ]; then
        last_modified=$(find "$mountpoint" -type f -exec stat -c "%Y" {} \; | sort -n | tail -1)
        current_time=$(date +%s)
        age_days=$(( (current_time - last_modified) / 86400 ))

        if [ "$age_days" -ge "$IDLE_DAYS" ]; then
            echo "Removing volume $volume (last modified $age_days days ago)"
            docker volume rm "$volume"
        else
            echo "Keeping volume $volume (last modified $age_days days ago)"
        fi
    else
        echo "Warning: Could not inspect mountpoint for volume $volume"
    fi
done

echo "Cleanup complete"
