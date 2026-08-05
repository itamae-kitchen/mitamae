# Compatibility patches for mruby 3.4.0
#
# In mruby 3.4.0, module_function makes singleton methods private instead
# of public. This affects Shellwords and Open3 modules. Work around by
# redefining affected methods as explicit public singleton methods.

module Shellwords
  def self.shellescape(str)
    str = str.to_s
    return "''".dup if str.empty?

    str = str.dup
    str.gsub!(/([^A-Za-z0-9_\-.,:\/@\n])/, "\\\\\\1")
    str.gsub!(/\n/, "'\n'")
    str
  end

  def self.escape(str)
    shellescape(str)
  end

  def self.shelljoin(array)
    array.map { |arg| shellescape(arg) }.join(' ')
  end

  def self.join(array)
    shelljoin(array)
  end
end

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

# In mruby 3.4.0, Kernel#` is private. Make it accessible via public method.
module Kernel
  def `(cmd)
    IO.popen(cmd) { |io| io.read }
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

module MItamae
  # mruby 3.4.0 implements Ruby 3 style keyword argument separation, so a
  # trailing Hash is no longer folded into keyword arguments. Recipes and
  # plugins written against v1.x pass options as a positional Hash, e.g.
  # `run_command(cmd, opts)` or `run_command(cmd, { error: false })`, which
  # reaches `Backend#run_command` as a second positional argument and raises
  # `ArgumentError`. Fold it back into the keywords ourselves.
  #
  # Explicit keywords win over the Hash, so that a caller which builds options
  # from both sources (`run_command(cmd, opts, cwd: dir)`) behaves as written.
  def self.merge_trailing_options(args, opts)
    if args.size > 1 && args.last.is_a?(Hash)
      args = args.dup
      opts = args.pop.merge(opts)
    end
    [args, opts]
  end
end
