#!/bin/bash

set -o allexport
source .env
set +o allexport

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

ifs_tmp=$IFS
IFS=,
read -r -a ppm_specs <<< "$RTL_PPMS"
IFS=$ifs_tmp

for idx in $(seq 0 $((device_count - 1))); do
    idx_serial=`docker run $devices --rm -t librtlsdr rtl_eeprom -d $idx 2>&1 | grep "Serial number:"`
    for ppm_spec in "${ppm_specs[@]}"; do
        serial=$(echo $ppm_spec | cut -f1 -d:)
        ppm=$(echo $ppm_spec | cut -f2 -d:)
        if echo $idx_serial | grep "$serial" > /dev/null ; then
          docker run --name "rtl_tcp_$idx" \
            --network $DOCKER_NET \
            -v /etc/localtime:/etc/localtime:ro \
            $devices -d librtlsdr \
            rtl_tcp -v -a 0.0.0.0 \
            -d $idx -P $ppm \
            -g $RTL_GAIN -l $RTL_BUFF_LEN \
            -b $RTL_BUFF_NUM -n $RTL_LL_NUM
        fi
    done
done
