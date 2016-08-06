class Specinfra::Command::Darwin::Base::Process < Specinfra::Command::Base::Process
  class << self
    def get(process, opts)
      "ps -A -c -o #{opts[:format]},command | grep -E -m 1 ^\\ *[0-9]+\\ +#{escape(process)}$ | awk '{print $1}'"
    end
  end
end
