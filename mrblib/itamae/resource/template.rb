module Itamae
  module Resource
    class Template < RemoteFile
      define_attribute :variables, type: Hash, default: {}
    end
  end
end
