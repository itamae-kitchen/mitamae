module MItamae
  class InlineBackend
    def initialize
      @backends = InlineBackends.constants.sort.map do |class_name|
        InlineBackends.const_get(class_name).new
      end
    end

    def find_backend(type, *args)
      @backends.find { |b| b.runnable?(type, *args) }
    end
  end
end
