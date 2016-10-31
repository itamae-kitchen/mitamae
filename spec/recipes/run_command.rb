unless run_command("echo -n Hello").stdout == "Hello"
  raise "run_command in a recipe failed"
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
