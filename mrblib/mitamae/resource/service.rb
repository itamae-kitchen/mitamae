module MItamae
  module Resource
    class Service < Base
      define_attribute :action, default: :nothing
      define_attribute :name, type: String, default_name: true
      define_attribute :provider, type: Symbol, default: nil

      self.available_actions = [:start, :stop, :restart, :reload, :enable, :disable]
    end
  end
end
