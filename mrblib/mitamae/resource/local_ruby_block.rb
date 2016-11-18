module MItamae
  module Resource
    class LocalRubyBlock < Base
      define_attribute :action, default: :run
      define_attribute :block, type: Proc

      self.available_actions = [:run]
    end
  end
end
