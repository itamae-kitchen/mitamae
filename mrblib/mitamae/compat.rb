# Compatibility patches for mruby 3.4.0
#
# In mruby 3.4.0, module_function makes singleton methods private instead
# of public. This affects Shellwords and Open3 modules. Work around by
# redefining affected methods as explicit public singleton methods.

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

# Redefine Open3 module methods as public class methods.
# The original module_function definitions in mruby-open3 become private
# singleton methods in mruby 3.4.0.
module Open3
  def self.capture3(*cmd)
    opts = {}
    if cmd.last.is_a?(Hash)
      opts = cmd.pop.dup
    end
    out_r, out_w = IO.pipe
    err_r, err_w = IO.pipe
    opts[:out] = out_w.to_i
    opts[:err] = err_w.to_i
    pid = spawn(*cmd, opts)

    out_w.close
    err_w.close

    stdout = ''
    stderr = ''

    remaining_ios = [out_r, err_r]
    buf = ''
    until remaining_ios.empty?
      readable_ios, = IO.select(remaining_ios)
      readable_ios.each do |io|
        begin
          io.sysread(1024, buf)
          if io == out_r
            stdout << buf
          else
            stderr << buf
          end
        rescue EOFError
          io.close unless io.closed?
          remaining_ios.delete(io)
        end
      end
    end

    _, status = Process.waitpid2(pid)
    [stdout, stderr, status]
  end

  def self.capture2(*cmd)
    stdout, stderr, status = capture3(*cmd)
    $stderr.print(stderr)
    [stdout, status]
  end

  def self.capture2e(*cmd)
    opts = {}
    if cmd.last.is_a?(Hash)
      opts = cmd.pop.dup
    end
    out_r, out_w = IO.pipe
    opts[:out] = out_w.to_i
    opts[:err] = out_w.to_i
    pid = spawn(*cmd, opts)

    out_w.close

    stdout_and_stderr_str = ''

    remaining_ios = [out_r]
    buf = ''
    until remaining_ios.empty?
      readable_ios, = IO.select(remaining_ios)
      readable_ios.each do |io|
        begin
          io.sysread(1024, buf)
          stdout_and_stderr_str << buf
        rescue EOFError
          io.close unless io.closed?
          remaining_ios.delete(io)
        end
      end
    end

    _, status = Process.waitpid2(pid)
    [stdout_and_stderr_str, status]
  end
end
