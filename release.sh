#!/bin/bash -ex
# This script is created because `rake release` doesn't work somehow...

sudo docker-compose run -e BUILD_TARGET=all compile
sudo chown -R "${USER}:${USER}" mruby/build
rake release
