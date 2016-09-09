module Itamae
  module Resource
    class Group < Base
      define_attribute :action, default: :create
      define_attribute :groupname, type: String, default_name: true
      define_attribute :gid, type: Integer

      self.available_actions = [:create]
    end
  end
end
