MRuby::Gem::Specification.new('itamae') do |spec|
  spec.license = 'MIT'
  spec.author  = 'Takashi Kokubun'
  spec.summary = 'itamae'
  spec.bins    = ['itamae']

  spec.add_dependency 'mruby-print', core: 'mruby-print'
  spec.add_dependency 'mruby-mtest', mgem: 'mruby-mtest'
  spec.add_dependency 'mruby-optparse', mgem: 'mruby-optparse'
end
