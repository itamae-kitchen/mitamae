# Changing https://github.com/hone/mruby-cli-docker to support cross compile for raspberry pi
FROM hone/mruby-cli

# Not using since it's too slow
# RUN git clone https://github.com/raspberrypi/tools /opt/raspberrypi-tools && \
#   git -C /opt/raspberrypi-tools reset --hard 5caa7046982f0539cf5380f94da04b31129ed521

RUN git clone --depth=1 https://github.com/raspberrypi/tools /opt/raspberrypi-tools
ENV PATH /opt/raspberrypi-tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin:$PATH
