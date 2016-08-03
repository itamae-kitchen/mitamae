module Itamae
  module ResourceExecutor
    class Git < Base
      DEPLOY_BRANCH = "deploy"

      def apply(_, desired)
        ensure_git_available

        new_repository = false

        if check_empty_dir
          cmd = ['git', 'clone']
          cmd << '--recursive' if desired.recursive
          cmd << desired.repository << desired.destination
          run_command(cmd)
          new_repository = true
        end

        target = if desired.revision
                   get_revision(desired.revision)
                 else
                   fetch_origin!
                   run_command_in_repo("git ls-remote origin HEAD | cut -f1").stdout.strip
                 end

        if new_repository || target != get_revision('HEAD')
          updated!

          deploy_old_created = false
          if current_branch == DEPLOY_BRANCH
            run_command_in_repo("git branch -m deploy-old")
            deploy_old_created = true
          end

          fetch_origin!
          run_command_in_repo(["git", "checkout", target, "-b", DEPLOY_BRANCH])

          if deploy_old_created
            run_command_in_repo("git branch -d deploy-old")
          end
        end
      end

      private

      def set_current_attributes(current, action)
        case action
        when :sync
          current.exist = run_specinfra(:check_file_is_directory, attributes.destination)
        end
      end

      def set_desired_attributes(desired, action)
        case action
        when :sync
          desired.exist = true
        end
      end

      def ensure_git_available
        unless run_command("which git", error: false).exit_status == 0
          raise "`git` command is not available. Please install git."
        end
      end

      def check_empty_dir
        run_command("test -z \"$(ls -A #{Shellwords.shellescape(attributes.destination)})\"", error: false).success?
      end

      def run_command_in_repo(*args)
        unless args.last.is_a?(Hash)
          args << {}
        end
        args.last[:cwd] = attributes.destination
        run_command(*args)
      end

      def current_branch
        run_command_in_repo("git rev-parse --abbrev-ref HEAD").stdout.strip
      end

      def get_revision(branch)
        result = run_command_in_repo("git rev-list #{Shellwords.shellescape(branch)}", error: false)
        unless result.exit_status == 0
          fetch_origin!
        end
        run_command_in_repo("git rev-list #{Shellwords.shellescape(branch)}").stdout.lines.first.strip
      end

      def fetch_origin!
        return if @origin_fetched
        @origin_fetched = true
        run_command_in_repo(['git', 'fetch', 'origin'])
      end
    end
  end
end

