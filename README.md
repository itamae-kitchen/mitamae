# itamae-mruby [![Build Status](https://travis-ci.org/k0kubun/itamae-mruby.svg?branch=master)](https://travis-ci.org/k0kubun/itamae-mruby)

[Itamae](https://github.com/itamae-kitchen/itamae) implementation that is runnable without Ruby, which is a lightweight configuration management tool inspired by Chef.  
With itamae-mruby's standalone binary, you can write a configuration recipe in Ruby and apply it without Ruby.

## Status

Experimental. Some features are omitted or not tested.

## Synopsis

Like original [itamae](https://github.com/itamae-kitchen/itamae), you can manage configuration by Ruby DSL. But itamae-go does not require Ruby to run.

```rb
# cat recipe.rb
include_recipe 'included'

directory '/tmp/etc'

file '/tmp/etc/hello' do
  content 'This is itamae'
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
# wget https://github.com/k0kubun/itamae-mruby/releases/download/v0.0.1/itamae-x86_64-linux
# chmod +x ./itamae-x86_64-linux
# ./itamae-x86_64-linux local -j node.json recipe.rb
 INFO : Starting Itamae...
 INFO : Recipe: /home/k0kubun/itamae/recipe.rb
 INFO :   Recipe: /home/k0kubun/itamae/included.rb
 INFO :     service[mysqld] running will change from 'false' to 'true'
 INFO :     service[mysqld] enabled will change from 'false' to 'true'
 INFO :   file[/tmp/etc/hello] exist will change from 'false' to 'true'
 INFO :   diff:
 INFO :   --- /dev/null 2016-07-23 16:06:36.583327464 +0900
 INFO :   +++ /tmp/1470446745.956       2016-08-06 10:25:45.967255508 +0900
 INFO :   @@ -0,0 +1 @@
 INFO :   +This is itamae
```

## How to write recipes

See [itamae's reference](https://github.com/itamae-kitchen/itamae/wiki).

### Supported features

You can use only the features listed below.

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
  - [ ] user resource
  - [ ] group resource
  - [ ] remote\_directory resource
  - [ ] gem\_package resource
  - [ ] http\_request resource
  - [ ] local\_ruby\_block resource
- [x] Definitions
- [x] Including Recipes
- [x] Node Attributes
- [x] run\_command
- [ ] Host Inventory
- [ ] Plugins

### Supported platforms

Currently following platforms are supported but others can be easily supported by porting specinfra modules.

- Arch Linux
- CentOS
- Debian
- Gentoo
- OSX
- Ubuntu

## Contributing
### Development

```bash
$ ITAMAE_DEBUG=1 rake compile && ./mruby/bin/itamae local recipe.rb
```

## Notes

Thanks to the original implementation https://github.com/itamae-kitchen/itamae.  
And this tools is built as the next generation of itamae-go https://github.com/k0kubun/itamae-go.

## Author

Takashi Kokubun
