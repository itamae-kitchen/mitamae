module ::MItamae
  module Plugin
    module ResourceExecutor
      class Test < ::MItamae::ResourceExecutor::Base
        def apply
          if desired.created
            run_command("echo #{desired.message}")
            options = { error: false }
            unless run_command('false', options).exit_status == 1
              raise 'run_command with a positional Hash option failed'
            end
            File.open('/tmp/mitamae-plugin-resource-test-file', 'w') do |io|
              io.write(__FILE__)
            end
          end
        end

        private

        def set_desired_attributes(desired, action)
          case action
          when :create
            desired.created = true
          else
            raise NotImplementedError, "unhandled action: '#{action}'"
          end
        end

        def set_current_attributes(current, action)
          case action
          when :create
            current.created = false
          else
            raise NotImplementedError, "unhandled action: '#{action}'"
          end
        end
      end
    end
  end
end
