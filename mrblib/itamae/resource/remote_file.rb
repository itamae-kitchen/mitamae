module Itamae
  module Resource
    class RemoteFile < File
      attr_accessor :recipe_dir

      define_attribute :source, type: [String, Symbol], default: :auto
    end
  end
end
