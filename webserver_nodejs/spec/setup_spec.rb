require "chefspec"

describe "webserver_nodejs::setup" do
  before do
    stub_const('File::ALT_SEPARATOR', "\\")
  end

  let(:chef_runner) do
    ChefSpec::SoloRunner.new
  end

  let(:chef_run) do
    chef_runner.converge(described_recipe)
  end

  context "Webserver setup lifecycle event" do
    it "includes IIS" do
      expect(chef_run).to include_recipe("opsworks_iis")
    end

    it "includes iisnode" do
      expect(chef_run).to include_recipe("opsworks_iisnode")
    end

    it "includes nodejs" do
      expect(chef_run).to include_recipe("opsworks_nodejs")
    end

    it "includes S3 dependency installation" do
      expect(chef_run).to include_recipe("s3_file::dependencies")
    end
  end
end
