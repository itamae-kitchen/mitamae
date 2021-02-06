## v1.12.0

- Upgrade mruby from v2.0.1 to v2.1.2
- Upgrade specinfra [from v2.82.12 to v2.82.23](https://github.com/mizzy/specinfra/compare/v2.82.12...v2.82.23)
- Upgrade XCode used for darwin-x86\_64 to 12.4
- Drop darwin-i386 support

## v1.11.8

- Support aarch64-darwin in binary releases

## v1.11.7

- Avoid a hang on `gem_package` resource when nonexistent `gem_binary` is specified

## v1.11.6

- Support `atomic_update` attribute in `file`, `remote_file`, and `template` resources

## v1.11.5

- Support `service` resource on Gentoo
  - Upgrade specinfra [from v2.82.11 to v2.82.12](https://github.com/mizzy/specinfra/compare/v2.82.11...v2.82.12)
    ([mruby-specinfra@feb32da...69fe430](https://github.com/itamae-kitchen/mruby-specinfra/compare/feb32da...69fe430))

## v1.11.4

- Make `node[:platform]` more robust on openSUSE
  - Upgrade specinfra [from v2.82.10 to v2.82.11](https://github.com/mizzy/specinfra/compare/v2.82.10...v2.82.11)
    ([mruby-specinfra@6caf46e...feb32da](https://github.com/itamae-kitchen/mruby-specinfra/compare/6caf46e...feb32da))

## v1.11.3

- Update Docker image for building released binaries

## v1.11.2

- Support aarch64 in binary releases

## v1.11.1

- Support `package` resource on OpenBSD
  - Upgrade specinfra [from v2.82.9 to v2.82.10](https://github.com/mizzy/specinfra/compare/v2.82.9...v2.82.10)
    ([mruby-specinfra@95994e4...6caf46e](https://github.com/itamae-kitchen/mruby-specinfra/compare/95994e4...6caf46e))

## v1.11.0

- Use musl-libc for x86\_64 Linux binary to remove libc dependency
- Upgrade specinfra [from v2.82.8 to v2.82.9](https://github.com/mizzy/specinfra/compare/v2.82.8...v2.82.9)
  ([mruby-specinfra@d67d734...95994e4](https://github.com/itamae-kitchen/mruby-specinfra/compare/d67d734...95994e4))

## v1.10.5

- Fix notifications to multiple `subscribes` from a single resource
  - When multiple resources subscribed the same resource, only one of them had been notified since v1.7.1
- Fix a notification message in `subscribes` to have a notified resource instead of a notifying resource
- Upgrade specinfra [from v2.82.7 to v2.82.8](https://github.com/mizzy/specinfra/compare/v2.82.7...v2.82.8)
  ([mruby-specinfra@58981a4...d67d734](https://github.com/itamae-kitchen/mruby-specinfra/compare/58981a4...d67d734))
  - This resurrects the Symbol reference in `node[:ec2][:xxx]`, which was introduced in mitamae v1.5.5 and dropped in mitamae v1.10.0

## v1.10.4

- Pass a file name to `__FILE__` in a resource plugin instead of `(eval)`

## v1.10.3

- Load resource plugins properly with `--plugins`

## v1.10.2

- Upgrade specinfra [from v2.82.4 to v2.82.7](https://github.com/mizzy/specinfra/compare/v2.82.4...v2.82.7)
  ([mruby-specinfra@f02c409...58981a4](https://github.com/itamae-kitchen/mruby-specinfra/compare/f02c409...58981a4))

## v1.10.1

- Add `--plugins` option to specify plugins directory
- Change `MItamae` in help and log messages to `mitamae`

## v1.10.0

- Upgrade mruby-specinfra to an automated fork based on specinfra v2.82.4
  [mruby-specinfra#12](https://github.com/itamae-kitchen/mruby-specinfra/pull/12)
  - mruby-specinfra diff: [mruby-specinfra@21cd47d...f02c409](https://github.com/itamae-kitchen/mruby-specinfra/compare/21cd47d48cb15d4039cd8449f65cfc1ac1babe3b...f02c40935ab7c334bdb110edef243556e69e391b)
  - upstream specinfra base is changed [from v2.60.2 to v2.82.4](https://github.com/mizzy/specinfra/compare/v2.60.2...v2.82.4)
     - Some of the diff was already backported to mruby-specinfra individually. So the actual diff may vary.

## v1.9.8

- Detect OS name of CoreOS correctly [mruby-specinfra#11](https://github.com/itamae-kitchen/mruby-specinfra/pull/11)

## v1.9.7

- Stop defining `path`, `variables`, `source`, `recipe` local variables in recipe by default
  - They have been accidentally exposed to recipes because of the environment of internal `instance_eval` call

## v1.9.6

- Fix a crash when `file` resource handles a file with nameless owner

## v1.9.5

- Upgrade mruby-yaml
  - YAML.dump stops generating a double quotes literal when a string includes double quotes

## v1.9.4

- Upgrade mruby-yaml
  - Introduce `Object#to_yaml`
  - Psych-compatible multi-line literal is generated on YAML.dump

## v1.9.3

- Fix debug logs of defined resource (added since v1.9.2) to show correct names

## v1.9.2

- Respect `only_if`/`not_if` in a resource defined by `define`

## v1.9.1

- Upgrade mruby-yaml
  - YAML.dump generates double quotes for String not starting with alphabet or number.
  - Like CRuby's Psych, YAML.dump no longer generates `...`

## v1.9.0

- Upgrade mruby-yaml
  - Disable `y`/`n` as shorthands of `true`/`false` [mruby-yaml#10](https://github.com/mrbgems/mruby-yaml/pull/10)
  - Update libyaml from v0.1.6 to v0.2.2 [mruby-yaml#15](https://github.com/mrbgems/mruby-yaml/pull/15)

## v1.8.0

- `http_request` resource drops `check_error` attribute (v1.7.4 feature) and always raises
  exceptions on 4XX or 5XX responses [#85](https://github.com/itamae-kitchen/mitamae/pull/85)

## v1.7.8

- Support Clear Linux OS [mruby-specinfra#10](https://github.com/itamae-kitchen/mruby-specinfra/pull/10)

## v1.7.7

- Add `Node#validate!` like Itamae [#83](https://github.com/itamae-kitchen/mitamae/pull/83)

## v1.7.6

- Allow using `content` attribute in `template` resource

## v1.7.5

- Upgrade mruby to v2.0.1

## v1.7.4

- Add `check_error` attribute to `http_request` resource

## v1.7.3

- Fix `file` resource error when it has `user` attribute which is not the same as mitamae executor.

## v1.7.2

- Support Amazon Linux 2 [mruby-specinfra#9](https://github.com/itamae-kitchen/mruby-specinfra/pull/9)

## v1.7.1

- Deduplicate delayed notifications
  - The same notification by subscribes/notifices will run only once

## v1.7.0

- Upgrade mruby to v2.0.0

## v1.6.6

- Change JSON parse/generator from mruby-iijson to mruby-json to support `JSON.pretty_generate`

## v1.6.5

- Fix LocalJumpError inside `Hash#uniq` by backporting mruby's patch

## v1.6.4

- Support group name with spaces [mruby-specinfra#8](https://github.com/itamae-kitchen/mruby-specinfra/pull/8)

## v1.6.3

- Fix an error by creating a file with `content ""` with `owner`/`group` specified
- "mitamae" is printed in the log instead of "MItamae"

## v1.6.2

- Allow specifying `-j`/`--node-json` and `-y`/`--node-yaml` multiple times
  - The latter node JSON/YAML overrides the former JSON/YAML

## v1.6.1

- Add mitamae-armhf-linux binary in the released binaries for Raspberry Pi

## v1.6.0

- `http_request` resource requires `curl(1)` in a host
  - `http_request` supports https request [#46](https://github.com/itamae-kitchen/mitamae/pull/46)
  - `http_request` follows redirection
  - POST or PUT `http_request` with request body `foo=bar` is interpreted properly

## v1.5.7

- Release binaries from Travis CI instead of k0kubun's machine

## v1.5.6

- Allow using `URI` module to write recipes
- Improve error message on NoMethodError in resource context

## v1.5.5

- Allow using Symbol in `node[:ec2][xxx]` as well

## v1.5.4

- Fix error when seeing EC2 metadata from node
- Return Hash::Mash instead of Hash from `node[xxx]` when it's host inventory

## v1.5.3

- Allow using `Kernel#at_exit` from recipe [#69](https://github.com/itamae-kitchen/mitamae/pull/69)

## v1.5.2
- Fix gem\_package resource to strip "default: " prefix from gem versions [#66](https://github.com/itamae-kitchen/mitamae/pull/63)

## v1.5.1
- GC is enabled again
  - Please try v1.5.0 too if you encounter any trouble

## v1.5.0
- Upgrade mruby to 1.3.0 [#63](https://github.com/itamae-kitchen/mitamae/pull/63)

## v1.4.5
- Update mruby-io [#61](https://github.com/itamae-kitchen/mitamae/pull/61)

## v1.4.4
- Add debug log on recipe loading [#60](https://github.com/itamae-kitchen/mitamae/pull/60)

## v1.4.3
- Add depth attribute to git resource [#57](https://github.com/k0kubun/mitamae/pull/57)

## v1.4.2
- Fix unexpected blocking on executing commands [mruby-open3#9](https://github.com/k0kubun/mruby-open3/pull/9)

## v1.4.1
- Support force link to a directory [#54](https://github.com/k0kubun/mitamae/pull/54)
- Allow service resource to execute only reload action [#55](https://github.com/k0kubun/mitamae/pull/55)
- Allow local\_ruby\_block to notify changes [#56](https://github.com/k0kubun/mitamae/pull/56)

## v1.4.0
- Update mruby and mruby-io
- Share notifiable resources among recipes specified by ARGV

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
