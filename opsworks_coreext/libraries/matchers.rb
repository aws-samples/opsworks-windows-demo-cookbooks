if defined?(ChefSpec)
  def install_windows_package(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_package, :install, resource_name)
  end
end
