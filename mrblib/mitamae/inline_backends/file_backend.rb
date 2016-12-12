module MItamae
  module InlineBackends
    class FileBackend
      def runnable?(type, *args)
        respond_to?(type)
      end

      def run(type, *args)
        send(type, *args)
      end

      def check_file_is_directory(path)
        FileTest.directory?(path)
      end
    end
  end
end
