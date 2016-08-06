class Specinfra::Command::Base
  class << self
    class NotImplementedError < Exception; end

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
