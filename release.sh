#!/bin/bash -ex
# This script is created because `rake release` doesn't work somehow...

if [ ! -f mruby/Rakefile ]; then
  git submodule init
  git submodule update
fi
sudo docker-compose run -e BUILD_TARGET=all compile
sudo chown -R "${USER}" mruby/build
rake release
