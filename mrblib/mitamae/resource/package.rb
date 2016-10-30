module MItamae
  module Resource
    class Package < Base
      define_attribute :action, default: :install
      define_attribute :name, type: String, default_name: true
      define_attribute :version, type: String
      define_attribute :options, type: String

      self.available_actions = [:install, :remove]
    end
  end
end
