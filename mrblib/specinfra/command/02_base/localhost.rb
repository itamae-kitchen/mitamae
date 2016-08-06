class Specinfra::Command::Base::Localhost < Specinfra::Command::Base
  class << self
    def check_is_ec2_instance
      'curl --connect-timeout=1 http://169.254.169.254:80/'
    end
  end
end
