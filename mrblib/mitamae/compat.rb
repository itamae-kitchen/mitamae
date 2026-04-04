# Compatibility patches for mruby 3.4.0
#
# In mruby 3.4.0, module_function creates private singleton methods
# instead of public ones. Work around by inlining the implementation
# rather than delegating to Shellwords.
class String
  def shellescape
    str = self.to_s
    return "''".dup if str.empty?

    str = str.dup
    str.gsub!(/([^A-Za-z0-9_\-.,:\/@\n])/, "\\\\\\1")
    str.gsub!(/\n/, "'\n'")
    str
  end
end

class Array
  def shelljoin
    self.map { |arg| arg.to_s.shellescape }.join(' ')
  end
end
