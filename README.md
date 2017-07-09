# MItamae [![Build Status](https://travis-ci.org/itamae-kitchen/mitamae.svg?branch=master)](https://travis-ci.org/itamae-kitchen/mitamae)

[Itamae](https://github.com/itamae-kitchen/itamae) implementation that is runnable without Ruby, which is a lightweight configuration management tool inspired by Chef.
With mitamae's standalone binary, you can write a configuration recipe in Ruby and apply it without Ruby.

## Status

All features are implemented and tested.

## Synopsis

Like original [Itamae](https://github.com/itamae-kitchen/itamae), you can manage configuration by Ruby DSL. But mitamae does not require MRI to run.

```rb
# cat recipe.rb
include_recipe 'included'

directory '/tmp/etc'

file '/tmp/etc/hello' do
  content 'This is mitamae'
end

template '/tmp/etc/config.yml' do
  source 'config.yml.erb'
end
```

```rb
# cat included.rb
define :vim, options: '--with-lua --with-luajit' do
  package 'vim' do
    version params[:name]
    options params[:options]
  end
end

vim '7.4.1910-1'

service 'mysqld' do
  action [:start, :enable]
end
```

```bash
# wget https://github.com/k0kubun/mitamae/releases/download/v0.4.0/mitamae-x86_64-linux
# chmod +x ./mitamae-x86_64-linux
# ./mitamae-x86_64-linux local -j node.json recipe.rb
 INFO : Starting MItamae...
 INFO : Recipe: /home/k0kubun/mitamae/recipe.rb
 INFO :   Recipe: /home/k0kubun/mitamae/included.rb
 INFO :     service[mysqld] running will change from 'false' to 'true'
 INFO :     service[mysqld] enabled will change from 'false' to 'true'
 INFO :   file[/tmp/etc/hello] exist will change from 'false' to 'true'
 INFO :   diff:
 INFO :   --- /dev/null 2016-07-23 16:06:36.583327464 +0900
 INFO :   +++ /tmp/1470446745.956       2016-08-06 10:25:45.967255508 +0900
 INFO :   @@ -0,0 +1 @@
 INFO :   +This is mitamae
```

## How to write recipes

See [Itamae's reference](https://github.com/itamae-kitchen/itamae/wiki).

Plugins are implemented differently. See [PLUGINS.md](./PLUGINS.md) for details.

### Supported features

`itamae ssh` is omitted by design because it's slow.
If you want to provision a server, download mitamae binary, transfer recipes and execute it over ssh.
For that reason, mitamae is more suitable for development environment bootstrap.

In recipes, you can use the features listed below.

- Common Attributes
  - [x] user
  - [x] cwd
  - [x] only\_if
  - [x] not\_if
  - [x] notifies
  - [x] subscribes
  - [x] verify
- Resources
  - [x] execute resource
  - [x] package resource
  - [x] directory resource
  - [x] git resource
  - [x] file resource
  - [x] remote\_file resource
  - [x] template resource
  - [x] link resource
  - [x] service resource
  - [x] gem\_package resource
  - [x] user resource
  - [x] group resource
  - [x] remote\_directory resource
  - [x] http\_request resource
  - [x] local\_ruby\_block resource
- [x] Definitions
- [x] Including Recipes
- [x] Node Attributes
- [x] run\_command
- [x] Plugins
- [x] Host Inventory

### Supported platforms

Currently following platforms are supported but others can be easily supported by porting specinfra modules.

- Alpine Linux
- Amazon Linux
- Arch Linux
- CentOS
- Debian
- Gentoo
- Ubuntu
- macOS
- [...etc](https://github.com/k0kubun/mruby-specinfra/tree/master/mrblib/specinfra/command)

## Contributing
### Development

```bash
$ rake compile && ./mruby/bin/mitamae local recipe.rb

# If you add mrbgem to mrbgem.rake, execute:
$ rake clean
```

### Testing

```bash
# Run integration tests on Docker
$ bundle exec rspec
```

### Cross compile

```bash
# Compile and copy binaries to ./mitamae-build
$ rake release:build
```

### Release

```bash
$ rake release
```

## Notes

Thanks to the original implementation https://github.com/itamae-kitchen/itamae.  
And this tools is built as the next generation of itamae-go https://github.com/k0kubun/itamae-go.

## Author

Takashi Kokubun
