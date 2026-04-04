# Compatibility patches for mruby 3.4.0
#
# In mruby 3.4.0, module_function + class << self alias doesn't create
# public singleton methods properly. Redefine String#shellescape and
# Array#shelljoin to use shellescape/shelljoin directly.
class String
  def shellescape
    Shellwords.shellescape(self)
  end
end

class Array
  def shelljoin
    Shellwords.shelljoin(self)
  end
end
