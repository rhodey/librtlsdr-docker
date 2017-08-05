# rtl_tcp
Docker image for working with the `rtl_tcp` utility from [librtlsdr](https://github.com/radiowitness/librtlsdr).
The `rtl_test` utility is automatically run before `rtl_tcp` to configure frequency correction.

## Build
```
$ docker build -t rtl_tcp .
```

## Configure
```
$ cp .env-example .env
```

## Usage
The docker `--device` argument is required to give this image access to the USB bus of your host
machine, do it like this:
```
$ lsusb | grep "Realtek.*RTL"
Bus 002 Device 008: ID 0bda:2838 Realtek Semiconductor Corp. RTL2838 DVB-T
$ docker run --name rtl_tcp_0 -d --device /dev/bus/usb/002/008:/dev/bus/usb/002/008 --env-file .env rtl_tcp
```

Alternatively you can use this helper script to spin up one container for each connected RTL USB
device:
```
$ ./spawn.sh
```

## Environment Variables
  + `RTL_IDX` - device index, unnecessary if using `spawn.sh`
  + `RTL_GAIN` - gain in dB, defaults to `0` for auto
  + `RTL_PPM_TIME` - PPM test duration in seconds
  + `RTL_BUFF_LEN` - length of USB transfer buffers in units of 512 bytes
  + `RTL_BUFF_NUM` - number of USB transfer buffers to fill per read loop
  + `RTL_LL_NUM` - max number of USB transfer buffers to queue for TCP

## License
Copyright 2017 Rhodey Orbits, GPLv3.
