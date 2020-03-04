# k0kubun/mitamae-dockcross:linux-arm64
# mitamae's original platform for backward compatibility
# TODO: replace this with dockcross/linux-armv*
FROM dockcross/linux-x64:20200119-1c10fb2

# Install ruby and rake
RUN apt-get update && apt-get install -y --no-install-recommends ruby

# Not using since it's too slow
# RUN git clone https://github.com/raspberrypi/tools /opt/raspberrypi-tools && \
#   git -C /opt/raspberrypi-tools reset --hard 5caa7046982f0539cf5380f94da04b31129ed521

RUN git clone --depth=1 https://github.com/raspberrypi/tools /opt/raspberrypi-tools && \
  rm -rf /opt/raspberrypi-tools/.git && \
  rm -rf /opt/raspberrypi-tools/arm-bcm2708/arm-bcm2708-linux-gnueabi && \
  rm -rf /opt/raspberrypi-tools/arm-bcm2708/arm-bcm2708hardfp-linux-gnueabi && \
  rm -rf /opt/raspberrypi-tools/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf && \
  rm -rf /opt/raspberrypi-tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian
ENV PATH /opt/raspberrypi-tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin/:$PATH

ENV CROSS_TRIPLE=arm-linux-gnueabihf
ENV CROSS_ROOT=/opt/raspberrypi-tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64
ENV AR=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-ar \
    CC=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-gcc \
    CXX=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-g++
