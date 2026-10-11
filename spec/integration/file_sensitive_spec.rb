require 'spec_helper'
require 'tempfile'

describe 'file resource with sensitive' do
  # The logger writes to stdout, which `apply_recipe` can redirect into a file.
  def stdout_of_recipe(recipe)
    Tempfile.create('mitamae-stdout') do |f|
      apply_recipe(recipe, redirect: { out: f.path })
      File.read(f.path)
    end
  end

  before(:all) do
    @created = stdout_of_recipe('file_sensitive')
    @unchanged = stdout_of_recipe('file_sensitive')
  end

  it 'reports a diff without its content when the content changes' do
    expect(@created).to include('diff exists, but not displaying sensitive content')
    expect(@created).not_to include('Hello, Sensitive')
  end

  it 'reports no diff when the content does not change' do
    expect(@unchanged).not_to include('diff exists')
  end
end
