define :opsworks_nodejs_npm, :cwd => nil do
  batch "run npm install - #{params[:name]}" do
    cwd params[:cwd]
    code <<-EOC
      set PATH=%APPDATA%\\npm;%PROGRAMFILES(x86)%\\nodejs;%PATH%
      npm install
    EOC
    only_if { ::File.file? ::File.join(params[:cwd], "package.json") }
  end
end
