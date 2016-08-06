class Specinfra::Command::Darwin::Base::Port < Specinfra::Command::Base::Port
  class << self
    def check_is_listening(port, options={})
      regexp   = ":#{port} "
      protocol = options[:protocol] || 'tcp'
      protocol_options = case protocol
      when 'tcp'
        "-iTCP -sTCP:LISTEN"
      when 'tcp6'
        "-i6TCP -sTCP:LISTEN"
      when 'udp'
        "-iUDP"
      when 'udp6'
        "-i6UDP"
      end
      "lsof -nP #{protocol_options} | grep -- #{escape(regexp)}"
    end
  end
end
