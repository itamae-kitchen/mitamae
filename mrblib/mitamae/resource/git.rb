module MItamae
  module Resource
    class Git < Base
      define_attribute :action, default: :sync
      define_attribute :destination, type: String, default_name: true
      define_attribute :repository, type: String, required: true
      define_attribute :revision, type: String
      define_attribute :recursive, type: [TrueClass, FalseClass], default: false

      self.available_actions = [:sync]
    end
  end
end
