module Itamae
  module Resource
    class Template < RemoteFile
      attr_accessor :node
      define_attribute :variables, type: Hash, default: {}

      self.available_actions = [:create, :delete, :edit]
    end
  end
end
