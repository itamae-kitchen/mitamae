module Itamae
  module Resource
    class User < Base
      define_attribute :action, default: :create
      define_attribute :username, type: String, default_name: true
      define_attribute :gid, type: [Integer, String]
      define_attribute :home, type: String
      define_attribute :password, type: String
      define_attribute :system_user, type: [TrueClass, FalseClass]
      define_attribute :uid, type: Integer
      define_attribute :shell, type: String
      define_attribute :create_home, type: [TrueClass, FalseClass], default: false

      self.available_actions = [:create]
    end
  end
end
