require "chefspec"

describe "opsworks_archive::lwrp" do
  let(:chef_runner) do
    ChefSpec::SoloRunner.new(:step_into => ["opsworks_archive"],
                             :cookbook_path => ["#{::File.dirname(__FILE__)}/../../", "#{::File.dirname(__FILE__)}/support/cookbooks"])
  end

  let(:chef_run) do
    chef_runner.converge(described_recipe)
  end

  context "fallback" do
    it "zip" do
      chef_runner.node.set["opsworks_archive"]["lwrp_test"]["name"] = "fallback zip"
      chef_runner.node.set["opsworks_archive"]["lwrp_test"]["archive"] = "fallback.zip"

      expect(chef_run).to extract_opsworks_archive("fallback zip")
      expect(chef_run).to run_powershell_script("unzip fallback.zip").with(:code => /foreach/)
    end

    it "ZIP" do
      chef_runner.node.set["opsworks_archive"]["lwrp_test"]["name"] = "fallback zip"
      chef_runner.node.set["opsworks_archive"]["lwrp_test"]["archive"] = "fallback.ZIP"

      expect(chef_run).to extract_opsworks_archive("fallback zip")
      expect(chef_run).to run_powershell_script("unzip fallback.ZIP").with(:code => /foreach/)
    end

    it "tgz" do
      chef_runner.node.set["opsworks_archive"]["lwrp_test"]["name"] = "fallback tgz"
      chef_runner.node.set["opsworks_archive"]["lwrp_test"]["archive"] = "fallback.tgz"

      expect(chef_run).to extract_opsworks_archive("fallback tgz")
      expect(chef_run).to run_execute("untar fallback.tgz").with(:command => Regexp.new('tar -x -v -z -f "fallback.tgz" -C "/tmp/"$'))
    end

    it "tar.gz" do
      chef_runner.node.set["opsworks_archive"]["lwrp_test"]["name"] = "fallback tar.gz"
      chef_runner.node.set["opsworks_archive"]["lwrp_test"]["archive"] = "fallback.tar.gz"

      expect(chef_run).to extract_opsworks_archive("fallback tar.gz")
      expect(chef_run).to run_execute("untar fallback.tar.gz").with(:command => Regexp.new('tar -x -v -z -f "fallback.tar.gz" -C "/tmp/"$'))
    end
  end
end
