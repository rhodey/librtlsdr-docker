#!/bin/bash

DEVICE=${RTL_IDX:-0}
GAIN=${RTL_GAIN:-0}
PPM_TIME=${RTL_PPM_TIME:-240}

echo "Frequency correcting device #$DEVICE, duration: ${PPM_TIME}s..."
PPM=`rtl_test -d $DEVICE -p$PPM_TIME 2>&1 | grep "real sample rate" | cut -d':' -f4 | tr -d '[:space:]'`
echo "Determined required frequency correction of ${PPM}ppm."

rtl_tcp -a 0.0.0.0 -d $DEVICE -g $GAIN -P $PPM
