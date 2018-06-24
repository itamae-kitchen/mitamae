# Changing https://github.com/hone/mruby-cli-docker to support cross compile for raspberry pi
FROM hone/mruby-cli

RUN git clone https://github.com/raspberrypi/tools /raspberrypi/tools && \
  git -C /raspberrypi/tools reset --hard 5caa7046982f0539cf5380f94da04b31129ed521
ENV PATH /raspberrypi/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin:$PATH
