module MItamae
  class Notification < Struct.new(:defined_in_resource, :action, :target_resource_desc, :timing)
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

    def action_resource
      resource
    end

    private

    def find_resource_by_description
      defined_in_resource.recipe.root.all_resources.find do |resource|
        type, name = parse_description
        resource.resource_type == type && resource.resource_name == name
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
