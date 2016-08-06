class Specinfra::Command::Debian::V8::Port < Specinfra::Command::Debian::Base::Port
  class << self
    include Specinfra::Command::Module::Ss
  end
end
