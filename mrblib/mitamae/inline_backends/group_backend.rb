module MItamae
  module InlineBackends
    class GroupBackend
      PRIVATE_METHODS = %i[get_group_entry]

      def runnable?(type, *args)
        !PRIVATE_METHODS.include?(type) && respond_to?(type)
      end

      def run(type, *args)
        send(type, *args)
      end

      def get_group_entry(group_name, &block)
        group = Etc.getgrnam(group_name)
        if group
          output = block.call(group)
          Specinfra::CommandResult.new(stdout: output, stderr: '', exit_status: 0)
        else
          Specinfra::CommandResult.new(stdout: '', stderr: '', exit_status: 1)
        end
      end

      def check_group_exists(group_name)
        Etc.getgrnam(group_name) != nil
      end

      def get_group_gid(group_name)
        get_group_entry(group_name) { |gr| gr.gid.to_s }
      end
    end
  end
end
