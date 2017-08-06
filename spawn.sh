#!/bin/bash

DEVICE_COUNT=`lsusb | grep "Realtek.*RTL" | wc -l`

if [ "$DEVICE_COUNT" -eq "0" ]; then
   echo "no devices found."
   exit 1
fi

DEVICE_IDS=`lsusb | grep "Realtek.*RTL" | cut -c5-8,16-18`
DEVICES=""

while read -r DEVICE_ID; do
    PARTS=($DEVICE_ID)
    DEVICE="--device /dev/bus/usb/${PARTS[0]}/${PARTS[1]}:/dev/bus/usb/${PARTS[0]}/${PARTS[1]}"
    DEVICES="$DEVICES $DEVICE"
done <<< "$DEVICE_IDS"

for DEVICE_IDX in $(seq 0 $((DEVICE_COUNT - 1))); do
    docker run -d --name "rtl_tcp_$DEVICE_IDX" $DEVICES --env-file .env -e RTL_IDX="$DEVICE_IDX" rtl_tcp
done
