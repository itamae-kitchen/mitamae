module MItamae
  module Resource
    class Template < RemoteFile
      attr_accessor :node
      define_attribute :variables, type: Hash, default: {}
      define_attribute :sensitive, type: [TrueClass, FalseClass], default: false

      self.available_actions = [:create, :delete]
    end
  end
end
