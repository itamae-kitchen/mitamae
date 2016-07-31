# itamae-mruby

[Itamae](https://github.com/itamae-kitchen/itamae) implementation that is runnable without Ruby, which is a lightweight configuration management tool inspired by Chef.  
With itamae-mruby's standalone binary, you can write a configuration recipe in Ruby and apply it without Ruby.

## How to write recipes

See [itamae's reference](https://github.com/itamae-kitchen/itamae/wiki).

### Supported features

You can use only the features listed below.

- Resources
  - [ ] execute resource
  - [ ] package resource
  - [ ] directory resource
  - [ ] git resource
  - [ ] file resource
  - [ ] template resource
  - [ ] link resource
  - [ ] service resource
  - [ ] user resource
  - [ ] group resource
  - [ ] remote\_file resource
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

## Notes

Thanks to the original implementation https://github.com/itamae-kitchen/itamae.  
And this tools is built as the next generation of itamae-go https://github.com/k0kubun/itamae-go.

## Author

Takashi Kokubun
