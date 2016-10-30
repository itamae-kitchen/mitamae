require 'spec_helper'

describe user('itamae') do
  it { should exist }
  it { should have_uid 1234 }
  it { should have_home_directory '/home/itamae' }
  it { should have_login_shell '/bin/dash' }
end
