#!/bin/bash

DEVICE=${RTL_IDX:-0}
GAIN=${RTL_GAIN:-0}

echo "Frequency correcting device #$DEVICE, duration: ${RTL_PPM_TIME}s..."
PPM=`rtl_test -d $DEVICE -p$RTL_PPM_TIME 2>&1 | grep "real sample rate" | cut -d':' -f4 | tr -d '[:space:]'`
echo "Determined required frequency correction of ${PPM}ppm."

rtl_tcp -v -a 0.0.0.0 -d $DEVICE -g $GAIN -P $PPM -l $RTL_BUFF_LEN -b $RTL_BUFF_NUM -n $RTL_LL_NUM
