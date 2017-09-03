FROM alpine:3.6

MAINTAINER rhodey@anhonestefort.org

EXPOSE 1234

RUN apk add --no-cache git \
  libc-dev \
  libusb-dev \
  gcc \
  make \
  cmake \
  bash

ADD https://api.github.com/repos/radiowitness/librtlsdr/git/refs/heads/master version.json
RUN git clone -b master https://github.com/radiowitness/librtlsdr.git /usr/local/share/librtlsdr
RUN mkdir /usr/local/share/librtlsdr/build

WORKDIR /usr/local/share/librtlsdr/build
RUN cmake ../ -DINSTALL_UDEV_RULES=ON -DDETACH_KERNEL_DRIVER=ON
RUN make
RUN make install

WORKDIR /usr/local/share/librtlsdr
