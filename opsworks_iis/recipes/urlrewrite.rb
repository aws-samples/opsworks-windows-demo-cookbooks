iis_urlrewrite_path = ::File.join(Chef::Config["file_cache_path"], "rewrite_amd64_en-US.msi")
iis_urlrewrite_url = "https://download.microsoft.com/download/1/2/8/128E2E22-C1B9-44A4-BE2A-5859ED1D4592/rewrite_amd64_en-US.msi"

remote_file iis_urlrewrite_path do
  source iis_urlrewrite_url
  retries 2
end

windows_package "IIS Rewrite URL extension" do
  source iis_urlrewrite_path
end
