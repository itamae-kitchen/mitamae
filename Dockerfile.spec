FROM ubuntu:trusty

RUN mkdir /recipes
COPY mruby/build/x86_64-pc-linux-gnu/bin/mitamae /bin/mitamae

COPY spec/recipes /recipes
RUN mitamae local -j /recipes/node.json /recipes/default.rb

CMD while true; do sleep 3600; done
