MRuby::Gem::Specification.new('mitamae') do |spec|
  spec.license = 'MIT'
  spec.author  = [
    'Takashi Kokubun',
    'Ryota Arai',
    'Gosuke Miyashita',
  ]
  spec.summary = 'mitamae'
  spec.bins    = ['mitamae']

  spec.add_dependency 'mruby-dir',        mgem: 'mruby-dir'
  spec.add_dependency 'mruby-dir-glob',   mgem: 'mruby-dir-glob'
  spec.add_dependency 'mruby-enumerator', core: 'mruby-enumerator'
  spec.add_dependency 'mruby-env',        mgem: 'mruby-env'
  spec.add_dependency 'mruby-erb',      github: 'k0kubun/mruby-erb'
  spec.add_dependency 'mruby-eval',       core: 'mruby-eval'
  spec.add_dependency 'mruby-exit',       core: 'mruby-exit'
  spec.add_dependency 'mruby-hash-ext',   core: 'mruby-hash-ext'
  spec.add_dependency 'mruby-hashie',     mgem: 'mruby-hashie'
  spec.add_dependency 'mruby-iijson',     mgem: 'mruby-iijson'
  spec.add_dependency 'mruby-kernel-ext', core: 'mruby-kernel-ext'
  spec.add_dependency 'mruby-mtest',      mgem: 'mruby-mtest'
  spec.add_dependency 'mruby-object-ext', core: 'mruby-object-ext'
  spec.add_dependency 'mruby-open3',      mgem: 'mruby-open3'
  spec.add_dependency 'mruby-optparse',   mgem: 'mruby-optparse'
  spec.add_dependency 'mruby-print',      core: 'mruby-print'
  spec.add_dependency 'mruby-shellwords', mgem: 'mruby-shellwords'
  spec.add_dependency 'mruby-struct',     core: 'mruby-struct'
  spec.add_dependency 'mruby-symbol-ext', core: 'mruby-symbol-ext'
  spec.add_dependency 'mruby-tempfile',   mgem: 'mruby-tempfile'
  spec.add_dependency 'mruby-io',       github: 'k0kubun/mruby-io'
end
