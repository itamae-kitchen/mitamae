# Original:
#   https://github.com/mizzy/specinfra/blob/v2.60.2/lib/specinfra/ext/string.rb
module Specinfra
  module StringUtils
    UNDERSCORE_REGEXP = /_/
    CAMEL_CASE_REGEXP = /[A-Z]+.*/

    class << self
      def to_camel_case(str)
        return str if str !~ UNDERSCORE_REGEXP && str =~ CAMEL_CASE_REGEXP
        str.split('_').map { |e| e.capitalize }.join
      end
    end
  end
end
