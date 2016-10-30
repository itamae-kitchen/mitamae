user 'create itamae user' do
  uid 123
  username 'itamae'
  password '$1$ltOY8bZv$iZ57f1KAp8jwKViNm3pze.'
  home '/home/foo'
  shell '/bin/sh'
end

user 'create itamae user' do
  uid 1234
  username 'itamae'
  password '$1$TQz9gPMl$nHYrsA5W2ZdZ0Yn021BQH1'
  home '/home/itamae'
  shell '/bin/dash'
end

execute 'deluser --remove-home itamae2' do
  only_if 'id itamae2'
end

user 'create itamae2 user with create home directory' do
  username 'itamae2'
  create_home true
  home '/home/itamae2'
  shell '/bin/sh'
end
