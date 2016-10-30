require 'open3'

BIN_PATH = File.join(File.dirname(__FILE__), "../mruby/bin/mitamae")

assert('mitamae') do
  output, status = Open3.capture2(BIN_PATH)
  assert_true status.success?, "Process did not exit cleanly"
end

assert('mitamae version') do
  output, status = Open3.capture2(BIN_PATH, "version")
  assert_true status.success?, "Process did not exit cleanly"

  require_relative '../mrblib/mitamae/version'
  assert_include output, MItamae::VERSION
end
