module Specinfra
  module Command
    class Base
      class NotImplementedError < Exception; end

      class << self
        def create
          self
        end

        def escape(target)
          str = case target
                when Regexp
                  target.source
                else
                  target.to_s
                end

          Shellwords.shellescape(str)
        end
      end
    end
  end
end
