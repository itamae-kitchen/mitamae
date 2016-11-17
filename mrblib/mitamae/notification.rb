module MItamae
  class Notification < Struct.new(:recipe, :action, :target_resource_desc, :timing)
    NotFoundError = Class.new(StandardError)
    ParseError = Class.new(StandardError)

    def self.create(*args)
      new(*args).tap(&:validate!)
    end

    def validate!
      unless [:delay, :delayed, :immediately].include?(timing)
        MItamae.logger.error "'#{timing}' is not valid notification timing. (Valid option is delayed or immediately)"
        exit 1
      end
    end

    def delayed?
      [:delay, :delayed].include?(timing)
    end

    def immediately?
      timing == :immediately
    end

    def resource
      find_resource_by_description
    end

    private

    def find_resource_by_description
      recipe.children.find do |child|
        type, name = parse_description
        child.respond_to?(:resource_type) && child.resource_type == type &&
          child.respond_to?(:resource_name) && child.resource_name == name
      end.tap do |resource|
        unless resource
          raise NotFoundError, "'#{target_resource_desc}' resource is not found."
        end
      end
    end

    def parse_description
      if /\A([^\[]+)\[([^\]]+)\]\z/ =~ target_resource_desc
        [$1, $2]
      else
        raise ParseError, "'#{target_resource_desc}' doesn't represent a resource."
      end
    end
  end
end
