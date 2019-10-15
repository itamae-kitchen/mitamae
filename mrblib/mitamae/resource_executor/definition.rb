module MItamae
  module ResourceExecutor
    # Dedicated for checking not_if/only_if of definition
    class Definition < Base
      public :skip_condition?

      private :execute, :apply
    end
  end
end
