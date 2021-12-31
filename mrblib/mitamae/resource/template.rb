module MItamae
  module Resource
    class Template < RemoteFile
      attr_accessor :node
      define_attribute :variables, type: Hash, default: {}

      self.available_actions = [:create, :delete]
    end
  end
end
