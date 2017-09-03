#!/bin/bash

set -o allexport
source .env
set +o allexport

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

for IDX in $(seq 0 $((DEVICE_COUNT - 1))); do
    echo "measuring frequency correction for device #$IDX, duration: ${RTL_PPM_TIME}s..."
    PPM=`docker run --name rtl_tcp_ppm $DEVICES -it rtl_tcp rtl_test -d $IDX -p$RTL_PPM_TIME 2>&1 | grep "real sample rate" | cut -d':' -f4 | tr -d '[:space:]'`
    PPMS[IDX]=$(( PPM ))
    echo "determined required frequency correction of ${PPM}ppm."
    docker rm -f rtl_tcp_ppm >/dev/null
done

for IDX in $(seq 0 $((DEVICE_COUNT - 1))); do
    docker run -d --name "rtl_tcp_$IDX" \
      --network $DOCKER_NET $DEVICES \
      --env-file .env rtl_tcp \
      rtl_tcp -v -a 0.0.0.0 \
      -d $IDX -P ${PPMS[IDX]} \
      -g $RTL_GAIN -l $RTL_BUFF_LEN \
      -b $RTL_BUFF_NUM -n $RTL_LL_NUM
done
