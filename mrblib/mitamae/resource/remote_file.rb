module MItamae
  module Resource
    class RemoteFile < File
      define_attribute :source, type: [String, Symbol], default: :auto
      define_attribute :sensitive, type: [TrueClass, FalseClass], default: false

      self.available_actions = [:create, :delete]
    end
  end
end
