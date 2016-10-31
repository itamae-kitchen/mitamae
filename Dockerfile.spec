FROM ubuntu:trusty

RUN mkdir /recipes
COPY mruby/build/x86_64-pc-linux-gnu/bin/mitamae /bin/mitamae

COPY spec/recipes/package.rb /recipes/
RUN mitamae local /recipes/package.rb

COPY spec/recipes/service.rb /recipes/
RUN mitamae local /recipes/service.rb

COPY spec/recipes/gem_package.rb /recipes/
RUN mitamae local /recipes/gem_package.rb

COPY spec/recipes /recipes
RUN mitamae local /recipes/default.rb

CMD while true; do sleep 3600; done
