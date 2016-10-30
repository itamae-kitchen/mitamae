FROM ubuntu:16.04

COPY ./mruby/build/x86_64-pc-linux-gnu/bin/mitamae /bin/mitamae

CMD while true; do sleep 3600; done
