module MItamae
  module ResourceExecutor
    class File < Base
      def apply
        if desired.exist
          if !current.exist && !@temppath
            File.open(attributes.path, 'a') {}
          end

          change_target = @modified ? @temppath : attributes.path

          if desired.mode
            run_specinfra(:change_file_mode, change_target, desired.mode || current.mode)
          end

          if desired.owner || desired.group
            run_specinfra(:change_file_owner, change_target, desired.owner || current.owner, desired.group || current.group)
          end

          if @modified
            run_specinfra(:copy_file, @temppath, attributes.path) # NOTE: currently cleaned in run_action
            updated!
          end
        else
          if FileTest.file?(desired.path)
            run_specinfra(:remove_file, desired.path)
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
        current.exist = FileTest.exist?(attributes.path)
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

      def set_desired_attributes(desired, action)
        case action
        when :create
          desired.exist = true
        when :delete
          desired.exist = false
        when :edit
          desired.exist = true
          desired.mode  ||= run_specinfra(:get_file_mode, desired.path).stdout.chomp
          desired.owner ||= run_specinfra(:get_file_owner_user, desired.path).stdout.chomp
          desired.group ||= run_specinfra(:get_file_owner_group, desired.path).stdout.chomp
          if !@runner.dry_run? || FileTest.exist?(desired.path)
            content = ::File.read(desired.path)
            attributes.block.call(content)
            desired.content = content
          end
        end
        desired.mode = normalize_mode(desired.mode) if desired.mode
      end

      def pre_action
        send_tempfile
        compare_file
      end

      def normalize_mode(mode)
        sprintf("%4s", mode).gsub(/ /, '0')
      end

      def show_differences
        super

        if @temppath && desired.exist
          show_content_diff
        end
      end

      def compare_to
        if current.exist
          desired.path
        else
          '/dev/null'
        end
      end

      def compare_file
        @modified = false
        unless @temppath
          return
        end

        case run_command(["diff", "-q", compare_to, @temppath], error: false).exit_status
        when 1
          # diff found
          @modified = true
        when 2
          # error
          raise MItamae::Backend::CommandExecutionError, "diff command exited with 2"
        end
      end

      def show_content_diff
        if @modified
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

      def send_tempfile
        if !desired.content && !content_file
          @temppath = nil
          return
        end

        # XXX: `runner.tmpdir` is changed to '/tmp'
        @temppath = ::File.join('/tmp', Time.now.to_f.to_s)

        File.open(@temppath, 'a') {}
        run_specinfra(:change_file_mode, @temppath, '0600')

        if content_file
          copy_file(content_file, @temppath)
        else
          File.open(@temppath, 'w') do |f|
            f.write(desired.content)
          end
        end
      end

      # This could be slow and inefficient for large files, but I believe no
      # one manages large files by file resource. Most files are small plain
      # text files (e.g. configuration files).
      def copy_file(src, dst)
        File.open(src) do |fin|
          File.open(dst, 'w') do |fout|
            fout.write(fin.read)
          end
        end
      end
    end
  end
end
