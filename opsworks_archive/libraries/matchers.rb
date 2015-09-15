if defined?(ChefSpec)
  def extract_opsworks_archive(name)
    ChefSpec::Matchers::ResourceMatcher.new(:opsworks_archive, :extract, name)
  end
end
