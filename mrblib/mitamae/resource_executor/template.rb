module MItamae
  module ResourceExecutor
    class Template < RemoteFile
      private

      def set_desired_attributes(desired, action)
        case action
        when :create
          if attributes.content.nil?
            desired.content = RenderContext.new(@resource).render_file(source_file)
          else
            if attributes.source != :auto
              MItamae.logger.warn(
                "Both `content` and `source` are specified in #{@resource.resource_type}" +
                "[#{@resource.resource_name}]. `content` will be used."
              )
            end
            desired.content = RenderContext.new(@resource).render(attributes.content)
          end
        end

        super
      end


      def content_file
        nil
      end

      def source_file_dir
        "templates"
      end

      def source_file_exts
        [".erb", ""]
      end

      class RenderContext
        def initialize(resource)
          @resource = resource

          @resource.attributes.variables.each_pair do |key, value|
            instance_variable_set("@#{key}".to_sym, value)
          end
        end

        def render_file(filename)
          render(::File.read(filename), filename: filename)
        end

        def render(template, filename: nil)
          ERB.new(template, nil, '-').tap do |erb|
            if filename
              erb.filename = filename
            end
          end.result(self)
        end

        def node
          @resource.node
        end
      end
    end
  end
end
