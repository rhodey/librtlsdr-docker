#!/bin/bash

device_count=`lsusb -d 0x0bda:2838 | wc -l`

if [ "$device_count" -eq "0" ]; then
   echo "no devices found."
   exit 1
fi

for idx in $(seq 0 $((device_count - 1))); do
    docker run $(./bin/rtl_devices.sh) --rm -t librtlsdr rtl_eeprom -d $idx -s "0000000$idx"
done
