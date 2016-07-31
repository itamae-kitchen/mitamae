module Itamae
  module Executor
    class Base
      def initialize(resource, options = {})
        @resource = resource
        @shell    = options[:shell]
        @dry_run  = options[:dry_run]
      end
    end
  end
end
