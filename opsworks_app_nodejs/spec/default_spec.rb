require "chefspec"

describe "opsworks_app_nodejs::default" do

  let(:chef_runner) do
    ChefSpec::SoloRunner.new
  end

  let(:chef_run) do
    chef_runner.converge(described_recipe)
  end

  before do
    stub_const('File::PATH_SEPARATOR', ';')
    stub_const('File::ALT_SEPARATOR', "\\")

    chef_runner.node.set["opsworks_app_nodejs"]["deploy"] = "/tmp"

    allow(File).to receive(:file?).and_return(false)

    stub_search(:aws_opsworks_app) {[{ "shortname" => "helloworld",
                                       "app_source" => {
                                         "url" => "http://foo.example.com",
                                         "type" => "git"
                                       },
                                       "environment" => {}
                                     }]}
  end

  context "Node.JS App" do
    it "does a SCM checkout" do
      expect(chef_run).to sync_opsworks_scm_checkout("helloworld")
    end

    it "creates the deployment directory" do
      expect(chef_run).to create_directory("/tmp/helloworld")
    end

    it "copies the app" do
      expect(chef_run).to run_batch("copy helloworld")
    end

    it "renders web.config template" do
      allow(File).to receive(:file?)
        .with(::File.join(Chef::Config["file_cache_path"], "helloworld", "web.config.erb"))
        .and_return(true)

      expect(chef_run).to create_template("/tmp/helloworld/web.config")
    end

    it "registers the app with IIS" do
      expect(chef_run).to run_powershell_script("register helloworld")
    end
  end
end
