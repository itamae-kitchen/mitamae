# mitamae's plugin system

mitamae supports plugins for resources and recipes. Unlike Itamae, it's not achieved by gem or mrbgem.
It's dynamically loaded from `./plugins` directory searched from a working directory.

Note that this feature is experimental for now and load paths may be changed in the future.

## `plugins` directory

By default, it loads plugin repositories under `./plugins` directory, based on a working directory of mitamae process.
If you put plugins in `/path/to/plugins`, you can `cd` to the directory which has `plugins`.

```
cd /path/to
mitamae local ...
```

Since mitamae v1.10.1, you can also specify the plugins directory by a command line option.

```
mitamae local --plugins=/path/to/plugins ...
```

## How to create and use plugin
### Resource

1. Create a repository named `mitamae-plugin-resource-sample` or `itamae-plugin-resource-sample`.
2. Implement `MItamae::Plugin::Resource::Sample` and `MItamae::Plugin::ResourceExecutor::Sample` like mitamae's internal classes. Put sources in `mitamae-plugin-resource-sample/mrblib/**/*.rb`.
3. Put it as git submodule to `./plugins/mitamae-plugin-resource-sample` or `itamae-plugin-resource-sample`.

See [itamae-plugin-resource-cask](https://github.com/k0kubun/itamae-plugin-resource-cask) for example.

### Recipe

1. Create a repository named `mitamae-plugin-recipe-sample` or `itamae-plugin-recipe-sample`.
2. Write a recipe in `mitamae-plugin-recipe-sample/mrblib/mitamae/plugin/recipe/`.
  - To `include_recipe 'sample'`, put a recipe to `mitamae-plugin-recipe-sample/mrblib/mitamae/plugin/recipe/sample/default.rb` or `mitamae-plugin-recipe-sample/mrblib/mitamae/plugin/recipe/sample.rb`.
  - To `include_recipe 'sample::example'`, put a recipe to `mitamae-plugin-recipe-sample/mrblib/mitamae/plugin/recipe/sample/example.rb`.
3. Put it as git submodule to `./plugins/mitamae-plugin-recipe-sample` or `itamae-plugin-recipe-sample`.

See [itamae-plugin-recipe-rbenv](https://github.com/k0kubun/itamae-plugin-recipe-rbenv) for example.
