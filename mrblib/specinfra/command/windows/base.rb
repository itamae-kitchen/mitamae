module Specinfra
  module Command
    class Windows
      class Base
        class << self
          def create
            self
          end

          private
          def create_command(command, using_ps1 = nil)
            Backend::PowerShell::Command.new do
              using using_ps1 if using_ps1
              exec command
            end
          end

          def windows_account account
            match = /((.+)\\)?(.+)/.match account
            domain = match[2]
            name = match[3]
            [name, domain]
          end
        end
      end
    end
  end
end
