if defined?(ChefSpec)
  def sync_opsworks_scm_checkout(name)
    ChefSpec::Matchers::ResourceMatcher.new(:opsworks_scm_checkout, :sync, name)
  end
end
