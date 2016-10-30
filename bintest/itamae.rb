require 'open3'

BIN_PATH = File.join(File.dirname(__FILE__), "../mruby/bin/itamae")

assert('itamae') do
  output, status = Open3.capture2(BIN_PATH)
  assert_true status.success?, "Process did not exit cleanly"
end

assert('itamae version') do
  output, status = Open3.capture2(BIN_PATH, "version")
  assert_true status.success?, "Process did not exit cleanly"

  require_relative '../mrblib/itamae/version'
  assert_include output, Itamae::VERSION
end
