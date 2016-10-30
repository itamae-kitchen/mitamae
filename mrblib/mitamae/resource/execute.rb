module MItamae
  module Resource
    class Execute < Base
      define_attribute :action, default: :run
      define_attribute :command, type: String, default_name: true

      self.available_actions = [:run]
    end
  end
end
