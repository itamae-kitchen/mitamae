module MItamae
  module ResourceExecutor
    class RemoteDirectory < Base
      def apply
        if desired.exist
          if FileTest.directory?(desired.path)
            run_specinfra(:remove_file, desired.path)
          end
          run_command("cp -r #{::File.join(@resource.recipe.dir, desired.source)} #{desired.path}")

          if desired.mode
            run_specinfra(:change_file_mode, desired.path, desired.mode)
          end
          if desired.owner || desired.group
            run_specinfra(:change_file_owner, desired.path, desired.owner, desired.group)
          end
        else
          if FileTest.directory?(desired.path)
            run_specinfra(:remove_file, desired.path)
          end
        end
      end

      private

      def set_current_attributes(current, action)
        case action
        when :create, :delete
          current.exist = run_specinfra(:check_file_is_directory, attributes.path)

          if current.exist
            current.mode = run_specinfra(:get_file_mode, attributes.path).stdout.chomp
            current.mode = normalize_mode(current.mode)
            current.owner = run_specinfra(:get_file_owner_user, attributes.path).stdout.chomp
            current.group = run_specinfra(:get_file_owner_group, attributes.path).stdout.chomp
          else
            current.mode = nil
            current.owner = nil
            current.group = nil
          end
        end
      end

      def set_desired_attributes(desired, action)
        case action
        when :create
          desired.exist = true
        when :delete
          desired.exist = false
        end
        desired.mode = normalize_mode(desired.mode) if desired.mode
      end

      def normalize_mode(mode)
        sprintf("%4s", mode).gsub(/ /, '0')
      end

      def show_differences
        super

        if current.exist
          diff = run_command(["diff", "-u", attributes.path, @temppath], error: false)
          if diff.exit_status == 0
            # no change
            MItamae.logger.debug "directory content will not change"
          else
            MItamae.logger.info "diff:"
            diff.stdout.each_line do |line|
              MItamae.logger.info "#{line.strip}"
            end
          end
        end
      end
    end
  end
end
