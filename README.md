# rtl_tcp
Docker image for working with the `rtl_tcp` utility from [librtlsdr](https://github.com/radiowitness/librtlsdr).
The `rtl_test` utility is automatically run before `rtl_tcp` to configure frequency correction.

## Build
```
$ docker build -t rtl_tcp .
```

## Usage
The docker `--device` argument is required to give this image access to the USB bus of your host
machine, do it like this:
```
$ lsusb | grep "Realtek.*RTL"
Bus 002 Device 008: ID 0bda:2838 Realtek Semiconductor Corp. RTL2838 DVB-T
$ docker run --name rtl_tcp_0 -d --device /dev/bus/usb/002/008:/dev/bus/usb/002/008 rtl_tcp
```

Alternatively you can use this helper script to spin up one container for each connected RTL USB
device:
```
$ ./spawn.sh
```

## Environment Variables
  + `RTL_IDX` - device index (default: 0)
  + `RTL_GAIN` - gain in dB (default: auto)
  + `RTL_PPM_TIME` - PPM test duration in seconds (default: 240)

## License
Copyright 2017 Rhodey Orbits, GPLv3.
