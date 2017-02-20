local_ruby_block 'execute run_command' do
  block do
    unless run_command("echo -n Hello").stdout == "Hello"
      raise "run_command in local_ruby_block failed"
    end
  end
end

local_ruby_block "greeting" do
  block do
    MItamae.logger.info "板前"
  end
end

local_ruby_block 'create /tmp/local_ruby_block_executed' do
  block do
    File.open('/tmp/local_ruby_block_executed', 'w') {}
  end

  notifies :run, 'local_ruby_block[create /tmp/local_ruby_block_notified]'
end

local_ruby_block 'create /tmp/local_ruby_block_notified' do
  action :nothing

  block do
    File.open('/tmp/local_ruby_block_notified', 'w') {}
  end
end

local_ruby_block 'create /tmp/local_ruby_block_nothing' do
  action :nothing

  block do
    File.open('/tmp/local_ruby_block_nothing', 'w') {}
  end
end
