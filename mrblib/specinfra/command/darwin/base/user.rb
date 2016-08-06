class Specinfra::Command::Darwin::Base::User < Specinfra::Command::Base::User
  class << self
    def check_has_home_directory(user, path_to_home)
      "#{get_home_directory(user)} | grep -E '^#{escape(path_to_home)}$'"
    end

    def check_has_login_shell(user, path_to_shell)
      "finger #{escape(user)} | grep -E '^Directory' | awk '{ print $4 }' | grep -E '^#{escape(path_to_shell)}$'"
    end

    def get_home_directory(user)
      "finger #{escape(user)} | grep -E '^Directory' | awk '{ print $2 }'"
    end
  end
end
