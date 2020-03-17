module MItamae
  module Resource
    class File < Base
      define_attribute :action, default: :create
      define_attribute :path, type: String, default_name: true
      define_attribute :content, type: String, default: nil
      define_attribute :mode, type: String
      define_attribute :owner, type: String
      define_attribute :group, type: String
      define_attribute :block, type: Proc, default: proc {}
      define_attribute :atomic_update, type: [TrueClass, FalseClass], default: false

      self.available_actions = [:create, :delete, :edit]
    end
  end
end
