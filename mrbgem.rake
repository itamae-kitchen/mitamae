MRuby::Gem::Specification.new('itamae') do |spec|
  spec.license = 'MIT'
  spec.author  = 'Takashi Kokubun'
  spec.summary = 'itamae'
  spec.bins    = ['itamae']

  spec.add_dependency 'mruby-dir',        mgem: 'mruby-dir'
  spec.add_dependency 'mruby-eval',       core: 'mruby-eval'
  spec.add_dependency 'mruby-exit',       core: 'mruby-exit'
  spec.add_dependency 'mruby-hash-ext',   core: 'mruby-hash-ext'
  spec.add_dependency 'mruby-hashie',     mgem: 'mruby-hashie'
  spec.add_dependency 'mruby-iijson',     mgem: 'mruby-iijson'
  spec.add_dependency 'mruby-mtest',      mgem: 'mruby-mtest'
  spec.add_dependency 'mruby-object-ext', core: 'mruby-object-ext'
  spec.add_dependency 'mruby-optparse',   mgem: 'mruby-optparse'
  spec.add_dependency 'mruby-print',      core: 'mruby-print'
  spec.add_dependency 'mruby-struct',     core: 'mruby-struct'
end
