require "chefspec"

describe "opsworks_iis::urlrewrite" do
  before do
    stub_const('File::ALT_SEPARATOR', "\\")
  end

  let(:chef_runner) do
    ChefSpec::SoloRunner.new
  end

  let(:chef_run) do
    chef_runner.converge(described_recipe)
  end

  context "Internet Information Server" do
    it "download IIS Rewrite URL extension" do
      expect(chef_run).to create_remote_file(File.join(Chef::Config["file_cache_path"], "rewrite_2.0_rtw_x64.msi"))
    end

    it "installs IIS Rewrite URL extension" do
      expect(chef_run).to install_windows_package("IIS Rewrite URL extension")
    end
  end
end
