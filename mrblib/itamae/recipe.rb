module Itamae
  class Recipe < Struct.new(:path, :children, :delayed_notifications)
    def initialize(*)
      super
      self.children ||= []
      self.delayed_notifications ||= []
    end
  end
end
