class Specinfra::Command::Base::Port < Specinfra::Command::Base
  class << self
    def check_is_listening(port, options={})
      pattern = ":#{port} "
      pattern = " #{options[:local_address]}#{pattern}" if options[:local_address]
      pattern = "^#{options[:protocol]} .*#{pattern}" if options[:protocol]
      "netstat -tunl | grep -- #{escape(pattern)}"
    end
  end
end
