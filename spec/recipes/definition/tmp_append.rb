define :tmp_append do
  path = params[:name]

  local_ruby_block 'tmp_append' do
    block do
      File.open('/tmp/append', 'a') { |f| f.print path }
    end
  end
end
