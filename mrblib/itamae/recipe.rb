module Itamae
  class Recipe < Struct.new(:path, :children)
    def initialize(*)
      super
      self.children ||= []
    end
  end
end
