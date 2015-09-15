version = node["opsworks_iisnode"]["version"]

download_file = "iisnode-full-v#{version}-x64.msi"
download_path = ::File.join(Chef::Config["file_cache_path"], download_file)

remote_file download_path do
  source "https://github.com/azure/iisnode/releases/download/v#{version}/#{download_file}"
  retries 2
end

windows_package "iisnode" do
  source download_path
end

batch "Unlock IIS handler configuration" do
  code '"%windir%\system32\inetsrv\appcmd.exe" unlock config -section:system.webServer/handlers'
end
