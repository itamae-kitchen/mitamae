module MItamae
  module Resource
    class HTTPRequest < File
      define_attribute :action, default: :get
      define_attribute :headers, type: Hash, default: {}
      define_attribute :message, type: String, default: ''
      define_attribute :redirect_limit, type: Integer, default: 10
      define_attribute :check_error, type: [TrueClass, FalseClass], default: false
      define_attribute :url, type: String, required: true

      self.available_actions = [:get, :post, :put, :delete]
    end
  end
end
