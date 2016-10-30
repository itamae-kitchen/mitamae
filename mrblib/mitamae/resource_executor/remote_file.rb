module MItamae
  module ResourceExecutor
    class RemoteFile < File
      SourceNotFoundError = Class.new(StandardError)

      private

      def content_file
        source_file
      end

      def source_file
        @source_file ||= find_source_file
      end

      def find_source_file
        if attributes.source == :auto
          dirs = attributes.path.split(::File::SEPARATOR)
          dirs.shift if dirs.first == ""

          searched_paths = []
          dirs.size.times do |i|
            source_file_exts.each do |ext|
              path = ::File.join(@resource.recipe_dir, source_file_dir, "#{dirs[i..-1].join("/")}#{ext}")
              if ::File.exist?(path)
                MItamae.logger.debug "#{path} is used as a source file."
                return path
              else
                searched_paths << path
              end
            end
          end

          raise SourceNotFoundError, "source file is not found (searched paths: #{searched_paths.join(', ')})"
        else
          ::File.expand_path(attributes.source, @resource.recipe_dir)
        end
      end

      def source_file_dir
        "files"
      end

      def source_file_exts
        [""]
      end
    end
  end
end
