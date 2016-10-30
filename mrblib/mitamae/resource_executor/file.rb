module MItamae
  module ResourceExecutor
    class File < Base
      def apply(current, desired)
        if desired.exist
          if current.exist && !@temppath
            run_command(["touch", attributes.path])
          end

          change_target = attributes.modified ? @temppath : attributes.path

          if desired.mode
            run_specinfra(:change_file_mode, change_target, desired.mode || current.mode)
          end

          if desired.owner || desired.group
            run_specinfra(:change_file_owner, change_target, desired.owner || current.owner, desired.group || current.group)
          end

          if attributes.modified
            run_specinfra(:copy_file, @temppath, attributes.path) # NOTE: currently cleaned in run_action
          end
        else
          if run_specinfra(:check_file_is_file, attributes.path)
            run_specinfra(:remove_file, attributes.path)
          end
        end
      end

      private

      def run_action(action)
        super
        if @temppath
          run_specinfra(:remove_file, @temppath)
        end
      end

      def set_current_attributes(current, action)
        current.modified = false
        current.exist = @existed
        if current.exist
          current.mode = run_specinfra(:get_file_mode, attributes.path).stdout.chomp
          current.owner = run_specinfra(:get_file_owner_user, attributes.path).stdout.chomp
          current.group = run_specinfra(:get_file_owner_group, attributes.path).stdout.chomp
        else
          current.mode = nil
          current.owner = nil
          current.group = nil
        end
      end

      def set_desired_attributes(desired, action)
        # https://github.com/itamae-kitchen/itamae/blob/v1.9.9/lib/itamae/resource/file.rb#L15
        @existed = run_specinfra(:check_file_is_file, attributes.path)

        case action
        when :create
          desired.exist = true
        when :delete
          desired.exist = false
        end

        send_tempfile(desired)
        compare_file
      end

      def normalize_mode(mode)
        sprintf("%4s", mode).gsub(/ /, '0')
      end

      def show_differences(current, desired)
        current.mode = normalize_mode(current.mode) if current.mode
        desired.mode = normalize_mode(desired.mode) if desired.mode

        super

        if @temppath && desired.exist
          show_content_diff
        end
      end

      def compare_to
        if @existed
          attributes.path
        else
          '/dev/null'
        end
      end

      def compare_file
        attributes.modified = false
        unless @temppath
          return
        end

        case run_command(["diff", "-q", compare_to, @temppath], error: false).exit_status
        when 1
          # diff found
          attributes.modified = true
        when 2
          # error
          raise MItamae::Backend::CommandExecutionError, "diff command exited with 2"
        end
      end

      def show_content_diff
        if attributes.modified
          MItamae.logger.info "diff:"
          diff = run_command(["diff", "-u", compare_to, @temppath], error: false)
          diff.stdout.each_line do |line|
            color = if line.start_with?('+')
                      :green
                    elsif line.start_with?('-')
                      :red
                    else
                      :clear
                    end
            MItamae.logger.color(color) do
              MItamae.logger.info line.chomp
            end
          end
        else
          # no change
          MItamae.logger.debug "file content will not change"
        end
      end

      # will be overridden
      def content_file
        nil
      end

      def send_tempfile(desired)
        if !desired.content && !content_file
          @temppath = nil
          return
        end

        src = if content_file
                content_file
              else
                f = Tempfile.open('mitamae')
                f.write(desired.content)
                f.close
                f.path
              end

        # XXX: `runner.tmpdir` is changed to '/tmp'
        @temppath = ::File.join('/tmp', Time.now.to_f.to_s)

        run_command(["touch", @temppath])
        run_specinfra(:change_file_mode, @temppath, '0600')
        run_command(['cp', src, @temppath])

        run_specinfra(:change_file_mode, @temppath, '0600')
      end
    end
  end
end
