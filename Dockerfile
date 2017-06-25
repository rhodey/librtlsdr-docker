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

WORKDIR /usr/local
RUN git clone https://github.com/radiowitness/librtlsdr
RUN mkdir /usr/local/librtlsdr/build

WORKDIR /usr/local/librtlsdr/build
RUN cmake ../ -DINSTALL_UDEV_RULES=ON -DDETACH_KERNEL_DRIVER=ON
RUN make
RUN make install

WORKDIR /usr/local
COPY rtl_tcp_ppm.sh rtl_tcp_ppm.sh
CMD /bin/bash rtl_tcp_ppm.sh
