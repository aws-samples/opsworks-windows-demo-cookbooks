require "chefspec"

describe "opsworks_nodejs::default" do
  before do
    stub_const('File::ALT_SEPARATOR', "\\")
  end

  let(:chef_runner) do
    ChefSpec::SoloRunner.new
  end

  let(:chef_run) do
    chef_runner.converge(described_recipe)
  end

  context "Node.JS" do
    it "file is downloaded" do
      expect(chef_run).to create_remote_file(File.join(Chef::Config["file_cache_path"], "node-v0.12.6-x86.msi"))
    end

    it "node is installed" do
      expect(chef_run).to install_windows_package("nodejs")
    end
  end
end
