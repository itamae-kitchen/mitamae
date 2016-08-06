class Specinfra::Command::Base::Process < Specinfra::Command::Base
  class << self
    def get(process, opts)
      "ps -C #{escape(process)} -o #{opts[:format]} | head -1"
    end

    def count(process)
      "ps aux | grep -w -- #{escape(process)} | grep -v grep | wc -l"
    end

    def check_is_running(process)
      "ps aux | grep -w -- #{escape(process)} | grep -qv grep"
    end

    def check_count(process,count)
      "test $(ps aux | grep -w -- #{escape(process)} | grep -v grep | wc -l) -eq #{escape(count)}"
    end
  end
end
