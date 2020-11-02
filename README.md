# librtlsdr-docker
Docker image and bash scripts for working with the [librtlsdr](https://github.com/radiowitness/librtlsdr) binaries.

## Build
```
$ docker build -t librtlsdr .
```

## Run
The docker `--device` argument is required to give your container access to the USB devices connected to your host machine, for example running `rtl_eeprom` works like this:
```
$ lsusb | grep "Realtek.*RTL"
Bus 002 Device 008: ID 0bda:2838 Realtek Semiconductor Corp. RTL2838 DVB-T
$ docker run \
    --device /dev/bus/usb/002/008:/dev/bus/usb/002/008 \
    --rm -it librtlsdr \
    rtl_eeprom -d 0
```

Bash script `rtl_devices.sh` enumerates all RTLSDR devices for convenience:
```
$ chmod +x bin/rtl_devices.sh
$ docker run \
    $(./bin/rtl_devices.sh) \
    --rm -it librtlsdr \
    rtl_eeprom -d 0
```

## License
Copyright 2017 Rhodey Orbits, GPLv3.
