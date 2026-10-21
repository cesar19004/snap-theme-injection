#!/bin/bash

# Check for root
if [[ $EUID -ne 0 ]]; then
   echo "Error: sudo is required to connect snaps" >&2
   exit 1
fi

for snap in $(snap list | awk 'NR>1 {print $1}'); do
    for iface in gtk-3-themes icon-themes sound-themes; do
        snap connect "$snap:$iface" gtk-common-themes:$iface 2>/dev/null
    done
done
