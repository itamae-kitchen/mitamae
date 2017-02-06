## v1.3.4
- Improve Gentoo support [mruby-specinfra#2](https://github.com/k0kubun/mruby-specinfra/pull/2)

## v1.3.3
- Prevent source of file resource from being modified
  - Optimization introduced in [#41](https://github.com/k0kubun/mitamae/pull/41) is reverted for this
- Accept callable object for `only_if`/`not_if` [#49](https://github.com/k0kubun/mitamae/pull/49)
- Allow using Array for execute resource [#50](https://github.com/k0kubun/mitamae/pull/50)

## v1.3.2
- Suppress `NotImplementedError` on node object like Itamae [#44](https://github.com/k0kubun/mitamae/issues/44)
- Fix error on applying `remote_directory` twice [#45](https://github.com/k0kubun/mitamae/pull/45)

## v1.3.1
- Improve performance
  - Use syscall for link operations [#43](https://github.com/k0kubun/mitamae/pull/43)

## v1.3.0
- Improve performance
  - Use syscall for file mode changes [#37](https://github.com/k0kubun/mitamae/pull/37)
  - Use syscall to remove files [#38](https://github.com/k0kubun/mitamae/pull/38)
  - Skip unnecessary file copy for file resource [#41](https://github.com/k0kubun/mitamae/pull/41)
- Notify file's content changes [#40](https://github.com/k0kubun/mitamae/pull/40)
- Show notifies' log for dry-run mode [#39](https://github.com/k0kubun/mitamae/pull/39)
- Improve internal implementation
  - Update `Open3.capture3` to add chdir option, symbolize options and fix a potential bug

## v1.2.4
- Disable GC to avoid bus error

## v1.2.3
- Improve performance
  - Use syscall for file operations [#34](https://github.com/k0kubun/mitamae/pull/34)
  - Use syscall for users and groups operations [#35](https://github.com/k0kubun/mitamae/pull/35)

## v1.2.2
- Improve performance [#30](https://github.com/k0kubun/mitamae/pull/30) [#31](https://github.com/k0kubun/mitamae/pull/31) [#32](https://github.com/k0kubun/mitamae/pull/32)
- GC is enabled

## v1.2.1
- Fix SEGV on undefined method in recipe

## v1.2.0
- Internal changes for resource plugins [#27](https://github.com/k0kubun/mitamae/pull/27)
  - **[breaking change]** `MItamae::ResourceExecutor::Base#apply` is changed to have no arguments
     - Original arguments `current`/`desired` are defined as `attr_reader` instead.
  - `current`/`desired` are frozen after `set_current_attributes`/`set_desired_attributes`
  - Add `pre_action` hook for destructive operations.
     - `set_current_attributes`/`set_desired_attributes` should have no side effects.
- Drop rake.gem from build dependency

## v1.1.2
- Allow creating file with empty content

## v1.1.1
- Fix assignment failure on node object

## v1.1.0
- Add supported platforms
  - aix, alpine, amazon, coreos, cumulus, eos, esxi, fedora, freebsd,linuxmint,
  - nixos, openbsd, opensuse, plamo, poky, sles, smartos, solaris, suse

## v1.0.1
- Add `warn` and `fatal` log levels to `MItamae.logger`

## v1.0.0
- Implement all features for `itamae local`
  - Support `subscribes`, `verify`
  - Add `local_ruby_block`, `remote_directory`, `http_request` resources
  - Implement Host Inventory
- Print stdout and stderr on command failure

## v0.6.2
- Support edit action for file resource

## v0.6.1
- Support node.yml
- Fix broken node.json support

## v0.6.0
- Support recipe plugin. See [PLUGINS.md](./PLUGINS.md).

## v0.5.3
- Allow using params in resource inside definition

## v0.5.2
- Search files based on defined path in defined resource

## v0.5.1
- Avoid including the same recipes even if they are nested

## v0.5.0
- Release darwin binary with tarball

## v0.4.2
- Optimize file operations by mruby-file-stat

## v0.4.1
- Fix service resource for Ubuntu
- Support :uninstall of gem\_package resource

## v0.4.0
- Rename from itamae-mruby to mitamae

## v0.3.0
- Support resource plugin [#4](https://github.com/k0kubun/mitamae/pull/4)

## v0.2.2

- Close pipe after command execution on mruby-open3

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

- Add group resource [#2](https://github.com/k0kubun/mitamae/pull/2). *Thanks to @nonylene*
- Add user resource [#3](https://github.com/k0kubun/mitamae/pull/3). *Thanks to @nonylene*

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
