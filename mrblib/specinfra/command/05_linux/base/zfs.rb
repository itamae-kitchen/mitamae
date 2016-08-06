class Specinfra::Command::Linux::Base::Zfs < Specinfra::Command::Base::Zfs
  class << self
    include Specinfra::Command::Module::Zfs
  end
end
