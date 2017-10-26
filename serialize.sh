#!/bin/bash

device_count=`lsusb | grep "Realtek.*RTL" | wc -l`

if [ "$device_count" -eq "0" ]; then
   echo "no devices found."
   exit 1
fi

device_ids=`lsusb | grep "Realtek.*RTL" | cut -c5-8,16-18`
devices=""

while read -r device_id; do
    parts=($device_id)
    device="--device /dev/bus/usb/${parts[0]}/${parts[1]}:/dev/bus/usb/${parts[0]}/${parts[1]}"
    devices="$devices $device"
done <<< "$device_ids"

for idx in $(seq 0 $((device_count - 1))); do
    docker run $devices --rm -t librtlsdr rtl_eeprom -d $idx -s "0000000$idx"
done
