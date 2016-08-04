module Itamae
  module Resource
    class Service < Base
      define_attribute :action, default: :nothing
      define_attribute :name, type: String, default_name: true
      define_attribute :provider, type: Symbol, default: nil
    end
  end
end
