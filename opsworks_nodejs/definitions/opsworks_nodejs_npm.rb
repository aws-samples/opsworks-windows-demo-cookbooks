define :opsworks_nodejs_npm, :cwd => nil do

  # Using npm cache clean to work around permissions issues. Still seem to be present in npm.
  # See also http://blogs.msdn.com/b/matt-harrington/archive/2012/02/23/how-to-fix-node-js-npm-permission-problems.aspx
  batch "run npm cache clean - #{params[:name]}" do
    cwd params[:cwd]
    code <<-EOC
      set PATH=%APPDATA%\\npm;%PROGRAMFILES(x86)%\\nodejs;%PATH%
      npm cache clean
    EOC
    only_if { ::File.file? ::File.join(params[:cwd], "package.json") }
  end

  batch "run npm install - #{params[:name]}" do
    cwd params[:cwd]
    code <<-EOC
      set PATH=%APPDATA%\\npm;%PROGRAMFILES(x86)%\\nodejs;%PATH%
      npm install
    EOC
    only_if { ::File.file? ::File.join(params[:cwd], "package.json") }
  end
end
