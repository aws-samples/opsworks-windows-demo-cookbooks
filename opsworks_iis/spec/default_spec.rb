require "chefspec"

describe "opsworks_iis::default" do
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
    it "is installed" do
      expect(chef_run).to run_powershell_script("Install IIS feature - Web-Server")
      expect(chef_run).to run_powershell_script("Install IIS feature - Web-Http-Tracing")
      expect(chef_run).to run_powershell_script("Install IIS feature - Web-Http-Redirect")
      expect(chef_run).to run_powershell_script("Install IIS feature - Web-Mgmt-Console")
    end

    it "installs URL Rewrite extension" do
      expect(chef_run).to include_recipe("opsworks_iis::urlrewrite")
    end

    it "drop 'Default Website Site' from IIS" do
      expect(chef_run).to run_powershell_script("drop 'Default Web Site' from IIS")
    end

    it "is started" do
      expect(chef_run).to start_service("w3svc")
      expect(chef_run).to enable_service("w3svc")
    end
  end
end
