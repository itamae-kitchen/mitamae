## v0.0.7

- Show backtrace on recipe error

## v0.0.6

- Fix namespace resolution bug in `Specinfra::Command::Darwin::Base::Package`

## v0.0.5

- Use fork of mruby to use resource inside `each`

## v0.0.4

- Fix command failure (exit status = 141) on link or git resource

## v0.0.3

- Fix `node` to be available in define block

## v0.0.2

- Support `node[:platform]` and `node[:platform_version]`

## v0.0.1

- Initial release
 - Add resources
    - execute
    - package
    - directory
    - git
    - file
    - remote\_file
    - template
    - link
    - service
 - Add support for some platforms
    - Arch Linux
    - CentOS
    - Debian
    - Gentoo
    - OSX
    - Ubuntu
 - Add `define`, `run_command` and `include_recipe`
