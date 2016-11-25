module MItamae
  class Node
    ValidationError = Class.new(StandardError)

    attr_reader :mash

    def initialize(hash, backend)
      @mash = Hashie::Mash.new(hash)
      @backend = backend
    end

    def reverse_merge(other_hash)
      self.class.new(_reverse_merge(other_hash), @backend)
    end

    def reverse_merge!(other_hash)
      @mash.replace(_reverse_merge(other_hash))
    end

    def [](key)
      if @mash.has_key?(key)
        @mash[key]
      else
        fetch_inventory_value(key)
      end
    end

    private

    def _reverse_merge(other_hash)
      Hashie::Mash.new(other_hash).merge(@mash)
    end

    def method_missing(method, *args)
      if @mash.respond_to?(method)
        return @mash.send(method, *args)
      elsif args.empty? && value = fetch_inventory_value(method)
        return value
      end

      super
    end

    def respond_to?(method, priv = false)
      @mash.respond_to?(method, priv) || super
    end

    def fetch_inventory_value(key)
      @backend.host_inventory[key]
    end
  end
end
