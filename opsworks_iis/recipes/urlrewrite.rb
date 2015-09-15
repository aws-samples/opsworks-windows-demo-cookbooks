iis_urlrewrite_path = ::File.join(Chef::Config["file_cache_path"], "rewrite_2.0_rtw_x64.msi")
iis_urlrewrite_url = "http://go.microsoft.com/?linkid=9722532"

remote_file iis_urlrewrite_path do
  source iis_urlrewrite_url
  retries 2
end

windows_package "IIS Rewrite URL extension" do
  source iis_urlrewrite_path
end
