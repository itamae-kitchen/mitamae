module Itamae
  module Resource
    class Template < RemoteFile
      define_attribute :variables, type: Hash, default: {}

      self.available_actions = [:create, :delete, :edit]
    end
  end
end
