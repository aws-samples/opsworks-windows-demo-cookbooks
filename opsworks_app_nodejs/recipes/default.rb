Chef::Log.info "About to search apps"

# Search apps to be deployed. Without deploy:true filter all apps would be returned.
apps = search(:aws_opsworks_app, "deploy:true") rescue []
Chef::Log.info "Found #{apps.size} apps to deploy on the stack. Assuming they are all Node.JS apps."

apps.each do |app|
  Chef::Log.info "Deploying #{app["shortname"]}."

  app_source = app["app_source"]
  app_checkout = ::File.join(Chef::Config["file_cache_path"], app["shortname"])

  opsworks_scm_checkout app["shortname"] do
    destination      app_checkout
    repository       app_source["url"]
    revision         app_source["revision"]
    user             app_source["username"]
    password         app_source["password"]
    ssh_key          app_source["ssh_key"]
    type             app_source["type"]
  end

  app_deploy = ::File.join(node["opsworks_app_nodejs"]["deploy"], app["shortname"])

  directory app_deploy do
    action :create
    recursive true
    rights :full_control, "IIS_IUSRS", :applies_to_children => true, :applies_to_self => true if platform?("windows")
  end

  # Copy app to deployment directory
  batch "copy #{app["shortname"]}" do
    code "Robocopy.exe #{app_checkout} #{app_deploy} /MIR /XF .gitignore /XF web.config.erb /XD .git"
    returns (0..7).to_a
  end

  # Run 'npm_install'
  opsworks_nodejs_npm app["shortname"] do
    cwd app_deploy
  end

  # Render web.config, so it includes environment variables
  # This could be a separate file, which get included in web.config - however IISNode currently does not support this
  template "#{app['shortname']}/web.config" do
    path ::File.join(app_deploy, "web.config")
    source ::File.join(app_checkout, "web.config.erb")
    variables({
      :environment => app["environment"],
      :settings => (node["app"].is_a?(Hash) ? node["app"]["settings"] : nil)
    })
    local true
    only_if { ::File.file? ::File.join(app_checkout, "web.config.erb") }
  end

  # Create a new Site.
  # - this will probably break the moment multiple apps are deployed on the same host, as we re-use port 80 here
  # - IIS does not like /, so lets use \
  powershell_script "register #{app["shortname"]}" do
    code <<-EOC
       if ($null -eq (Get-Website | where-object { $_.name -eq '#{app["shortname"]}' })) {
         $physicalPath = "#{app_deploy.gsub(::File::SEPARATOR, ::File::ALT_SEPARATOR)}"
         Write-Host "Registering with physical path $physicalPath"
         New-Website -Name "#{app['shortname']}" -PhysicalPath "$physicalPath"
       }
    EOC
  end
end
