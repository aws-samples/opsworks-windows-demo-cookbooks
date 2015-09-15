node["opsworks_iis"]["features"].each do |feature|
  powershell_script "Install IIS feature - #{feature}" do
    code "add-windowsfeature #{feature}"
  end
end

include_recipe "opsworks_iis::urlrewrite"

powershell_script "drop 'Default Web Site' from IIS" do
  code <<-EOC
    if ($null -ne (Get-WebSite | where-object { $_.name -eq 'Default Web Site' })) {
      Remove-Website -Name 'Default Web Site'
    }
  EOC
end

service "w3svc" do
  action [ :enable, :start ]
end
