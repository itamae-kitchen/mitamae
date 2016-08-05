module Itamae
  module ResourceExecutor
    class Template < RemoteFile
      private

      def set_desired_attributes(desired, action)
        case action
        when :create
          desired.content = RenderContext.new(@resource).render_file(source_file)
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

        def render_file(src)
          template = ::File.read(src)
          ERB.new(template, nil, '-').tap do |erb|
            erb.filename = src
          end.result(self)
        end

        def node
          @resource.node
        end
      end
    end
  end
end
