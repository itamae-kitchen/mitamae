module ::MItamae
  module Plugin
    module Resource
      class Test < ::MItamae::Resource::Base
        define_attribute :action, default: :create
        define_attribute :message, type: String, default_name: true

        self.available_actions = [:create]
      end
    end
  end
end
