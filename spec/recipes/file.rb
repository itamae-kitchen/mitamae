include_recipe 'user'

file "/tmp/file" do
  content "Hello World"
  mode "777"
end

###

file "/tmp/never_exist1" do
  only_if "exit 1"
end

file "/tmp/never_exist2" do
  not_if "exit 0"
end

file "/tmp/never_exist3" do
  only_if { false }
end

file "/tmp/never_exist4" do
  not_if { true }
end

###

file "/tmp/never_exist4" do
  action :nothing
end

file "/tmp/file1" do
  content "Hello, World"
end

file "/tmp/file1" do
  content "Hello, World"
  notifies :create, "file[/tmp/never_exist4]"
end

#####

file "/tmp/file_create_without_content" do
  content "Hello, World"
end

file "/tmp/file_create_without_content" do
  owner "itamae"
  group "itamae"
  mode "600"
end

#####

execute 'echo -n 1 > /tmp/file_edit_notifies' do
  action :nothing
end

file '/tmp/file_edit_sample' do
  content 'Hello, world'
  owner 'itamae'
  group 'itamae'
  mode '444'
end

file '/tmp/file_edit_sample' do
  action :edit
  owner 'itamae2'
  group 'itamae2'
  mode '400'
  block do |content|
    content.gsub!('world', 'Itamae')
  end
  notifies :run, "execute[echo -n 1 > /tmp/file_edit_notifies]"
end

file '/tmp/file_edit_keeping_mode_owner' do
  content 'Hello, world'
  owner 'itamae'
  group 'itamae'
  mode '444'
end

# This should use `owner`/`group` instead, but for keeping compatibility with itamae.
execute 'chmod -t /tmp' # send_tempfile may fail without this
file '/tmp/root_owned_tempfile_operated_by_normal_user' do
  user 'itamae'
  content 'operated_by_itamae'
end

file '/tmp/file_edit_keeping_mode_owner' do
  action :edit
  block do |content|
    content.gsub!('world', 'Itamae')
  end
end

###

execute "f=/tmp/file_edit_with_content_change_updates_timestamp && echo 'Hello, world' > $f && touch -d 2016-05-02T01:23:45Z $f"

file "/tmp/file_edit_with_content_change_updates_timestamp" do
  action :edit
  block do |content|
    content.gsub!('world', 'Itamae')
  end
end

###

execute "touch -d 2016-05-02T12:34:56Z /tmp/file_edit_without_content_change_keeping_timestamp"

file "/tmp/file_edit_without_content_change_keeping_timestamp" do
  action :edit
  block do |content|
    # no change
  end
end

###

file '/tmp/file_without_content_change_updates_mode_and_owner' do
  action :create
  content 'Hello, world'
  owner 'itamae'
  group 'itamae'
  mode '444'
end

file '/tmp/file_without_content_change_updates_mode_and_owner' do
  action :create
  content 'Hello, world' # no change
  owner 'itamae2'
  group 'itamae2'
  mode '666'
end

###

execute "touch -d 2016-05-01T01:23:45Z /tmp/file_with_content_change_updates_timestamp"

file "/tmp/file_with_content_change_updates_timestamp" do
  content "Hello, world"
end

###

execute "f=/tmp/file_without_content_change_keeping_timestamp && echo 'Hello, world' > $f && touch -d 2016-05-01T12:34:56Z $f"

file "/tmp/file_without_content_change_keeping_timestamp" do
  content "Hello, world\n"
end

###

file '/tmp/empty_file_with_owner' do
  action :create
  mode '600'
  owner 'itamae'
  group 'itamae'
end

file '/tmp/explicit_empty_file_with_owner' do
  action :create
  content ''
  mode '600'
  owner 'itamae'
  group 'itamae'
end

### Test notification on file change

execute 'echo -n 1 > /tmp/file_changed_notifies' do
  action :nothing
end

file '/tmp/file_changed_sample' do
  owner 'itamae'
  group 'itamae'
  mode '644'
  content 'Change me'
end

file '/tmp/file_changed_sample' do
  owner 'itamae'
  group 'itamae'
  mode '644'
  content 'Changed'
  notifies :run, 'execute[echo -n 1 > /tmp/file_changed_notifies]'
end
