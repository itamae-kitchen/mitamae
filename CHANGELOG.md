## v0.2.1

- Fix bug in showing difference

## v0.2.0

- Improve stability
- Don't use thread to execute commands

## v0.1.1

- Add `ENV.fetch` by https://github.com/iij/mruby-env/pull/12

## v0.1.0

- Release Linux binaries in .tar.gz

## v0.0.16

- Avoid SEGV in GC

## v0.0.15

- Normalize file mode properly

## v0.0.14

- Decrease memory allocation
- Fix SEGV by defined resource

## v0.0.13

- Add mruby-enumerator

## v0.0.12

- Rollback mruby to fork

## v0.0.11

- Use mruby [master](https://github.com/mruby/mruby/commit/2d335daeeb1d50402041041c7a3531674a2e735a)
- Add mruby-fiber to let erb work

## v0.0.10

- Add group resource [#2](https://github.com/k0kubun/itamae-mruby/pull/2). *Thanks to @nonylene*
- Add user resource [#3](https://github.com/k0kubun/itamae-mruby/pull/3). *Thanks to @nonylene*

## v0.0.9

- Fix non-executed bug in execute resource
- Support notifies attribute

## v0.0.8

- Support gem\_package resource

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
