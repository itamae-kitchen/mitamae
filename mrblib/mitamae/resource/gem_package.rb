module MItamae
  module Resource
    class GemPackage < Base
      define_attribute :action, default: :install
      define_attribute :package_name, type: String, default_name: true
      define_attribute :gem_binary, type: [String, Array], default: 'gem'
      define_attribute :options, type: [String, Array], default: []
      define_attribute :version, type: String
      define_attribute :source, type: String

      self.available_actions = [:install, :upgrade]
    end
  end
end
