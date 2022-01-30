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

execute 'deluser --remove-home itamae3' do
  only_if 'id itamae3'
end

file '/tmp/itamae3-password-should-not-be-updated' do
  action :delete
end

file '/tmp/itamae3-password-should-be-updated' do
  action :delete
end

# salt: 'salt', password: 'password'
itamae3_encrypted_password = '$6$salt$IxDD3jeSOb5eB1CX5LBsqZFVkJdido3OUILO5Ifz5iwMuTS4XMS130MTSuDDl3aCI6WouIL9AjRbLCelDCy.g.'
# salt: 'salt', password: 'password2'
itamae3_encrypted_password2 = '$6$salt$j48aGM/5GaMl0CCDSihdu1QGIFET5rK.L/ZpznS41s/HgxCe/2sNJ5kU39.gBvsagjQldZ9K8zJg0N.W9zWGp1'

user 'create itamae3 user with password hash' do
  username 'itamae3'
  password itamae3_encrypted_password
end

user 'create itamae3 user with password hash again' do
  username 'itamae3'
  password itamae3_encrypted_password
  notifies :create, 'file[itamae3 password should not be updated]'
end

user 'change password of itamae3' do
  username 'itamae3'
  password itamae3_encrypted_password2
  notifies :create, 'file[itamae3 password should be updated]'
end

file 'itamae3 password should not be updated' do
  action :nothing
  path '/tmp/itamae3-password-should-not-be-updated'
end

file 'itamae3 password should be updated' do
  action :nothing
  path '/tmp/itamae3-password-should-be-updated'
end
