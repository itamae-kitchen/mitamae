# Original:
#   https://github.com/mizzy/specinfra/blob/v2.60.2/lib/specinfra/ext/string.rb
module Specinfra
  module StringUtils
    class << self
      def to_camel_case(str)
        return str if str !~ /_/ && str =~ /[A-Z]+.*/
        str.split('_').map { |e| e.capitalize }.join
      end
    end
  end
end
