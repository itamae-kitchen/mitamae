define :nested_params do
  execute "echo #{params[:name]} > /tmp/nested_params" do
    # Note: This reference is mitamae's original feature.
    # Itamae raises NoMethodError.
    only_if params[:name]
  end
end
