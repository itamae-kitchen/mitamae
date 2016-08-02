# Almost the same implementation as original Specinfra::CommandFactory.
# https://github.com/mizzy/specinfra/blob/v2.60.2/lib/specinfra/command_factory.rb
module Specinfra
  class CommandFactory
    # This constant should match `*` of `Specinfra::Command::*` and `Specinfra::Command::Windows::*`.
    # Since ObjectSpace is not available in mruby, defining specinfra v2.60.2's snapshot.
    RESOURCE_TYPES = %w[
      base bond bridge cron feature file fstab group host
      hot_fix iis_app_pool iis_website interface inventory ip6tables
      ipfilter ipnat iptables kernel_module localhost lxc_container
      mail_alias package port ppa process registry_key routing_table
      scheduled_task selinux selinux_module service user
      v10 v12 v15 v5 v57 v6 v7 v8 yumrepo zfs
    ]

    # @param [Hash] - Hash like `{:family=>"arch", :release=>nil, :arch=>"x86_64"}`
    def initialize(os_info)
      @os_info = os_info
    end

    # ex1) @os_info = { family: "debian", release: "8" }, command = :get_package_version
    #   Try to call Specinfra::Command::Base::Package.get_version(*args), but raise NotImplementedError.
    #
    # ex2) @os_info = { family: "debian", release: "7" }, command = :get_package_version
    #   Call Specinfra::Command::Debian::Base::Package.get_version(*args).
    def get(command, *args)
      action, resource_type, subaction = breakdown(command)
      command_class = create_command_class(resource_type)
      method = [action, subaction].compact.join('_')

      if command_class.respond_to?(method)
        command_class.send(method, *args)
      else
        message = "#{method} is not implemented in #{command_class}. "
        message << "Maybe #{version_class}::#{StringUtils.to_camel_case(resource_type)} is missing?"
        raise NotImplementedError.new(message)
      end
    end

    private

    # ex1) @os_info = { family: "debian", release: "8" }, resource_type = "package"
    #   Since Specinfra::Command::Debian::V8::Package is not defined, Specinfra::Command::Base::Package is returned.
    #
    # ex2) @os_info = { family: "debian", release: "7" }, resource_type = "package"
    #   Returns Specinfra::Command::Debian::Base::Package.
    def create_command_class(resource_type)
      command_class = version_class.const_get(StringUtils.to_camel_case(resource_type)) rescue nil
      # Module#< is not defined on mruby.
      # if command_class.nil? || ((command_class < Specinfra::Command::Base).nil? && (command_class < Specinfra::Command::Windows::Base).nil?)
      if command_class.nil? || (!command_class.new.is_a?(Specinfra::Command::Base) && !command_class.new.is_a?(Specinfra::Command::Windows::Base))
        command_class = Specinfra::Command::Base.const_get(StringUtils.to_camel_case(resource_type))
      end

      begin
        command_class.create(@os_info)
      rescue ArgumentError
        command_class.create
      end
    end

    # { family: "debian", release: "8" } #=> Specinfra::Command::Debian::V8
    # { family: "debian", release: "7" } #=> Specinfra::Command::Debian::Base
    # { family: nil,      release: ... } #=> Specinfra::Command::Base
    # { family: "arch",   release: nil } #=> Specinfra::Command::Arch::Base
    # { family: "base",   release: nil } #=> nil
    def version_class
      if @os_info[:family] && @os_info[:release]
        begin
          os_class.const_get("V#{@os_info[:release].to_i}")
        rescue
          os_class.const_get('Base')
        end
      elsif @os_info[:family].nil?
        Specinfra::Command::Base
      elsif @os_info[:family] != 'base' && @os_info[:release].nil?
        os_class.const_get('Base')
      end
    end

    def os_class
      if @os_info[:family]
        Specinfra::Command.const_get(@os_info[:family].capitalize)
      else
        Specinfra::Command::Base
      end
    end

    # breakdown(:get_package_version) #=> ["get", "package", "version"]
    def breakdown(command)
      types = RESOURCE_TYPES.join('|')
      match = command.to_s.match(/^([^_]+)_(#{types})_?(.+)?$/)
      if match.nil?
        message =  "Could not break down `#{command}' to appropriate type and method.\n"
        message << "The method name shoud be in the form of `action_type_subaction'."
        raise message
      end
      return match[1], match[2], match[3]
    end
  end
end
