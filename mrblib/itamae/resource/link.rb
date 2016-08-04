module Itamae
  module Resource
    class Link < Base
      define_attribute :action, default: :create
      define_attribute :link, type: String, default_name: true
      define_attribute :to, type: String, required: true
      define_attribute :force, type: [TrueClass, FalseClass], default: false
    end
  end
end
