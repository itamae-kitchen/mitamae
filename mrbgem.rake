MRuby::Gem::Specification.new('mitamae') do |spec|
  spec.license = 'MIT'
  spec.author  = [
    'Takashi Kokubun',
    'Ryota Arai',
  ]
  spec.summary = 'mitamae'
  spec.bins    = ['mitamae']

  spec.add_dependency 'mruby-enumerator',  core: 'mruby-enumerator'
  spec.add_dependency 'mruby-eval',        core: 'mruby-eval'
  spec.add_dependency 'mruby-exit',        core: 'mruby-exit'
  spec.add_dependency 'mruby-hash-ext',    core: 'mruby-hash-ext'
  spec.add_dependency 'mruby-kernel-ext',  core: 'mruby-kernel-ext'
  spec.add_dependency 'mruby-object-ext',  core: 'mruby-object-ext'
  spec.add_dependency 'mruby-print',       core: 'mruby-print'
  spec.add_dependency 'mruby-struct',      core: 'mruby-struct'
  spec.add_dependency 'mruby-symbol-ext',  core: 'mruby-symbol-ext'

  spec.add_dependency 'mruby-dir',         mgem: 'mruby-dir'
  spec.add_dependency 'mruby-dir-glob',    mgem: 'mruby-dir-glob'
  spec.add_dependency 'mruby-env',         mgem: 'mruby-env'
  spec.add_dependency 'mruby-file-stat',   mgem: 'mruby-file-stat'
  spec.add_dependency 'mruby-hashie',      mgem: 'mruby-hashie',      checksum_hash: 'bfdbb8aebc8786bc9e88469dae87a8dfe8ec4300'
  spec.add_dependency 'mruby-httprequest', mgem: 'mruby-httprequest'
  spec.add_dependency 'mruby-iijson',      mgem: 'mruby-iijson'
  spec.add_dependency 'mruby-open3',       mgem: 'mruby-open3',       checksum_hash: 'a38a5464e1ce9f65f87535ade26ae10030bc3239'
  spec.add_dependency 'mruby-optparse',    mgem: 'mruby-optparse'
  spec.add_dependency 'mruby-shellwords',  mgem: 'mruby-shellwords',  checksum_hash: '2a284d99b2121615e43d6accdb0e4cde1868a0d8'
  spec.add_dependency 'mruby-specinfra',   mgem: 'mruby-specinfra',   checksum_hash: 'ebfb79f312b910f13b70186fbedfdd5ef61f2988'
  spec.add_dependency 'mruby-tempfile',    mgem: 'mruby-tempfile'
  spec.add_dependency 'mruby-yaml',        mgem: 'mruby-yaml'

  spec.add_dependency 'mruby-erb',       github: 'k0kubun/mruby-erb', checksum_hash: '978257e478633542c440c9248e8cdf33c5ad2074'
  spec.add_dependency 'mruby-io',        github: 'k0kubun/mruby-io',  checksum_hash: '6cb5d157341ceec8f5818ce0000fa99920258c11'
end
