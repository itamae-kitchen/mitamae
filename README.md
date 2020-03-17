# :sushi: mitamae [![Latest Version](https://img.shields.io/github/v/release/itamae-kitchen/mitamae)](https://github.com/itamae-kitchen/mitamae/releases) [![Build Status](https://travis-ci.org/itamae-kitchen/mitamae.svg?branch=master)](https://travis-ci.org/itamae-kitchen/mitamae)

mitamae is a tool to automate configuration management using a Chef-like DSL powered by mruby.

### Key Features

* **Fast** -
  mitamae is optimized for local execution. It uses C functions via mruby libraries for core operations where possible,
  instead of executing commands on a shell or over a SSH connection like other tools, which is very slow.

* **Simple** -
  Running mitamae doesn't require Chef Server, Berkshelf, Data Bags, or even RubyGems.
  The mitamae core provides only essential features. You can quickly be a master of mitamae.

* **Single Binary** -
  mitamae can be deployed by just transferring a single binary to servers.
  You don't need to rely on slow operations over a SSH connection to workaround deployment problems.

## Installation

Download a binary for your platform from [GitHub Releases](https://github.com/itamae-kitchen/mitamae/releases).

```bash
curl -L https://github.com/itamae-kitchen/mitamae/releases/latest/download/mitamae-x86_64-linux.tar.gz \
  | tar xvz
./mitamae-x86_64-linux help
```

## Getting Started

Create a recipe file as `recipe.rb`:

```rb
package 'nginx' do
  action :install
end

service 'nginx' do
  action [:enable, :start]
end
```

And then excute `mitamae local` command to apply a recipe to a local machine.

```diff
$ mv mitamae-x86_64-linux mitamae
$ ./mitamae local recipe.rb
 INFO : Starting mitamae...
 INFO : Recipe: /home/user/recipe.rb
 INFO :   package[nginx] installed will change from 'false' to 'true'
 INFO :   service[nginx] enabled will change from 'false' to 'true'
 INFO :   service[nginx] running will change from 'false' to 'true'
```

See `mitamae help local` for available options. `--log-level=debug` is helpful to inspect what's executed in detail.

## Documentation

mitamae was built as an alternative implementation of [Itamae](https://github.com/itamae-kitchen/itamae).
Therefore you may refer to resources related to Itamae for mitamae as well.

### How to write recipes

Please refer to [Itamae wiki](https://github.com/itamae-kitchen/itamae/wiki):

* [Resources](https://github.com/itamae-kitchen/itamae/wiki/Resources)
  - [directory resource](https://github.com/itamae-kitchen/itamae/wiki/directory-resource)
  - [execute resource](https://github.com/itamae-kitchen/itamae/wiki/execute-resource)
  - [file resource](https://github.com/itamae-kitchen/itamae/wiki/file-resource)
  - [gem\_package resource](https://github.com/itamae-kitchen/itamae/wiki/gem_package-resource)
  - [git resource](https://github.com/itamae-kitchen/itamae/wiki/git-resource)
  - [group resource](https://github.com/itamae-kitchen/itamae/wiki/group-resource)
  - [http\_request resource](https://github.com/itamae-kitchen/itamae/wiki/http_request-resource)
  - [link resource](https://github.com/itamae-kitchen/itamae/wiki/link-resource)
  - [local\_ruby\_block resource](https://github.com/itamae-kitchen/itamae/wiki/local_ruby_block-resource)
  - [package resource](https://github.com/itamae-kitchen/itamae/wiki/package-resource)
  - [remote\_directory resource](https://github.com/itamae-kitchen/itamae/wiki/remote_directory-resource)
  - [remote\_file resource](https://github.com/itamae-kitchen/itamae/wiki/remote_file-resource)
  - [service resource](https://github.com/itamae-kitchen/itamae/wiki/service-resource)
  - [template resource](https://github.com/itamae-kitchen/itamae/wiki/template-resource)
  - [user resource](https://github.com/itamae-kitchen/itamae/wiki/user-resource)
* [Definitions](https://github.com/itamae-kitchen/itamae/wiki/Definitions)
* [Including Recipes](https://github.com/itamae-kitchen/itamae/wiki/Including-Recipes)
* [Node Attributes](https://github.com/itamae-kitchen/itamae/wiki/Node-Attributes)
* [run\_command](https://github.com/itamae-kitchen/itamae/wiki/run_command)
* [Host Inventory](https://serverspec.org/host_inventory.html)

#### mitamae's original features

They should be ported to Itamae at some point.

* `not_if` / `only_if` can take a block instead of a command
* `file`, `template`, and `remote_file` have `atomic_update` attribute

### Plugins

Please see [PLUGINS.md](./PLUGINS.md) for how to install or create plugins for mitamae.

Find [mitamae plugins](https://github.com/search?q=mitamae-plugin) and
[Itamae plugins supporting mitamae](https://github.com/search?q=itamae-plugin+mitamae) on GitHub.

### mruby features

The DSL is based on mruby instead of standard Ruby unlike Chef and Itamae.
You may use the following mruby features in mitamae recipes.

* [mruby's built-in features](http://mruby.org/docs/api/)
  * Some features may not be available if not specified or used by
    [mrbgem.rake dependencies](https://github.com/itamae-kitchen/mitamae/blob/master/mrbgem.rake).
  * Check [`MRUBY_VERSION`](https://github.com/itamae-kitchen/mitamae/blob/master/Rakefile) used by mitamae
    and Latest News on [mruby.org](http://mruby.org/).
* [mruby-at\_exit](https://github.com/ksss/mruby-at_exit)
* [mruby-dir-glob](https://github.com/gromnitsky/mruby-dir-glob)
* [mruby-dir](https://github.com/iij/mruby-dir)
* [mruby-env](https://github.com/iij/mruby-env)
* [mruby-erb](https://github.com/k0kubun/mruby-erb)
* [mruby-etc](https://github.com/eagletmt/mruby-etc)
* [mruby-file-stat](https://github.com/ksss/mruby-file-stat)
* [mruby-hashie](https://github.com/k0kubun/mruby-hashie)
* [mruby-json](https://github.com/mattn/mruby-json)
* [mruby-open3](https://github.com/k0kubun/mruby-open3)
* [mruby-shellwords](https://github.com/k0kubun/mruby-shellwords)
* [mruby-tempfile](https://github.com/iij/mruby-tempfile)
* [mruby-uri](https://github.com/zzak/mruby-uri)
* [mruby-yaml](https://github.com/mrbgems/mruby-yaml)

### Supported platforms

* See [Releases](https://github.com/itamae-kitchen/mitamae/releases) for supported architectures.
* All [operating systems supported by Serverspec](https://serverspec.org/tutorial.html#multi_os_support)
  are supported since they share their underlying library, [Specinfra](https://github.com/mizzy/specinfra).
  * See [CHANGELOG](./CHANGELOG.md) or [mruby-specinfra](https://github.com/itamae-kitchen/mruby-specinfra) to find what Specinfra version is used.

### Running mitamae on servers

When you want to use mitamae on remote servers, you need to distribute a mitamae binary
and recipes to the servers and run them remotely. There are at least the following ways to do it:

* **rsync and ssh** -
  It's handy to send them using `rsync` and run them using `ssh` when you apply recipes to a few servers.
  [hocho](https://github.com/sorah/hocho) is a convenient tool to do this. While it's over a SSH connection,
  it's much faster than other tools which establish a SSH connection for each operation like `itamae ssh`.
* **deployment tool** -
  A more scalable way is to install an agent to each server and notify the agents to fetch mitamae
  and recipes from an object storage and run them.
  Deployment tools like [AWS CodeDeploy](https://aws.amazon.com/codedeploy/) are useful to achieve them.

### Migrating from Chef

While the DSL is inspired by Chef, there are some differences you need to keep in mind
when you migrate Chef recipes to mitamae recipes.

| Chef | mitamae |
|:-----|:--------|
| `cookbook_file` | Use `remote_file` or `template`, specifying a path with `source`. |
| `directory`'s `recursive true` | `directory` is `recursive true` by default |
| `ruby_block` | Use `local_ruby_block`. |
| `shell_out!` | Use `run_command`. `Open3.capture3` or `system` might suffice too. |
| `Chef::Log.*` | `MItamae.logger.*` |
| `Digest::*.hexdigest` | Use `*sum` command (e.g. `sha1sum`) as a workaround. |
| `bash` | Just use `execute` or specify `bash -c ...` with it. <br> mitamae's `--shell=/bin/bash` might also help. |
| `cron` | You may use [mitamae-plugin-resource-cron](https://github.com/k0kubun/mitamae-plugin-resource-cron). |
| `deploy_revision` | You may use [mitamae-plugin-resource-deploy\_revision](https://github.com/k0kubun/mitamae-plugin-resource-deploy_revision). <br> See also: [mitamae-plugin-resource-deploy\_directory](https://github.com/k0kubun/mitamae-plugin-resource-deploy_directory)|
| `runit_service` | You may use [mitamae-plugin-resource-runit\_service](https://github.com/k0kubun/mitamae-plugin-resource-runit_service). |

### Change Log

See [CHANGELOG.md](./CHANGELOG.md).

## Contributing

Please refer to [CONTRIBUTING.md](./CONTRIBUTING.md).

## License

[MIT License](./LICENSE)
