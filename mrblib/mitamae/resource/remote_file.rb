module MItamae
  module Resource
    class RemoteFile < File
      attr_accessor :recipe_dir
      define_attribute :source, type: [String, Symbol], default: :auto

      self.available_actions = [:create, :delete]
    end
  end
end
