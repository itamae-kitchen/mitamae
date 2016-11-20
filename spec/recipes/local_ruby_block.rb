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
