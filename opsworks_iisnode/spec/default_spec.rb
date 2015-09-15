require "chefspec"

describe "opsworks_iisnode::default" do
  before do
    stub_const('File::ALT_SEPARATOR', "\\")
  end

  let(:chef_runner) do
    ChefSpec::SoloRunner.new
  end

  let(:chef_run) do
    chef_runner.converge(described_recipe)
  end

  context "IIS Node" do
    before do
      chef_runner.node.set["opsworks_iisnode"]["tmpdir"] = "/tmp/dir"
    end

    it "file is downloaded" do
      expect(chef_run).to create_remote_file(File.join(Chef::Config["file_cache_path"], "iisnode-full-v0.2.18-x64.msi"))
    end

    it "node is installed" do
      expect(chef_run).to install_windows_package("iisnode")
    end
  end
end
