version = node["opsworks_nodejs"]["node_version"]

download_file = "node-v#{version}-x86.msi"
download_path = ::File.join(Chef::Config["file_cache_path"], download_file)

remote_file download_path do
  source "https://nodejs.org/dist/v#{version}/#{download_file}"
  retries 2
end

windows_package "nodejs" do
  source download_path
end

batch "install npm version #{node['opsworks_nodejs']['npm_version']}" do
  code "\"%programfiles(x86)%\\nodejs\\npm\" -g install npm@#{node['opsworks_nodejs']['npm_version']}"
end

#npmrc does not exist when backed-in node is never called.
#batch "copy npmrc" do
#  code 'copy "%programfiles(x86)%\\nodejs\\node_modules\\npm\\npmrc" "%appdata%\\npm\\node_modules\\npm\\npmrc"'
#end
