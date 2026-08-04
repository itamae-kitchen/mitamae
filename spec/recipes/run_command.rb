unless run_command("echo -n Hello").stdout == "Hello"
  raise "run_command in a recipe failed"
end

unless run_command("false", error: false).exit_status == 1
  raise "run_command with keyword argument (error: false) failed"
end

define :run_command_in_definition do
  unless run_command("echo -n Hello").stdout == "Hello"
    raise "run_command in a definition failed"
  end
end

execute "echo Hello" do
  unless run_command("echo -n Hello").stdout == "Hello"
    raise "run_command in a resource failed"
  end
end
