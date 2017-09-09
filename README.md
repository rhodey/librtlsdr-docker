# librtlsdr-docker
Docker image and bash scripts for working with [librtlsdr](https://github.com/radiowitness/librtlsdr).
TCP port `1234` is exposed for convenience of working with the `rtl_tcp` utility.

## Build
```
$ docker build -t librtlsdr .
```

## General Usage
The docker `--device` argument is required to give your container access to the USB devices
connected to your host machine, for example running `rtl_eeprom` works like this:
```
$ lsusb | grep "Realtek.*RTL"
Bus 002 Device 008: ID 0bda:2838 Realtek Semiconductor Corp. RTL2838 DVB-T
$ docker run \
  --device /dev/bus/usb/002/008:/dev/bus/usb/002/008 \
  --rm -it librtlsdr \
  rtl_eeprom -d 0
```

## Radio Witness Usage
At Radio Witness we're really only concerned with the `rtl_tcp` utility, in general our workflow
for using it goes like this:
  1. assign ascending serial numbers to connected RTL devices -> `$ ./serialize.sh`
  2. configure environment variables -> `$ cp .env-example .env`
  3. spawn one `rtl_tcp` process for every RTL device -> `$ ./rtl_tcp.sh`

### Environment Variables
  + `DOCKER_NET` - docker network name
  + `RTL_GAIN` - gain in dB, use `0` for auto
  + `RTL_PPMS` - comma separated PPM correction specs in the form of `<serial>:<ppm>`
  + `RTL_BUFF_LEN` - length of USB transfer buffers in units of 512 bytes
  + `RTL_BUFF_NUM` - number of USB transfer buffers to fill per read loop
  + `RTL_LL_NUM` - max number of USB transfer buffers to queue for TCP

## License
Copyright 2017 Rhodey Orbits, GPLv3.
